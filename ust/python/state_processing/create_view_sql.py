import os
import re

import pandas as pd

from ust.python.state_processing.view_sql_recipes import (
    GREATER_THAN_ONE_YES_NO_COLUMNS,
    RECIPE_FAMILY_LABELS,
    YES_NO_RECIPE_COLUMNS,
    YES_NULL_BUCKET_RECIPE_COLUMNS,
    get_recipe_family,
)
from ust.python.util import utils
from ust.python.util.dataset import Dataset
from ust.python.util.logger_factory import logger

# TODO: when creating v_ust_tank_substance and v_ust_compartment_substance, include substance_comment and populate with organization value


ust_or_release = ''             # Valid values are 'ust' or 'release'
control_id = 0                  # Enter an integer that is the ust_control_id or release_control_id
table_name = ''               # Enter EPA table name we are writing the view to populate. Set to None to generate all required views. 
overwrite_sql_file = True          # Boolean, defaults to True. If True, will overwrite an existing SQL file if it exists. If False, will append to the existing file. 
print_console = False            # Boolean; defaults to False. Set to True to print the create view SQL to the console. 

# These variables can usually be left unset. This script will general a SQL file in the appropriate state folder in the repo under /ust/sql/states
export_file_path = None         
export_file_dir = None
export_file_name = None


def has_recipe_for_column(epa_column_name):
    return (
        epa_column_name in YES_NO_RECIPE_COLUMNS
        or epa_column_name in GREATER_THAN_ONE_YES_NO_COLUMNS
        or epa_column_name in YES_NULL_BUCKET_RECIPE_COLUMNS
    )

