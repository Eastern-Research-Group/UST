import difflib
import re

from ust.python.util import utils
from ust.python.util.dataset import Dataset


class DatasetAudit:
    def __init__(self, dataset, fix_query_logic=False, fix_source_identifiers=False, write_sql=True, print_sql=False):
        self.dataset = dataset
        self.fix_query_logic = fix_query_logic
        self.fix_source_identifiers = fix_source_identifiers
        self.write_sql = write_sql
        self.print_sql = print_sql
        self.conn = None
        self.cur = None
        self.findings = []
        self.fixed_query_logic = []
        self.fixed_source_identifiers = []
        self.source_fix_sql = []
        self.value_mapping_fix_sql = []
        self._relation_columns_cache = {}
        self._relation_names = None

    def connect_db(self):
        if not self.conn:
            self.conn = utils.connect_db()
            self.cur = self.conn.cursor()

    def disconnect_db(self):
        if self.conn:
            self.cur.close()
            self.conn.close()
            self.conn = None

    @staticmethod
    def _quote_identifier(identifier):
        return '"' + identifier.replace('"', '""') + '"'


    @staticmethod
    def _quote_literal(value):
        return "'" + str(value).replace("'", "''") + "'"


    @staticmethod
    def _display_identifier(identifier):
        if re.search(r'[A-Z\s]', identifier):
            return DatasetAudit._quote_identifier(identifier)
        return identifier


    def _display_source(self, table_name, column_name=None):
        source = f'{self.dataset.schema}.{self._display_identifier(table_name)}'
        if column_name:
            source += f'.{self._display_identifier(column_name)}'
        return source


    def add_finding(self, category, message):
        self.findings.append((category, message))

    def _relation_columns(self, table_name):
        if table_name in self._relation_columns_cache:
            return self._relation_columns_cache[table_name]
        self.cur.execute(
            """select column_name
               from information_schema.columns
               where table_schema = %s and table_name = %s""",
            (self.dataset.schema, table_name),
        )
        columns = {row[0] for row in self.cur.fetchall()}
        self._relation_columns_cache[table_name] = columns
        return columns

    @staticmethod
    def _normalized_identifier(identifier):
        return re.sub(r'[^a-z0-9]', '', identifier.lower())

    def _get_relation_names(self):
        if self._relation_names is None:
            self.cur.execute(
                """select table_name
                   from information_schema.tables
                   where table_schema = %s""",
                (self.dataset.schema,),
            )
            self._relation_names = {row[0] for row in self.cur.fetchall()}
        return self._relation_names

    def _resolve_identifier(self, requested, candidates):
        if requested in candidates:
            return requested
        normalized_requested = self._normalized_identifier(requested)
        matches = [
            candidate
            for candidate in candidates
            if self._normalized_identifier(candidate) == normalized_requested
        ]
        return matches[0] if len(matches) == 1 else None

    def _suggest_source_fix_sql(self, mapping_id, field_name, candidates, context):
        close_matches = difflib.get_close_matches(
            self._normalized_identifier(candidates['requested']),
            [self._normalized_identifier(candidate) for candidate in candidates['available']],
            n=1,
            cutoff=0.75,
        )
        normalized_to_candidate = {
            self._normalized_identifier(candidate): candidate
            for candidate in candidates['available']
        }
        suggestions = [normalized_to_candidate[match] for match in close_matches]
        comments = [f'-- {context}']
        if suggestions:
            comments.append(
                '-- Perhaps you meant: ' + ', '.join(self._display_identifier(match) for match in suggestions)
            )
        comments.extend([
            f'update public.{self.dataset.ust_or_release}_element_mapping\n'
            f"set {field_name} = '<REPLACE_WITH_CORRECT_IDENTIFIER>'\n"
            f'where {self.dataset.ust_or_release}_element_mapping_id = {mapping_id};',
        ])
        return '\n'.join(comments)

    def _suggest_confirmed_source_fix_sql(self, mapping_id, corrections, context):
        assignments = ',\n    '.join(
            f"{field_name} = {self._quote_literal(value)}"
            for field_name, value in corrections
        )
        return f'''-- {context}
update public.{self.dataset.ust_or_release}_element_mapping
set {assignments}
where {self.dataset.ust_or_release}_element_mapping_id = {mapping_id};'''

    def _suggest_value_mapping_sql(self, mapping_id, epa_table, epa_column, source_table, source_column, value):
        value_literal = self._quote_literal(value)
        insert_prefix = (
            f'insert into public.{self.dataset.ust_or_release}_element_value_mapping '
            f'({self.dataset.ust_or_release}_element_mapping_id, organization_value, epa_value, '
            'mapping_action, exclude_from_query, programmer_comments)'
        )
        return f'''-- {epa_table}.{epa_column}: unmapped value {value_literal} from {self._display_source(source_table, source_column)}
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- {insert_prefix}
-- values ({mapping_id}, {value_literal}, '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
-- {insert_prefix}
-- values ({mapping_id}, {value_literal}, null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- {insert_prefix}
-- values ({mapping_id}, {value_literal}, null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');
'''

    def audit_duplicate_element_mappings(self):
        sql = f"""select epa_table_name, epa_column_name, count(*)
                   from public.{self.dataset.ust_or_release}_element_mapping
                   where {self.dataset.ust_or_release}_control_id = %s
                   group by epa_table_name, epa_column_name
                   having count(*) > 1
                   order by epa_table_name, epa_column_name"""
        self.cur.execute(sql, (self.dataset.control_id,))
        for table_name, column_name, count in self.cur.fetchall():
            self.add_finding('duplicate element mapping', f'{table_name}.{column_name}: {count} rows')

    def audit_mapping_sources(self):
        sql = f"""select {self.dataset.ust_or_release}_element_mapping_id,
                          epa_table_name,
                          epa_column_name,
                          organization_table_name,
                          organization_column_name,
                          deagg_table_name,
                          deagg_column_name
                   from public.{self.dataset.ust_or_release}_element_mapping
                   where {self.dataset.ust_or_release}_control_id = %s
                   order by {self.dataset.ust_or_release}_element_mapping_id"""
        self.cur.execute(sql, (self.dataset.control_id,))
        columns_cache = {}
        for mapping_id, epa_table, epa_column, org_table, org_column, deagg_table, deagg_column in self.cur.fetchall():
            sources = [('organization', org_table, org_column, 'organization_table_name', 'organization_column_name')]
            if deagg_table or deagg_column:
                sources.append(('deaggregation', deagg_table, deagg_column, 'deagg_table_name', 'deagg_column_name'))
            for source_kind, source_table, source_column, table_field, column_field in sources:
                if not source_table or not source_column:
                    self.add_finding(
                        'incomplete element mapping',
                        f'{mapping_id}: {epa_table}.{epa_column} has no {source_kind} source table or column',
                    )
                    continue
                resolved_table = self._resolve_identifier(source_table, self._get_relation_names())
                if not resolved_table:
                    self.add_finding(
                        'unknown source relation',
                        f'{mapping_id}: {epa_table}.{epa_column} -> {self._display_source(source_table)}',
                    )
                    self.source_fix_sql.append(self._suggest_source_fix_sql(
                        mapping_id,
                        table_field,
                        {'requested': source_table, 'available': self._get_relation_names()},
                        f'{epa_table}.{epa_column}: unknown {source_kind} source table {self._display_identifier(source_table)}',
                    ))
                    continue
                if resolved_table not in columns_cache:
                    columns_cache[resolved_table] = self._relation_columns(resolved_table)
                resolved_column = self._resolve_identifier(source_column, columns_cache[resolved_table])
                if not resolved_column:
                    self.add_finding(
                        'unknown source column',
                        f'{mapping_id}: {epa_table}.{epa_column} -> {self._display_source(source_table, source_column)}',
                    )
                    self.source_fix_sql.append(self._suggest_source_fix_sql(
                        mapping_id,
                        column_field,
                        {'requested': source_column, 'available': columns_cache[resolved_table]},
                        f'{epa_table}.{epa_column}: unknown {source_kind} source column '
                        f'{self._display_source(source_table, source_column)}',
                    ))
                    continue
                corrections = []
                if resolved_table != source_table:
                    corrections.append((table_field, resolved_table))
                if resolved_column != source_column:
                    corrections.append((column_field, resolved_column))
                if corrections:
                    correction_text = ', '.join(
                        f'{field} mapped as {self._display_identifier(source_table if field == table_field else source_column)} '
                        f'but schema has {self._display_identifier(value)}'
                        for field, value in corrections
                    )
                    suggested_sql = self._suggest_confirmed_source_fix_sql(
                        mapping_id,
                        corrections,
                        f'{epa_table}.{epa_column}: {correction_text}',
                    )
                    if self.fix_source_identifiers:
                        set_sql = ', '.join(f'{field} = %s' for field, _value in corrections)
                        self.cur.execute(
                            f"""update public.{self.dataset.ust_or_release}_element_mapping
                                 set {set_sql}
                                 where {self.dataset.ust_or_release}_element_mapping_id = %s""",
                            tuple(value for _field, value in corrections) + (mapping_id,),
                        )
                        self.fixed_source_identifiers.append(f'{mapping_id}: {correction_text}')
                    else:
                        self.add_finding('repairable source identifier', f'{mapping_id}: {epa_table}.{epa_column}: {correction_text}')
                        self.source_fix_sql.append(suggested_sql)

    def audit_value_mapping_completeness(self):
        sql = f"""select mapping.{self.dataset.ust_or_release}_element_mapping_id,
                            mapping.epa_table_name,
                            mapping.epa_column_name,
                            coalesce(mapping.deagg_table_name, mapping.organization_table_name),
                            coalesce(mapping.deagg_column_name, mapping.organization_column_name),
                            elements.database_lookup_table
                from public.{self.dataset.ust_or_release}_element_mapping mapping
                join public.{self.dataset.ust_or_release}_elements elements
                    on elements.database_column_name = mapping.epa_column_name
                where mapping.{self.dataset.ust_or_release}_control_id = %s
                    and elements.database_lookup_table is not null
                order by mapping.{self.dataset.ust_or_release}_element_mapping_id"""
        self.cur.execute(sql, (self.dataset.control_id,))
        columns_cache = {}
        for mapping_id, epa_table, epa_column, source_table, source_column, _lookup_table in self.cur.fetchall():
            if not source_table or not source_column:
                continue
            if source_table not in columns_cache:
                columns_cache[source_table] = self._relation_columns(source_table)
            if source_column not in columns_cache[source_table]:
                continue
            source_relation = f'{self.dataset.schema}.{self._quote_identifier(source_table)}'
            source_field = self._quote_identifier(source_column)
            value_sql = f"""select organization_value
                              from (
                                  select distinct trim({source_field}::text) as organization_value
                                  from {source_relation}
                                  where nullif(trim({source_field}::text), '') is not null
                              ) source_values
                              where not exists (
                                  select 1
                                  from public.{self.dataset.ust_or_release}_element_value_mapping mapped_values
                                  where mapped_values.{self.dataset.ust_or_release}_element_mapping_id = %s
                                    and mapped_values.organization_value = source_values.organization_value
                              )
                              order by organization_value"""
            self.cur.execute(value_sql, (mapping_id,))
            missing_values = [row[0] for row in self.cur.fetchall()]
            if missing_values:
                self.add_finding(
                    'unmapped source values',
                    f'{mapping_id}: {epa_table}.{epa_column} has {len(missing_values)} unmapped value(s) in '
                    f'{self._display_source(source_table, source_column)}',
                )
                self.value_mapping_fix_sql.extend(
                    self._suggest_value_mapping_sql(
                        mapping_id,
                        epa_table,
                        epa_column,
                        source_table,
                        source_column,
                        value,
                    )
                    for value in missing_values
                )

    def audit_mapping_actions(self):
        sql = f"""select value_mapping.{self.dataset.ust_or_release}_element_value_mapping_id,
                                            value_mapping.{self.dataset.ust_or_release}_element_mapping_id,
                                            value_mapping.organization_value,
                                            value_mapping.mapping_action,
                                            value_mapping.exclude_from_query,
                                            value_mapping.programmer_comments
                                from public.{self.dataset.ust_or_release}_element_value_mapping value_mapping
                                join public.{self.dataset.ust_or_release}_element_mapping element_mapping
                                    on element_mapping.{self.dataset.ust_or_release}_element_mapping_id = value_mapping.{self.dataset.ust_or_release}_element_mapping_id
                                where element_mapping.{self.dataset.ust_or_release}_control_id = %s
                                    and value_mapping.mapping_action in ('EXCLUDE', 'INTENTIONALLY_NULL')
                                order by value_mapping.{self.dataset.ust_or_release}_element_value_mapping_id"""
        self.cur.execute(sql, (self.dataset.control_id,))
        for value_mapping_id, mapping_id, organization_value, action, exclude_flag, comments in self.cur.fetchall():
            if action == 'EXCLUDE' and exclude_flag != 'Y':
                self.add_finding(
                    'invalid mapping action',
                    f'{value_mapping_id}: mapping {mapping_id}, {organization_value!r} is EXCLUDE but exclude_from_query is not Y',
                )
            elif action == 'INTENTIONALLY_NULL' and exclude_flag == 'Y':
                self.add_finding(
                    'invalid mapping action',
                    f'{value_mapping_id}: mapping {mapping_id}, {organization_value!r} is INTENTIONALLY_NULL but exclude_from_query is Y',
                )
            elif not comments:
                self.add_finding(
                    'undocumented mapping action',
                    f'{value_mapping_id}: mapping {mapping_id}, {organization_value!r} is {action} without programmer_comments',
                )

    def fix_legacy_query_logic(self):
        sql = f"""select mapping.{self.dataset.ust_or_release}_element_mapping_id,
                          mapping.epa_table_name,
                          mapping.epa_column_name,
                          mapping.query_logic,
                          elements.allowed_values,
                          elements.database_lookup_table
                   from public.{self.dataset.ust_or_release}_element_mapping mapping
                   join public.{self.dataset.ust_or_release}_elements elements
                     on elements.database_column_name = mapping.epa_column_name
                   where mapping.{self.dataset.ust_or_release}_control_id = %s
                                         and lower(trim(mapping.query_logic)) like 'where %%'"""
        self.cur.execute(sql, (self.dataset.control_id,))
        for mapping_id, epa_table, epa_column, query_logic, allowed_values, lookup_table in self.cur.fetchall():
            rule_text = ' '.join(str(value or '') for value in (allowed_values, lookup_table)).lower()
            if 'yes' not in rule_text:
                self.add_finding('unsupported query logic', f'{mapping_id}: {epa_table}.{epa_column}: {query_logic}')
                continue
            predicate = re.sub(r'^\s*where\s+', '', query_logic, flags=re.IGNORECASE).strip()
            if not predicate:
                self.add_finding('unsupported query logic', f'{mapping_id}: {epa_table}.{epa_column}: empty where predicate')
                continue
            replacement = f"case when {predicate} then 'Yes' end"
            if self.fix_query_logic:
                self.cur.execute(
                    f"""update public.{self.dataset.ust_or_release}_element_mapping
                         set query_logic = %s
                         where {self.dataset.ust_or_release}_element_mapping_id = %s""",
                    (replacement, mapping_id),
                )
                self.fixed_query_logic.append(mapping_id)
            else:
                self.add_finding(
                    'repairable query logic',
                    f'{mapping_id}: {epa_table}.{epa_column}: {query_logic} -> {replacement}',
                )

    def get_suggested_sql(self):
        sections = []
        if self.source_fix_sql:
            sections.append('-- SOURCE IDENTIFIER FIXES\n\n' + '\n\n'.join(self.source_fix_sql))
        if self.value_mapping_fix_sql:
            sections.append('-- VALUE MAPPING FIXES\n\n' + '\n\n'.join(self.value_mapping_fix_sql))
        return '\n\n'.join(sections) + ('\n' if sections else '')

    def write_suggested_sql(self, suggested_sql):
        with open(self.dataset.export_file_path, 'w', encoding='utf-8') as file_handle:
            file_handle.write(suggested_sql)
        print(f'Wrote audit SQL to {self.dataset.export_file_path}')

    def run(self):
        self.connect_db()
        try:
            self.audit_duplicate_element_mappings()
            self.audit_mapping_sources()
            self.audit_value_mapping_completeness()
            self.audit_mapping_actions()
            self.fix_legacy_query_logic()
            if self.fix_query_logic or self.fix_source_identifiers:
                self.conn.commit()
        finally:
            self.disconnect_db()

        print('Dataset audit report')
        print(f'  type: {self.dataset.ust_or_release}')
        print(f'  control-id: {self.dataset.control_id}')
        print(f'  schema: {self.dataset.schema}')
        if self.fixed_query_logic:
            print(f'  fixed query_logic mappings: {", ".join(str(item) for item in self.fixed_query_logic)}')
        if self.fixed_source_identifiers:
            print('  fixed source identifiers:')
            for item in self.fixed_source_identifiers:
                print(f'    {item}')
        if not self.findings:
            print('  No findings.')
        categories = []
        grouped_findings = {}
        for category, message in self.findings:
            if category not in grouped_findings:
                categories.append(category)
                grouped_findings[category] = []
            grouped_findings[category].append(message)
        for category in categories:
            print(f'\n  [{category}]')
            for message in grouped_findings[category]:
                print(f'    {message}')
        suggested_sql = self.get_suggested_sql()
        if suggested_sql and self.write_sql:
            self.write_suggested_sql(suggested_sql)
        if suggested_sql and self.print_sql:
            print('\nSuggested audit SQL:')
            print(suggested_sql)
        return {
            'findings': self.findings,
            'fixed_query_logic': self.fixed_query_logic,
            'fixed_source_identifiers': self.fixed_source_identifiers,
            'source_fix_sql': self.source_fix_sql,
            'value_mapping_fix_sql': self.value_mapping_fix_sql,
        }


def main(
    ust_or_release,
    control_id=0,
    organization_id=None,
    fix_query_logic=False,
    fix_source_identifiers=False,
    write_sql=True,
    print_sql=False,
):
    if not control_id:
        control_id = utils.get_control_id(ust_or_release, organization_id.upper())
    dataset = Dataset(
        ust_or_release=ust_or_release,
        control_id=control_id,
        requires_export=write_sql,
        base_file_name='audit_fixes.sql',
    )
    return DatasetAudit(
        dataset,
        fix_query_logic=fix_query_logic,
        fix_source_identifiers=fix_source_identifiers,
        write_sql=write_sql,
        print_sql=print_sql,
    ).run()