class ViewSql:
    def __init__(self, 
                 dataset,
                 table_name,
                 overwrite_sql_file=True,
                 print_console=True,
                 strict=False):
        self.dataset = dataset
        self.table_name = table_name 
        self.strict = strict
        self.conn = None
        self.cur = None
        self.required_cols = {}
        self.existing_cols = {}
        self.required_col_ids = []
        self.existing_col_ids = []
        self.all_col_ids = []
        self.epa_column_name = None
        self.join_info = {}
        self.select_sql = ''
        self.from_sql = ''
        self.where_sql = ''
        self.view_sql = '----------------------------------------------------------------------------------------------------------\n\n'
        self.table_aliases = {}
        self.used_aliases = set()
        self.join_tables = []
        self.mapped_epa_columns = set()
        self.warnings = []
        self._element_rule_cache = {}
        self._element_rule_columns = None
        self._source_column_names_cache = None
        logger.info('Working on table %s', self.table_name)
        if overwrite_sql_file:
            self.overwrite_file()
        self.print_console = print_console
        self.view_name = 'v_' + self.table_name
        self.connect_db()
        try:
            self.generate_sql()
        finally:
            self.disconnect_db()
        self.write_self()


    def connect_db(self):
        if not self.conn:
            self.conn = utils.connect_db()
            self.cur = self.conn.cursor()


    def disconnect_db(self):
        if self.conn:
            self.conn.commit()
            self.cur.close()
            self.conn.close()
            self.conn = None 


    def overwrite_file(self):
        if os.path.isfile(self.dataset.export_file_path):
            with open(self.dataset.export_file_path, 'w'):
                pass  


    def show_existing_cols(self):
        for k, v in self.existing_cols.items():
            print('column ID = ' + str(k))
            print('column_name = ' + v['column_name'])


    def write_self(self):
        with open(self.dataset.export_file_path, 'a', encoding='utf-8') as f:
            f.write(self.view_sql.replace('\t','    '))
        logger.info('Wrote SQL to %s', self.dataset.export_file_path)


    def get_required_cols(self):
        sql = f"""select column_sort_order, a.column_name, a.data_type, a.character_maximum_length
                from information_schema.columns a join public.{self.dataset.ust_or_release}_required_view_columns b 
                    on a.table_name = b.information_schema_table_name and a.column_name = b.column_name
                where table_schema = 'public' and b.table_name = %s 
                order by column_sort_order"""
        self.cur.execute(sql, (self.table_name,))
        # utils.pretty_print_query(self.cur)
        req_col_info = self.cur.fetchall()
        self.required_col_ids = [c[0] for c in req_col_info]
        req_cols = {}
        for req_col in req_col_info:
            column_id = req_col[0]
            column_name = req_col[1]
            data_type = req_col[2]
            character_maximum_length = req_col[3]
            req_cols[column_id] = {'column_name': column_name, 'data_type': data_type, 'character_maximum_length':character_maximum_length}
        # print(req_cols)
        return req_cols


    def _warn(self, message):
        self.warnings.append(message)
        logger.warning(message)


    def _has_value(self, value):
        if value is None:
            return False
        if isinstance(value, float) and pd.isna(value):
            return False
        text = str(value).strip()
        return text != '' and text.lower() != 'nan'


    def _preflight(self):
        try:
            self.join_tables = utils.get_join_tables(self.dataset, self.table_name)
        except Exception as exc:
            msg = f'Unable to retrieve join metadata for {self.table_name}: {exc}'
            if self.strict:
                raise RuntimeError(msg) from exc
            self._warn(msg)
            self.join_tables = []

        if not self.join_tables:
            msg = f'No join metadata found for {self.table_name}; SQL will include placeholders and may need manual edits.'
            if self.strict:
                raise RuntimeError(msg)
            self._warn(msg)


    def _get_fallback_source_table(self):
        sql = f"""select coalesce(deagg_table_name, organization_table_name)
                  from public.v_{self.dataset.ust_or_release}_element_mapping_joins
                  where {self.dataset.ust_or_release}_control_id = %s
                  and epa_table_name = %s
                  and coalesce(deagg_table_name, organization_table_name) is not null
                  order by column_sort_order
                  limit 1"""
        self.cur.execute(sql, (self.dataset.control_id, self.table_name))
        row = self.cur.fetchone()
        if not row:
            return None
        return row[0]


    def _get_trimmed_text_expression(self, source_expression):
        return f"nullif(trim({source_expression}::text), '')"


    def _get_trimmed_source_text(self, org_column_name):
        return self._get_trimmed_text_expression(f'"{org_column_name}"')


    def _build_safe_key_expression(self, source_expression, data_type):
        source_text = self._get_trimmed_text_expression(source_expression)

        if data_type in {'smallint', 'integer', 'bigint'}:
            return (
                f"case when {source_text} ~ '^[+-]?\\d+$' "
                f'then {source_text}::{data_type} else null::{data_type} end'
            )

        return source_text


    def _build_safe_cast_expression(self, org_column_name, data_type, max_len):
        source_text = self._get_trimmed_source_text(org_column_name)
        datatype_sql = utils.get_datatype_sql(data_type, max_len)

        if data_type == 'character varying':
            return f'{source_text}::{datatype_sql}'

        if data_type in {'smallint', 'integer', 'bigint'}:
            return (
                f"case when {source_text} ~ '^[+-]?\\d+$' "
                f'then {source_text}::{data_type} else null::{data_type} end'
            )

        if data_type in {'numeric', 'double precision', 'real'}:
            return (
                f"case when {source_text} ~ '^[+-]?(\\d+(\\.\\d+)?|\\.\\d+)$' "
                f'then {source_text}::{data_type} else null::{data_type} end'
            )

        if data_type == 'date':
            return (
                f"case when {source_text} is null then null::date "
                f"when {source_text} ~ '^\\d{{4}}-\\d{{2}}-\\d{{2}}$' then {source_text}::date "
                f"when {source_text} ~ '^\\d{{1,2}}/\\d{{1,2}}/\\d{{4}}$' then to_date({source_text}, 'MM/DD/YYYY') "
                f'else null::date end'
            )

        if data_type in {'timestamp without time zone', 'timestamp with time zone'}:
            return (
                f"case when {source_text} is null then null::{data_type} "
                f"when {source_text} ~ '^\\d{{4}}-\\d{{2}}-\\d{{2}}([ T]\\d{{2}}:\\d{{2}}(:\\d{{2}}(\\.\\d+)?)?)?$' "
                f'then {source_text}::{data_type} else null::{data_type} end'
            )

        if data_type == 'boolean':
            return (
                f"case when lower({source_text}) in ('true', 't', 'yes', 'y', '1') then true "
                f"when lower({source_text}) in ('false', 'f', 'no', 'n', '0') then false "
                f'else null::boolean end'
            )

        return f'{source_text}::{datatype_sql}'


    def _build_yes_no_recipe_expression(self, org_column_name, truthy_values=None, falsey_values=None):
        source_text = self._get_trimmed_source_text(org_column_name)
        truthy_values = truthy_values or ['true', 't', 'yes', 'y', '1', '1.0']
        falsey_values = falsey_values or ['false', 'f', 'no', 'n', '0', '0.0']

        truthy_sql = ', '.join("'" + value.replace("'", "''") + "'" for value in truthy_values)
        falsey_sql = ', '.join("'" + value.replace("'", "''") + "'" for value in falsey_values)
        return (
            f"case when lower({source_text}) in ({truthy_sql}) then 'Yes'::text "
            f"when lower({source_text}) in ({falsey_sql}) then 'No'::text "
            f'else null::text end'
        )


    def _build_greater_than_one_recipe_expression(self, org_column_name):
        source_text = self._get_trimmed_source_text(org_column_name)
        return (
            f"case when {source_text} ~ '^[+-]?\\d+(\\.0+)?$' and ({source_text})::numeric > 1 then 'Yes'::text "
            f"when {source_text} ~ '^[+-]?\\d+(\\.0+)?$' then 'No'::text "
            f'else null::text end'
        )


    def _build_yes_null_bucket_recipe_expression(self, org_column_name, match_type, values):
        source_text = self._get_trimmed_source_text(org_column_name)
        lowered_source = f'lower({source_text})'
        normalized_values = [value.lower() for value in values]

        if match_type == 'equals_any':
            value_sql = ', '.join("'" + value.replace("'", "''") + "'" for value in normalized_values)
            return (
                f"case when {lowered_source} in ({value_sql}) then 'Yes'::text "
                f'else null::text end'
            )

        if match_type == 'like_any':
            predicates = [f"{lowered_source} like '{value.replace("'", "''")}'" for value in normalized_values]
            return (
                f"case when {' or '.join(predicates)} then 'Yes'::text "
                f'else null::text end'
            )

        return None


    def _build_recipe_expression(self, epa_column_name, org_column_name, data_type):
        if data_type != 'character varying':
            return None

        recipe_config = YES_NO_RECIPE_COLUMNS.get(epa_column_name)
        if recipe_config:
            return self._build_yes_no_recipe_expression(
                org_column_name,
                truthy_values=recipe_config.get('truthy_values'),
            )

        bucket_recipe = YES_NULL_BUCKET_RECIPE_COLUMNS.get(epa_column_name)
        if bucket_recipe:
            return self._build_yes_null_bucket_recipe_expression(
                org_column_name,
                match_type=bucket_recipe['match_type'],
                values=bucket_recipe['values'],
            )

        if epa_column_name in GREATER_THAN_ONE_YES_NO_COLUMNS:
            return self._build_greater_than_one_recipe_expression(org_column_name)

        return None


    def _has_recipe_for_column(self, epa_column_name):
        return has_recipe_for_column(epa_column_name)
            

    def get_column_select_sql(self, epa_column_name, org_column_name):
        if not self._has_value(org_column_name):
            return f'???? as {epa_column_name}'
        epa_table_name = self.table_name
        if epa_column_name == 'facility_id' and self.table_name != 'ust_facility':
            epa_table_name = 'ust_facility'
        elif (epa_column_name == 'tank_id' or epa_column_name == 'tank_name') and self.table_name != 'ust_tank':
            epa_table_name = 'ust_tank'
        elif (epa_column_name == 'compartment_id' or epa_column_name == 'compartment_name') and self.table_name != 'ust_compartment':
            epa_table_name = 'ust_compartment'

        sql = """select data_type, character_maximum_length from information_schema.columns 
                 where table_schema = 'public' and table_name = %s and column_name = %s"""
        self.cur.execute(sql, (epa_table_name, epa_column_name))
        # utils.pretty_print_query(self.cur)
        row = self.cur.fetchone()
        if not row:
            self._warn(f'No datatype metadata found for {epa_table_name}.{epa_column_name}; using placeholder SQL.')
            return f'???? as {epa_column_name}'
        data_type = row[0]
        max_len = row[1]
        selected_column = self._build_recipe_expression(epa_column_name, org_column_name, data_type)
        if not selected_column:
            selected_column = self._build_safe_cast_expression(org_column_name, data_type, max_len)
        selected_column = selected_column + ' as ' + epa_column_name

        return selected_column 


    def _apply_table_alias(self, organization_table_name, selected_column):
        alias = self.table_aliases.get(organization_table_name)
        if not alias:
            return selected_column

        select_alias = self._extract_select_alias(selected_column)
        expression = self._extract_select_expression(selected_column)

        # Qualify unqualified quoted source identifiers inside the expression,
        # but do not prefix the entire expression (which breaks case/function SQL).
        qualified_expression = re.sub(
            r'(?<![\w.])"([^"]+)"',
            lambda m: f'{alias}."{m.group(1)}"',
            expression,
        )

        if select_alias:
            return qualified_expression + ' as ' + select_alias
        return qualified_expression


    def _extract_select_alias(self, selected_column):
        alias_token = ' as '
        selected_column_lower = selected_column.lower()
        if alias_token not in selected_column_lower:
            return None
        alias_start = selected_column_lower.rfind(alias_token) + len(alias_token)
        return selected_column[alias_start:].strip()


    def _extract_select_expression(self, selected_column):
        alias_token = ' as '
        selected_column_lower = selected_column.lower()
        if alias_token not in selected_column_lower:
            return selected_column.strip()
        alias_start = selected_column_lower.rfind(alias_token)
        return selected_column[:alias_start].strip()


    def _extract_source_column_expression(self, organization_column_name, organization_table_name):
        if not self._has_value(organization_column_name):
            return None
        alias = self.table_aliases.get(organization_table_name)
        if alias:
            return f'{alias}."{organization_column_name}"'
        return f'"{organization_column_name}"'


    def _get_element_rule_columns(self):
        if self._element_rule_columns is not None:
            return self._element_rule_columns

        table_name = f'{self.dataset.ust_or_release}_elements'
        sql = """select column_name
                 from information_schema.columns
                 where table_schema = 'public' and table_name = %s"""
        self.cur.execute(sql, (table_name,))
        self._element_rule_columns = {row[0] for row in self.cur.fetchall()}
        return self._element_rule_columns


    def _get_source_column_names(self):
        if self._source_column_names_cache is not None:
            return self._source_column_names_cache

        sql = f"""select distinct organization_column_name
                  from public.{self.dataset.ust_or_release}_element_mapping
                  where {self.dataset.ust_or_release}_control_id = %s
                    and epa_table_name = %s
                    and organization_column_name is not null
                  order by 1"""
        self.cur.execute(sql, (self.dataset.control_id, self.table_name))
        rows = self.cur.fetchall()
        self._source_column_names_cache = [
            row[0] for row in rows if self._has_value(row[0])
        ]
        return self._source_column_names_cache


    def _replace_outside_single_quotes(self, text, replacement_func):
        if "'" not in text:
            return replacement_func(text)

        parts = text.split("'")
        for idx in range(0, len(parts), 2):
            parts[idx] = replacement_func(parts[idx])
        return "'".join(parts)


    def _quote_unquoted_source_columns(self, sql_text):
        source_columns = self._get_source_column_names()
        if not source_columns:
            return sql_text

        def quote_in_segment(segment):
            updated = segment
            # Process longer names first to avoid partial replacements.
            for source_col in sorted(set(source_columns), key=len, reverse=True):
                if not re.fullmatch(r'[A-Za-z_][A-Za-z0-9_]*', source_col):
                    continue
                quoted_col = f'"{source_col}"'

                # Quote unquoted alias.column patterns while preserving alias.
                updated = re.sub(
                    rf'\b([A-Za-z_][A-Za-z0-9_]*)\.{re.escape(source_col)}\b',
                    lambda m, qc=quoted_col: f'{m.group(1)}.{qc}',
                    updated,
                )

                # Quote bare source column names not already quoted or qualified.
                updated = re.sub(
                    rf'(?<![\w."])\b{re.escape(source_col)}\b(?!["])',
                    quoted_col,
                    updated,
                )
            return updated

        return self._replace_outside_single_quotes(sql_text, quote_in_segment)


    def _get_epa_column_rules(self, epa_column_name):
        if not self._has_value(epa_column_name):
            return {}
        if epa_column_name in self._element_rule_cache:
            return self._element_rule_cache[epa_column_name]

        available_columns = self._get_element_rule_columns()
        if not available_columns:
            self._element_rule_cache[epa_column_name] = {}
            return {}

        select_parts = [
            'allowed_values' if 'allowed_values' in available_columns else 'null::text as allowed_values',
            'lookup_table' if 'lookup_table' in available_columns else 'null::text as lookup_table',
            'database_lookup_table' if 'database_lookup_table' in available_columns else 'null::text as database_lookup_table',
        ]
        if 'business_rules' in available_columns:
            select_parts.append('business_rules')
        elif 'business_rule' in available_columns:
            select_parts.append('business_rule as business_rules')
        else:
            select_parts.append('null::text as business_rules')

        sql = f"""select {', '.join(select_parts)}
                  from public.{self.dataset.ust_or_release}_elements
                  where database_column_name = %s
                  limit 1"""
        self.cur.execute(sql, (epa_column_name,))
        row = self.cur.fetchone()
        if not row:
            rules = {}
        else:
            rules = {
                'allowed_values': row[0],
                'lookup_table': row[1],
                'database_lookup_table': row[2],
                'business_rules': row[3],
            }
        self._element_rule_cache[epa_column_name] = rules
        return rules


    def _is_yes_no_unknown_column(self, epa_column_name):
        rules = self._get_epa_column_rules(epa_column_name)
        if not rules:
            return False

        text_parts = []
        for key in ['allowed_values', 'lookup_table', 'database_lookup_table', 'business_rules']:
            value = rules.get(key)
            if self._has_value(value):
                text_parts.append(str(value).lower())
        if not text_parts:
            return False

        rules_text = ' | '.join(text_parts)
        yes_no_unknown_markers = [
            'yes/no/unknown',
            'yes, no, unknown',
            'yes no unknown',
            'yes-no-unknown',
            'unknown/yes/no',
            'unknown, yes, no',
            'unknown yes no',
            'yes_no_unknown',
        ]
        if any(marker in rules_text for marker in yes_no_unknown_markers):
            return True

        # Some fields use business_rule text like "Yes\nNo" without explicitly listing Unknown.
        return bool(re.search(r'\byes\b', rules_text) and re.search(r'\bno\b', rules_text))


    def _build_yes_literal(self, selected_expression):
        cast_match = re.search(r'::([A-Za-z_ ]+(?:\(\d+(?:\s*,\s*\d+)?\))?)\s*$', selected_expression.strip(), flags=re.IGNORECASE)
        if cast_match:
            return f"'Yes'::{cast_match.group(1)}"
        return "'Yes'::text"


    def _comment_lines(self, text):
        comment_lines = [line.rstrip() for line in text.splitlines() if line.strip()]
        return ' '.join('-- ' + line for line in comment_lines)


    def _strip_unknown_aliases(self, sql_expression):
        valid_aliases = self.used_aliases or set(self.table_aliases.values())

        def replace_alias(match):
            alias = match.group(1)
            column_ref = match.group(2)
            if alias in valid_aliases:
                return match.group(0)
            return column_ref

        return re.sub(
            r'\b([A-Za-z_]\w*)\.("[^"]+"|[A-Za-z_]\w*)',
            replace_alias,
            sql_expression,
        )


    def _quote_simple_sql_literal(self, value):
        trimmed_value = value.strip().rstrip(',')
        if not trimmed_value:
            return trimmed_value

        cast_suffix = ''
        cast_match = re.match(r'^(.*?)(::[A-Za-z_ ]+)$', trimmed_value)
        if cast_match:
            trimmed_value = cast_match.group(1).strip()
            cast_suffix = cast_match.group(2)

        lowered = trimmed_value.lower()
        if lowered in {'null', 'true', 'false'}:
            return lowered + cast_suffix
        if trimmed_value.startswith("'") and trimmed_value.endswith("'"):
            return trimmed_value + cast_suffix
        if re.fullmatch(r'[+-]?\d+(\.\d+)?(::[a-z_ ]+)?', trimmed_value, flags=re.IGNORECASE):
            return trimmed_value + cast_suffix
        if '::' in trimmed_value or '(' in trimmed_value:
            return trimmed_value + cast_suffix
        return "'" + trimmed_value.replace("'", "''") + "'" + cast_suffix


    def _normalize_query_logic(self, logic_sql):
        logic_sql = logic_sql.replace('\r\n', '\n')
        logic_sql = re.sub(r',\s*(when\b|else\b)', r'\n\1', logic_sql, flags=re.IGNORECASE)
        logic_sql = re.sub(r'\belse\s+nul(?:l)?\b(?:\s+en(?:d)?)?', 'else null', logic_sql, flags=re.IGNORECASE)
        return logic_sql


    def _normalize_query_logic_literals(self, logic_sql):
        def normalize_array(match):
            array_values = [value.strip() for value in match.group(1).split(',')]
            normalized_values = [self._quote_simple_sql_literal(value) for value in array_values if value]
            return 'ARRAY[' + ', '.join(normalized_values) + ']'

        def normalize_date_function(match):
            function_name = match.group(1)
            source_arg = match.group(2).strip()
            format_arg = self._quote_simple_sql_literal(match.group(3))
            return f'{function_name}({source_arg}, {format_arg})'

        logic_sql = re.sub(r'ARRAY\[(.*?)\]', normalize_array, logic_sql, flags=re.IGNORECASE)
        logic_sql = re.sub(
            r'\b(to_date|to_timestamp)\s*\(\s*(.+?)\s*,\s*([^\)]+?)\s*\)',
            normalize_date_function,
            logic_sql,
            flags=re.IGNORECASE,
        )
        logic_sql = re.sub(
            r'\b(then|else)\s+([^\n]+?)(?=(\s+when\b|\s+else\b|\s+end\b|$))',
            lambda m: f"{m.group(1)} {self._quote_simple_sql_literal(m.group(2))}",
            logic_sql,
            flags=re.IGNORECASE,
        )
        logic_sql = re.sub(
            r'(~~\s+)([^\s][^\n]*?)(?=(\s+then\b|\s+else\b|\s+and\b|\s+or\b|$))',
            lambda m: m.group(1) + self._quote_simple_sql_literal(m.group(2)),
            logic_sql,
            flags=re.IGNORECASE,
        )
        logic_sql = re.sub(
            r'((?:like|ilike)\s+)([^\s][^\n]*?)(?=(\s+then\b|\s+else\b|\s+and\b|\s+or\b|$))',
            lambda m: m.group(1) + self._quote_simple_sql_literal(m.group(2)),
            logic_sql,
            flags=re.IGNORECASE,
        )
        return logic_sql


    def _compile_query_logic(self, query_logic, selected_column, organization_column_name=None, organization_table_name=None, epa_column_name=None):
        alias = self._extract_select_alias(selected_column)
        selected_expression = self._extract_select_expression(selected_column)
        source_expression = self._extract_source_column_expression(organization_column_name, organization_table_name)
        source_text = self._get_trimmed_text_expression(source_expression) if source_expression else None

        logic_sql = query_logic.strip()
        if not logic_sql:
            return None

        lowered_logic = logic_sql.lstrip().lower()
        if not lowered_logic.startswith(('when ', 'else ', 'case ', 'where =')):
            raw_predicate = logic_sql.rstrip(',').strip()
            explicit_alias = None
            alias_match = re.match(r'^(.*?)\s+as\s+([A-Za-z_][\w]*)\s*$', raw_predicate, flags=re.IGNORECASE)
            if alias_match:
                raw_predicate = alias_match.group(1).strip()
                explicit_alias = alias_match.group(2).strip()

            if not raw_predicate:
                return None

            if source_expression and organization_column_name:
                raw_predicate = re.sub(
                    rf'\b[a-zA-Z_]\w*\."{re.escape(organization_column_name)}"',
                    source_expression,
                    raw_predicate,
                )
                raw_predicate = re.sub(
                    rf'\b[a-zA-Z_]\w*\.{re.escape(organization_column_name)}(?![\w"])',
                    source_expression,
                    raw_predicate,
                )
                raw_predicate = re.sub(
                    rf'(?<![\w."])"{re.escape(organization_column_name)}"(?![\w"])',
                    source_expression,
                    raw_predicate,
                )
                raw_predicate = re.sub(
                    rf'(?<![\w."]) {re.escape(organization_column_name)}(?![\w"])',
                    source_expression,
                    raw_predicate,
                    flags=re.VERBOSE,
                )

            raw_predicate = self._quote_unquoted_source_columns(raw_predicate)
            raw_predicate = self._normalize_query_logic_literals(raw_predicate)
            raw_predicate = self._strip_unknown_aliases(raw_predicate)

            lowered_predicate = raw_predicate.lower()
            operators = ['=', '<', '>', '<=', '>=', '<>', '!=', '~~', ' like ', ' ilike ', ' is ', ' in ', ' any(']
            if source_text and not any(operator in lowered_predicate for operator in operators):
                raw_predicate = f'{source_text} = {self._quote_simple_sql_literal(raw_predicate)}'

            target_alias = explicit_alias or alias
            if not target_alias:
                return None

            true_expression = selected_expression
            if self._is_yes_no_unknown_column(epa_column_name):
                true_expression = self._build_yes_literal(selected_expression)

            return (
                f'case when {raw_predicate} then {true_expression} '
                f'else null end as {target_alias}'
            )

        logic_sql = self._normalize_query_logic(logic_sql)
        logic_sql = self._quote_unquoted_source_columns(logic_sql)
        logic_sql = self._strip_unknown_aliases(logic_sql)

        if source_expression and organization_column_name:
            logic_sql = re.sub(
                rf'\b[a-zA-Z_]\w*\."{re.escape(organization_column_name)}"',
                source_expression,
                logic_sql,
            )
            logic_sql = re.sub(
                rf'\b[a-zA-Z_]\w*\.{re.escape(organization_column_name)}(?![\w"])',
                source_expression,
                logic_sql,
            )
            logic_sql = re.sub(
                rf'(?<![\w."])"{re.escape(organization_column_name)}"(?![\w"])',
                source_expression,
                logic_sql,
            )
            logic_sql = re.sub(
                rf'(?<![\w."]) {re.escape(organization_column_name)}(?![\w"])',
                source_expression,
                logic_sql,
                flags=re.VERBOSE,
            )

        logic_sql = self._normalize_query_logic_literals(logic_sql)
        logic_sql = re.sub(r'(?<![\w.])"([^"]+)"', lambda m: self._quote_simple_sql_literal(m.group(1)), logic_sql)

        if source_text:
            logic_sql = re.sub(
                r'^\s*where\s*=\s*(.+)$',
                lambda m: f"when {source_text} = {self._quote_simple_sql_literal(m.group(1))}",
                logic_sql,
                flags=re.IGNORECASE | re.MULTILINE,
            )
            logic_sql = re.sub(
                r'(^|\n)\s*when\s+in\s+(.+?)\s+then\s+',
                lambda m: f"{m.group(1)}when {source_text} in ({m.group(2).strip()}) then ",
                logic_sql,
                flags=re.IGNORECASE,
            )
            logic_sql = re.sub(
                r'(^|\n)\s*when\s+((?:\'[^\']*\'\s*,\s*)+\'[^\']*\')\s+then\s+',
                lambda m: f"{m.group(1)}when {source_text} in ({m.group(2).strip()}) then ",
                logic_sql,
                flags=re.IGNORECASE,
            )

            def rewrite_simple_when(match):
                clause = match.group(2).strip()
                lowered_clause = clause.lower()
                operators = ['=', '<', '>', '<=', '>=', '<>', '!=', '~~', ' like ', ' ilike ', ' is ', ' in ', ' any(']
                if any(operator in lowered_clause for operator in operators):
                    return match.group(0)
                return f"{match.group(1)}when {source_text} = {self._quote_simple_sql_literal(clause)} then "

            logic_sql = re.sub(
                r'(^|\n)\s*when\s+(.+?)\s+then\s+',
                rewrite_simple_when,
                logic_sql,
                flags=re.IGNORECASE,
            )

            logic_sql = self._normalize_query_logic(logic_sql)

        stripped_logic = logic_sql.lstrip().lower()
        if stripped_logic.startswith(('when ', 'else ')):
            logic_sql = 'case\n' + logic_sql
            if not logic_sql.rstrip().lower().endswith('end'):
                logic_sql += '\nend'

        if self._extract_select_alias(logic_sql) is None and alias:
            logic_sql = logic_sql.rstrip(',') + ' as ' + alias

        if not re.match(r'^(case\b|coalesce\b|nullif\b|upper\b|lower\b|trim\b|substring\b|regexp_replace\b|to_date\b|to_timestamp\b|cast\b|\()', logic_sql.lstrip(), flags=re.IGNORECASE):
            return None

        return logic_sql


    def _build_query_logic_select_item(self, selected_column, query_logic):
        logic_lines = [line.rstrip() for line in query_logic.strip().splitlines() if line.strip()]
        if not logic_lines:
            return '\t' + selected_column.rstrip(',')

        logic_sql = '\n'.join(logic_lines)
        if self._extract_select_alias(logic_sql) is None:
            alias = self._extract_select_alias(selected_column)
            if alias:
                logic_sql = logic_sql.rstrip(',') + ' as ' + alias

        formatted_lines = logic_sql.splitlines()
        select_item = '\t' + formatted_lines[0]
        for continuation_line in formatted_lines[1:]:
            select_item += '\n\t' + continuation_line

        source_comment = self._comment_lines('AUTO-GENERATED SOURCE: ' + selected_column.rstrip(','))
        if source_comment:
            select_item = '\t' + source_comment + '\n' + select_item

        return select_item


    def _format_select_item(self, selected_column, query_logic, organization_column_name=None, organization_table_name=None, epa_column_name=None):
        if not query_logic:
            return '\t' + selected_column.rstrip(',')

        compiled_logic = self._compile_query_logic(
            query_logic,
            selected_column,
            organization_column_name=organization_column_name,
            organization_table_name=organization_table_name,
            epa_column_name=epa_column_name,
        )
        if compiled_logic:
            formatted_lines = compiled_logic.splitlines()
            select_item = '\t' + formatted_lines[0]
            for continuation_line in formatted_lines[1:]:
                select_item += '\n\t' + continuation_line
            compiled_comment = self._comment_lines('AUTO-COMPILED FROM QUERY_LOGIC')
            if compiled_comment:
                select_item = '\t' + compiled_comment + '\n' + select_item
            return select_item

        return self._build_query_logic_select_item(selected_column, query_logic)


    def _get_direct_required_mappings(self):
        missing_required_columns = [
            col_info['column_name']
            for col_info in self.required_cols.values()
            if col_info['column_name'] not in self.mapped_epa_columns
        ]
        if not missing_required_columns:
            return {}

        sql = f"""select epa_column_name,
                    organization_column_name,
                    organization_table_name
            from public.{self.dataset.ust_or_release}_element_mapping
            where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s
            and epa_column_name = any(%s)
            order by epa_column_name"""
        self.cur.execute(sql, (self.dataset.control_id, self.table_name, missing_required_columns))

        required_column_ids = {
            col_info['column_name']: column_id
            for column_id, col_info in self.required_cols.items()
        }

        direct_cols = {}
        for epa_column_name, organization_column_name, organization_table_name in self.cur.fetchall():
            column_id = required_column_ids.get(epa_column_name)
            if column_id is None:
                self._warn(
                    f'Unable to determine required column order for {self.table_name}.{epa_column_name}; skipping direct mapping.'
                )
                continue
            selected_column = self.get_column_select_sql(epa_column_name, organization_column_name)
            selected_column = self._apply_table_alias(organization_table_name, selected_column).strip()
            selected_column = selected_column.removesuffix(',')
            direct_cols[column_id] = {
                'column_name': epa_column_name,
                'selected_column': selected_column,
                'query_logic': '',
                'organization_table_name': organization_table_name,
                'organization_column_name': organization_column_name,
            }
            self.mapped_epa_columns.add(epa_column_name)

        return direct_cols


    def get_existing_cols(self):
        sql = f"""select column_sort_order as column_id, 
                    epa_column_name, 
                    organization_column_name, 
                    selected_column, query_logic,
                    organization_table_name
            from public.v_{self.dataset.ust_or_release}_table_population_sql
            where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s
            and column_sort_order is not null
            order by column_sort_order """
        self.cur.execute(sql, (self.dataset.control_id, self.table_name))
        # utils.pretty_print_query(self.cur)
        existing_col_info = self.cur.fetchall()
        self.mapped_epa_columns = set()
        existing_cols = {}
        for existing_col in existing_col_info:
            column_id = existing_col[0]
            epa_column_name = existing_col[1]
            organization_column_name = existing_col[2]
            selected_column = existing_col[3]
            query_logic = existing_col[4]
            organization_table_name = existing_col[5]
            if query_logic and self._has_recipe_for_column(epa_column_name):
                self._warn(
                    f'Overriding query_logic for {self.table_name}.{epa_column_name} with standardized recipe SQL.'
                )
                selected_column = self.get_column_select_sql(epa_column_name, organization_column_name)
                query_logic = ''
            if not selected_column:
                selected_column = self.get_column_select_sql(epa_column_name, organization_column_name)
                selected_column = self._apply_table_alias(organization_table_name, selected_column)
            selected_column = selected_column.strip()
            selected_column = selected_column.removesuffix(',')
            if query_logic:
                query_logic = query_logic.strip()
            else:
                query_logic = ''
            existing_cols[column_id] = {'column_name': epa_column_name, 
                                        'selected_column': selected_column, 
                                        'query_logic': query_logic,
                                        'organization_table_name': organization_table_name,
                                        'organization_column_name': organization_column_name}
            self.mapped_epa_columns.add(epa_column_name)

        direct_cols = self._get_direct_required_mappings()
        existing_cols.update(direct_cols)

        if not existing_cols:
            self._warn(f'No mapped elements found for EPA table {self.table_name}; generating required placeholders only.')
            self.existing_col_ids = []
            return {}

        self.existing_col_ids = sorted(existing_cols)
        return existing_cols


    def build_where_sql(self):
        if self.dataset.ust_or_release == 'ust':
            parent_table = 'ust_facility'
            parent_col = 'facility_id'
            parent_unreg_table = 'erg_unregulated_facilities'
            child_unreg_table = 'erg_unregulated_tanks'
            cols = ['facility_id', 'tank_id', 'substance_id']
        else:
            parent_table = 'ust_release'
            parent_col = 'release_id'
            parent_unreg_table = 'erg_unregulated_releases'
            child_unreg_table = 'erg_unregulated_substances'
            cols = ['release_id', 'substance_id']
        fk_col = ''
        if 'substance' in self.table_name:
            fk_col = 'substance'
        elif 'cause' in self.table_name:
            fk_col = 'cause'
        elif 'source' in self.table_name:
            fk_col = 'source'
        elif 'corrective' in self.table_name:
            fk_col = 'corrective_action_strategy'

        if fk_col:
            self.where_sql = f'\nwhere {fk_col}_id is not null and'
        else:
            self.where_sql = "\nwhere"

        sql = f"""select organization_column_name, epa_column_name 
                  from public.{self.dataset.ust_or_release}_element_mapping 
                  where {self.dataset.ust_or_release}_control_id = %s 
                  and epa_table_name = %s and epa_column_name = any(array{cols})
                  order by 2"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, self.table_name))
        rows = self.cur.fetchall()

        org_parent_col = ''
        org_child_col = ''
        for row in rows:
            if row[1] == parent_col:
                org_parent_col = row[0]
            else:
                org_child_col = row[0]

        if not self._has_value(org_parent_col):
            msg = f'Missing mapping for required key {parent_col} in {self.table_name}; using where 1=1 fallback.'
            if self.strict:
                raise RuntimeError(msg)
            self._warn(msg)
            self.where_sql = '\nwhere 1=1\n\n-- ADD ADDITIONAL SQL HERE IF NECESSARY\n;\n'
            return

        parent_expression = self._build_safe_key_expression(f'a."{org_parent_col}"', 'character varying')
        child_expression = None
        if self._has_value(org_child_col):
            if self.dataset.ust_or_release == 'ust':
                child_expression = self._build_safe_key_expression(f'a."{org_child_col}"', 'integer')
            else:
                child_expression = self._build_safe_key_expression(f'a."{org_child_col}"', 'character varying')
        elif self.table_name != parent_table:
            self._warn(f'No child join mapping found for {self.table_name}; unregulated exclusion uses parent key only.')

        exclusion_predicates = []
        if self.dataset.ust_or_release == 'ust':
            if self.table_name == parent_table:
                exclusion_predicates.append(
                    f"not exists\n\t(select 1 from {self.dataset.schema}.{parent_unreg_table} unreg\n"
                    f"\twhere {parent_expression} = unreg.{parent_col})"
                )
            else:
                # Always exclude unregulated facilities for UST child views.
                exclusion_predicates.append(
                    f"not exists\n\t(select 1 from {self.dataset.schema}.{parent_unreg_table} unreg_fac\n"
                    f"\twhere {parent_expression} = unreg_fac.{parent_col})"
                )
                # Exclude unregulated tanks when child key mapping is available.
                if child_expression is not None:
                    exclusion_predicates.append(
                        f"not exists\n\t(select 1 from {self.dataset.schema}.{child_unreg_table} unreg_tank\n"
                        f"\twhere {parent_expression} = unreg_tank.{parent_col} and {child_expression} = unreg_tank.tank_id)"
                    )
        else:
            if self.table_name == parent_table:
                exclusion_predicates.append(
                    f"not exists\n\t(select 1 from {self.dataset.schema}.{parent_unreg_table} unreg\n"
                    f"\twhere {parent_expression} = unreg.{parent_col})"
                )
            elif child_expression is not None:
                exclusion_predicates.append(
                    f"not exists\n\t(select 1 from {self.dataset.schema}.{child_unreg_table} unreg\n"
                    f"\twhere {parent_expression} = unreg.{parent_col} and {child_expression} = unreg.substance_id)"
                )
            else:
                exclusion_predicates.append(
                    f"not exists\n\t(select 1 from {self.dataset.schema}.{parent_unreg_table} unreg\n"
                    f"\twhere {parent_expression} = unreg.{parent_col})"
                )

        self.where_sql += ' ' + '\nand '.join(exclusion_predicates) + '\n'

        # Keep child views aligned with downstream populate joins by only keeping rows
        # whose parent key exists in the corresponding parent view.
        if self.table_name != parent_table:
            parent_view_name = 'v_' + parent_table
            self.where_sql += (
                f"and exists\n\t(select 1 from {self.dataset.schema}.{parent_view_name} parent\n"
                f"\twhere parent.{parent_col} = {parent_expression})\n"
            )

        self.where_sql = self.where_sql + '\n-- ADD ADDITIONAL SQL HERE IF NECESSARY\n;\n'


    def build_from_sql(self, from_table, alias, join_alias):
        clause_added = False
        if self.join_info['table_type'] == 'lookup':
            self.from_sql = self.from_sql + '\n\tleft join ' + self.dataset.schema + '.' + from_table + ' ' + alias + ' on ' + join_alias + '."' + self.join_info['organization_join_column'] + '" = ' + alias + '.organization_value'
            clause_added = True
        else:
            if self._has_value(self.join_info['organization_join_column']) and self._has_value(self.join_info['organization_join_fk']):
                self.from_sql = self.from_sql + '\n\tleft join ' + self.dataset.schema + '."' + from_table + '" ' + alias + ' on ' + join_alias + '."' + self.join_info['organization_join_column'] + '" = ' + alias + '."' + self.join_info['organization_join_fk'] + '" '
                clause_added = True
            if self._has_value(self.join_info['organization_join_column2']) and self._has_value(self.join_info['organization_join_fk2']):
                self.from_sql = self.from_sql + 'and ' + join_alias + '."' + self.join_info['organization_join_column2'] + '" = ' + alias + '."' + self.join_info['organization_join_fk2'] + '" '
                clause_added = True
            if self._has_value(self.join_info['organization_join_column3']) and self._has_value(self.join_info['organization_join_fk3']):
                self.from_sql = self.from_sql + 'and ' + join_alias + '."' + self.join_info['organization_join_column3'] + '" = ' + alias + '."' + self.join_info['organization_join_fk3'] + '" '
                clause_added = True

        if clause_added:
            self.used_aliases.add(alias)


    def build_from_query(self):
        self.from_sql = 'from '
        self.used_aliases = set()

        if not self.join_tables:
            fallback_table = self._get_fallback_source_table()
            if fallback_table:
                self.from_sql = self.from_sql + self.dataset.schema + '."' + fallback_table + '" a'
                self.table_aliases[fallback_table] = 'a'
                self.used_aliases.add('a')
                self._warn(f'Using fallback source table {fallback_table} for {self.table_name}.')
            else:
                self.from_sql = self.from_sql + '(select 1) a'
                self.used_aliases.add('a')
            return

        df = pd.DataFrame(self.join_tables)
        df.set_index('organization_table_name', inplace=True)
        # print(df.to_string())
        # print('----------------------------------------------------------------------------------------------------------------------\n')
        # exit()

        for from_table, row in df.iterrows():
            # logger.info('Working on table %s', from_table)
            self.join_info = row
            alias = row['alias']

            if alias == 'a':
                self.from_sql = self.from_sql + self.dataset.schema + '.' + '"' + from_table + '" ' + alias
                self.table_aliases[from_table] = alias
                self.used_aliases.add(alias)

            else:
                try:
                    join_alias = df.loc[self.join_info['organization_join_table']]['alias']
                except KeyError:
                    join_alias = 'a'
                # print('alias = ' + alias)
                # print('join_alias = ' + join_alias)
                self.build_from_sql(from_table, alias, join_alias)
                self.table_aliases[from_table] = alias

            # print('__________________________________________________________________________________________________________________\n')


    def build_select_query(self):
        select_items = []
        region_next = False 
        for i in range(len(self.all_col_ids)):
            # deal with EPARegion column if in ust_facility and the last column was FacilityState
            if region_next:
                selected_column = str(utils.get_epa_region(self.dataset.organization_id)) + '::integer as facility_epa_region,'
                select_items.append('\t' + selected_column[:-1])
                region_next = False

            # build the select columns component of the query
            column_id = self.all_col_ids[i]
            query_logic = ''
            if self.all_col_ids[i] in self.existing_col_ids: # the column we are working on was mapped in the element_mapping table
                self.epa_column_name = self.existing_cols[column_id]['column_name']
                # logger.info('Working on column %s', self.epa_column_name)
                selected_column = self.existing_cols[column_id]['selected_column'].replace('""','????')
                query_logic = self.existing_cols[column_id]['query_logic']
                if 'facility_type' in self.epa_column_name and '_id' not in self.epa_column_name:
                    selected_column = selected_column.replace('facility_type1 as','facility_type_id as').replace('facility_type2 as','facility_type_id as')
            else: # the column we are working on wasn't mapped in the element mapping table but is a required field so add it anyway
                self.epa_column_name = self.required_cols[column_id]['column_name']
                # logger.info('Working on column %s', self.epa_column_name)
                data_type = self.required_cols[column_id]['data_type']
                character_maximum_length = self.required_cols[column_id]['character_maximum_length']
                org_col = '????' # print a symbol making it obvious to the developer they need to update the generated SQL
                selected_column = org_col + '::' + utils.get_datatype_sql(data_type, character_maximum_length) + ' as ' + self.epa_column_name + ','
            if self.epa_column_name == 'facility_state':
                # if facility_state wasn't mapped, set it as the organization ID
                if 'facility_state' not in self.mapped_epa_columns:
                    org_col = f"'{self.dataset.organization_id}'"
                    selected_column = org_col + '::' + utils.get_datatype_sql(data_type, character_maximum_length) + ' as ' + self.epa_column_name + ','
                # if we are working on ust_facility and we are on facility state, set the region_next variable
                if self.dataset.ust_or_release == 'ust' and self.table_name == 'ust_facility' and 'facility_epa_region' not in self.mapped_epa_columns:
                    region_next = True
            if query_logic:
                select_items.append(
                    self._format_select_item(
                        selected_column,
                        query_logic,
                        organization_column_name=self.existing_cols[column_id].get('organization_column_name'),
                        organization_table_name=self.existing_cols[column_id].get('organization_table_name'),
                        epa_column_name=self.existing_cols[column_id].get('column_name'),
                    )
                )
            else:
                select_items.append('\t' + selected_column.rstrip(','))

        self.select_sql = 'select distinct\n' + ',\n'.join(s.rstrip() for s in select_items) + '\n'


    def _build_validation_query(self):
        where_sql = self.where_sql.rstrip()
        if where_sql.endswith(';'):
            where_sql = where_sql[:-1].rstrip()
        return (
            'explain select * from (\n'
            + self.select_sql
            + self.from_sql
            + where_sql
            + '\n) generated_view_sql\nlimit 0'
        )


    def _contains_manual_placeholders(self):
        sql = self.select_sql + self.from_sql + self.where_sql
        return '????' in sql or '!!!' in sql


    def _validate_generated_sql(self):
        if self._contains_manual_placeholders():
            self._warn(f'Skipping SQL validation for {self.table_name} because manual placeholders remain.')
            return

        validation_sql = self._build_validation_query()
        try:
            self.cur.execute(validation_sql)
        except Exception as exc:
            msg = f'Generated SQL failed validation for {self.table_name}: {exc}'
            if self.strict:
                raise RuntimeError(msg) from exc
            self._warn(msg)


    def generate_sql(self):
        self._preflight()
        self.build_where_sql()
        self.build_from_query()
        self.required_cols = self.get_required_cols()
        self.existing_cols = self.get_existing_cols()
        self.required_col_ids = [
            n for n in self.required_col_ids
            if self.required_cols[n]['column_name'] not in self.mapped_epa_columns
        ]
        self.all_col_ids = sorted(self.required_col_ids + self.existing_col_ids, key=lambda x: x or 0)        
        self.build_select_query()
        self._validate_generated_sql()
        if self.warnings:
            self.view_sql += '-- WARNINGS\n'
            for warning in self.warnings:
                self.view_sql += '-- ' + warning + '\n'
            self.view_sql += '\n'
        self.view_sql = self.view_sql + f'create or replace view {self.dataset.schema}.{self.view_name} as\n'
        self.view_sql = self.view_sql + self.select_sql + self.from_sql + self.where_sql
        # print(self.view_sql)
        if self.print_console:
            print(self.view_sql)
            print('-----------------------------------------------------------------------------------------------------------')
        return self.view_sql 



def get_tables_needed(dataset):
    conn = utils.connect_db()
    cur = conn.cursor()
    sql = f"""select distinct epa_table_name, table_sort_order
            from public.v_{dataset.ust_or_release}_table_population 
            where {dataset.ust_or_release}_control_id = %s
            order by table_sort_order"""
    cur.execute(sql, (dataset.control_id,))
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return [r[0] for r in rows]


def _collect_table_preflight(dataset, table_name, strict=False):
    conn = utils.connect_db()
    cur = conn.cursor()
    warnings = []
    errors = []
    suggested_fixes = []
    suggested_fix_items = []
    suggested_fix_seen = set()

    def add_suggested_fix(message, severity):
        key = (severity, message)
        if key in suggested_fix_seen:
            return
        suggested_fix_seen.add(key)
        suggested_fixes.append(message)
        suggested_fix_items.append({'severity': severity, 'message': message})

    try:
        try:
            joins = utils.get_join_tables(dataset, table_name)
        except RuntimeError as exc:
            joins = []
            message = f'Unable to retrieve join metadata: {exc}'
            if strict:
                errors.append(message)
            else:
                warnings.append(message)
            add_suggested_fix(
                f'Validate join metadata source access and add join rows for {table_name} in public.{dataset.ust_or_release}_element_mapping_joins.',
                'blocking',
            )

        if not joins:
            message = 'No join metadata found.'
            if strict:
                errors.append(message)
            else:
                warnings.append(message)
            add_suggested_fix(
                f'Add join metadata rows for {table_name} in public.{dataset.ust_or_release}_element_mapping_joins.',
                'blocking',
            )

        required_sql = f"""select b.column_name
                            from information_schema.columns a
                            join public.{dataset.ust_or_release}_required_view_columns b
                              on a.table_name = b.information_schema_table_name
                             and a.column_name = b.column_name
                            where a.table_schema = 'public' and b.table_name = %s"""
        cur.execute(required_sql, (table_name,))
        required_columns = {row[0] for row in cur.fetchall()}

        mapped_sql = f"""select distinct epa_column_name
                          from public.v_{dataset.ust_or_release}_table_population_sql
                          where {dataset.ust_or_release}_control_id = %s
                            and epa_table_name = %s
                            and epa_column_name is not null
                            and column_sort_order is not null"""
        cur.execute(mapped_sql, (dataset.control_id, table_name))
        mapped_columns = {row[0] for row in cur.fetchall()}

        missing_required = sorted(required_columns - mapped_columns)
        if missing_required:
            warnings.append(f'Missing required mappings: {", ".join(missing_required)}')
            add_suggested_fix(
                f'Add mapped rows for required columns in public.{dataset.ust_or_release}_element_mapping: '
                + ', '.join(missing_required),
                'blocking',
            )

        if not mapped_columns:
            message = 'No mapped columns found in table population SQL.'
            if strict:
                errors.append(message)
            else:
                warnings.append(message)
            add_suggested_fix(
                f'Ensure table population SQL rows exist for {table_name} with non-null epa_column_name and column_sort_order.',
                'blocking',
            )

        if dataset.ust_or_release == 'ust':
            parent_table = 'ust_facility'
            parent_col = 'facility_id'
            child_col = 'tank_id'
        else:
            parent_table = 'ust_release'
            parent_col = 'release_id'
            child_col = 'substance_id'

        key_sql = f"""select epa_column_name
                       from public.{dataset.ust_or_release}_element_mapping
                       where {dataset.ust_or_release}_control_id = %s
                         and epa_table_name = %s
                         and epa_column_name = any(%s)"""
        cur.execute(key_sql, (dataset.control_id, table_name, [parent_col, child_col]))
        key_cols = {row[0] for row in cur.fetchall()}

        if parent_col not in key_cols:
            message = f'Missing key mapping for {parent_col}.'
            if strict:
                errors.append(message)
            else:
                warnings.append(message)
            add_suggested_fix(
                f'Add key mapping for {parent_col} in public.{dataset.ust_or_release}_element_mapping for {table_name}.',
                'blocking',
            )

        if table_name != parent_table and child_col not in key_cols:
            warnings.append(f'Missing key mapping for {child_col}.')
            add_suggested_fix(
                f'Add key mapping for {child_col} in public.{dataset.ust_or_release}_element_mapping for {table_name}.',
                'blocking',
            )

        recipe_override_sql = f"""select distinct epa_column_name
                                    from public.{dataset.ust_or_release}_element_mapping
                                    where {dataset.ust_or_release}_control_id = %s
                                      and epa_table_name = %s
                                      and column_sort_order is not null
                                      and query_logic is not null"""
        cur.execute(recipe_override_sql, (dataset.control_id, table_name))
        recipe_override_columns = sorted(
            row[0] for row in cur.fetchall() if has_recipe_for_column(row[0])
        )
        recipe_override_family_counts = {}
        for column_name in recipe_override_columns:
            family = get_recipe_family(column_name)
            if family:
                recipe_override_family_counts[family] = recipe_override_family_counts.get(family, 0) + 1
        if recipe_override_columns:
            warnings.append(
                'Recipe overrides will normalize mapped query_logic for: '
                + ', '.join(recipe_override_columns)
            )

        suggested_fix_severity_counts = {}
        for item in suggested_fix_items:
            severity = item['severity']
            suggested_fix_severity_counts[severity] = suggested_fix_severity_counts.get(severity, 0) + 1

        return {
            'table_name': table_name,
            'join_count': len(joins) if 'joins' in locals() else 0,
            'required_count': len(required_columns),
            'mapped_count': len(mapped_columns),
            'missing_required_count': len(missing_required),
            'recipe_override_count': len(recipe_override_columns),
            'recipe_override_columns': recipe_override_columns,
            'recipe_override_family_counts': recipe_override_family_counts,
            'suggested_fixes': suggested_fixes,
            'suggested_fix_items': suggested_fix_items,
            'suggested_fix_severity_counts': suggested_fix_severity_counts,
            'warnings': warnings,
            'errors': errors,
        }
    finally:
        cur.close()
        conn.close()


def preflight_report(ust_or_release, control_id, table_name=None, strict=False):
    dataset = Dataset(
        ust_or_release=ust_or_release,
        control_id=control_id,
        base_file_name='view_creation.sql',
        export_file_name=export_file_name,
        export_file_dir=export_file_dir,
        export_file_path=export_file_path,
    )

    tables = [table_name] if table_name else get_tables_needed(dataset)
    print('View SQL preflight report')
    print(f'  type: {ust_or_release}')
    print(f'  control-id: {control_id}')
    print(f'  strict: {strict}')

    fatal_tables = []
    saw_recipe_override_families = False
    total_fix_count = 0
    total_fix_severity_counts = {}
    total_warning_count = 0
    total_error_count = 0
    for table in tables:
        result = _collect_table_preflight(dataset, table, strict=strict)
        print(f'\n[{table}]')
        print(f'  joins: {result["join_count"]}')
        print(f'  required columns: {result["required_count"]}')
        print(f'  mapped columns: {result["mapped_count"]}')
        print(f'  missing required: {result["missing_required_count"]}')
        print(f'  recipe overrides: {result["recipe_override_count"]}')
        fix_items = result.get('suggested_fix_items')
        if fix_items is None:
            fix_items = [{'severity': 'advisory', 'message': m} for m in result.get('suggested_fixes', [])]
        severity_counts = result.get('suggested_fix_severity_counts')
        if severity_counts is None:
            severity_counts = {}
            for item in fix_items:
                severity = item['severity']
                severity_counts[severity] = severity_counts.get(severity, 0) + 1
        total_fix_count += len(fix_items)
        for severity, count in severity_counts.items():
            total_fix_severity_counts[severity] = total_fix_severity_counts.get(severity, 0) + count
        total_warning_count += len(result['warnings'])
        total_error_count += len(result['errors'])
        if fix_items:
            severity_order = ['blocking', 'advisory']
            severity_parts = []
            for severity in severity_order:
                if severity in severity_counts:
                    severity_parts.append(f'{severity}={severity_counts[severity]}')
            for severity in sorted(severity_counts):
                if severity not in severity_order:
                    severity_parts.append(f'{severity}={severity_counts[severity]}')
            print(f'  suggested fixes: {len(fix_items)} ({", ".join(severity_parts)})')
        if result['recipe_override_columns']:
            print('  recipe override columns: ' + ', '.join(result['recipe_override_columns']))
        if result['recipe_override_family_counts']:
            saw_recipe_override_families = True
            family_parts = []
            for family_key in sorted(result['recipe_override_family_counts']):
                family_label = RECIPE_FAMILY_LABELS.get(family_key, family_key)
                count = result['recipe_override_family_counts'][family_key]
                family_parts.append(f'{family_label}={count}')
            print('  recipe override families: ' + ', '.join(family_parts))
        for message in result['warnings']:
            print(f'  WARN: {message}')
        for message in result['errors']:
            print(f'  ERROR: {message}')
        for item in fix_items:
            print(f'  FIX[{item["severity"].upper()}]: {item["message"]}')
        if result['errors']:
            fatal_tables.append(table)

    if total_fix_count:
        severity_order = ['blocking', 'advisory']
        severity_parts = []
        for severity in severity_order:
            if severity in total_fix_severity_counts:
                severity_parts.append(f'{severity}={total_fix_severity_counts[severity]}')
        for severity in sorted(total_fix_severity_counts):
            if severity not in severity_order:
                severity_parts.append(f'{severity}={total_fix_severity_counts[severity]}')
        print('\nSuggested fix rollup: ' + f'{total_fix_count} total ({", ".join(severity_parts)})')

    if saw_recipe_override_families:
        legend_parts = []
        for family_key in sorted(RECIPE_FAMILY_LABELS):
            legend_parts.append(f'{RECIPE_FAMILY_LABELS[family_key]}={family_key}')
        print('\nRecipe family legend: ' + ', '.join(legend_parts))

    totals_line = (
        f'\nPreflight totals: warnings={total_warning_count}, '
        f'errors={total_error_count}, suggested_fixes={total_fix_count}'
    )
    if total_fix_count:
        severity_order = ['blocking', 'advisory']
        severity_parts = []
        for severity in severity_order:
            if severity in total_fix_severity_counts:
                severity_parts.append(f'{severity}={total_fix_severity_counts[severity]}')
        for severity in sorted(total_fix_severity_counts):
            if severity not in severity_order:
                severity_parts.append(f'{severity}={total_fix_severity_counts[severity]}')
        totals_line += f' ({", ".join(severity_parts)})'
    print(totals_line)

    if total_warning_count == 0 and total_error_count == 0 and total_fix_count == 0:
        print('\nPreflight summary: clean (no warnings, errors, or suggested fixes).')

    if strict and fatal_tables:
        raise RuntimeError('Preflight failed in strict mode for: ' + ', '.join(fatal_tables))

    logger.info('Preflight complete for %s table(s).', len(tables))



def main(
    ust_or_release,
    control_id,
    table_name=None,
    overwrite_sql_file=True,
    print_console=False,
    strict=False,
    preflight_only=False,
):
    if preflight_only:
        preflight_report(
            ust_or_release=ust_or_release,
            control_id=control_id,
            table_name=table_name,
            strict=strict,
        )
        return

    dataset = Dataset(ust_or_release=ust_or_release,
                       control_id=control_id,
                      base_file_name='view_creation.sql',
                      export_file_name=export_file_name,
                      export_file_dir=export_file_dir,
                      export_file_path=export_file_path)

    if table_name:
        sql = ViewSql(dataset=dataset, 
                      table_name=table_name,
                      overwrite_sql_file=overwrite_sql_file,
                      print_console=print_console,
                      strict=strict)
        if print_console:
            print(sql.view_sql)
        else:
            logger.info('Generated view SQL for %s.%s', dataset.schema, sql.view_name)
    else:
        tables_needed = get_tables_needed(dataset)
        for table in tables_needed: 
            sql = ViewSql(dataset=dataset, 
                          table_name=table,
                          overwrite_sql_file=overwrite_sql_file,
                          print_console=print_console,
                          strict=strict)
            overwrite_sql_file = False
            # print(sql.view_sql)

    logger.info('Script complete.')


if __name__ == '__main__':   

    main(ust_or_release=ust_or_release,
         control_id=control_id,
         table_name=table_name,
         overwrite_sql_file=overwrite_sql_file,
         print_console=print_console)
