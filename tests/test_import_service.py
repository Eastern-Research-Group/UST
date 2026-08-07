import unittest
from types import SimpleNamespace
from unittest.mock import patch

from ust.python.state_processing.create_view_sql import (
    ViewSql,
    _collect_table_preflight,
    preflight_report,
)
from ust.python.util import utils
from ust.python.util.import_service import ImportService


class ImportServiceTests(unittest.TestCase):
    @patch("ust.python.util.import_service.DatabaseImporter")
    def test_import_data_calls_database_importer_with_expected_argument_order(self, importer_cls):
        service = ImportService()

        service.import_data(
            organization_id="MA",
            ust_or_release="release",
            file_path=r"C:\\tmp\\data",
            overwrite_table=False,
        )

        importer_cls.assert_called_once_with("MA", "release", r"C:\\tmp\\data", False)
        importer_cls.return_value.save_files_to_db.assert_called_once_with()


class ViewSqlTests(unittest.TestCase):
    def test_get_column_select_sql_uses_trimmed_varchar_expression(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.table_name = "ust_facility"
        view_sql.cur = unittest.mock.MagicMock()
        view_sql.cur.fetchone.return_value = ("character varying", 100)
        view_sql._warn = unittest.mock.MagicMock()

        selected_column = view_sql.get_column_select_sql("facility_name", "site_name")

        self.assertEqual(
            'nullif(trim("site_name"::text), \'\')::character varying(100) as facility_name',
            selected_column,
        )

    def test_get_column_select_sql_uses_regex_guard_for_integer(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.table_name = "ust_tank"
        view_sql.cur = unittest.mock.MagicMock()
        view_sql.cur.fetchone.return_value = ("integer", None)
        view_sql._warn = unittest.mock.MagicMock()

        selected_column = view_sql.get_column_select_sql("tank_id", "tank_identifier")

        self.assertEqual(
            "case when nullif(trim(\"tank_identifier\"::text), '') ~ '^[+-]?\\d+$' then nullif(trim(\"tank_identifier\"::text), '')::integer else null::integer end as tank_id",
            selected_column,
        )

    def test_get_column_select_sql_uses_multiformat_date_guard(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.table_name = "ust_tank"
        view_sql.cur = unittest.mock.MagicMock()
        view_sql.cur.fetchone.return_value = ("date", None)
        view_sql._warn = unittest.mock.MagicMock()

        selected_column = view_sql.get_column_select_sql("tank_installation_date", "installed_on")

        self.assertIn("when nullif(trim(\"installed_on\"::text), '') ~ '^\\d{4}-\\d{2}-\\d{2}$'", selected_column)
        self.assertIn("when nullif(trim(\"installed_on\"::text), '') ~ '^\\d{1,2}/\\d{1,2}/\\d{4}$'", selected_column)
        self.assertTrue(selected_column.endswith("as tank_installation_date"))

    def test_get_column_select_sql_uses_yes_no_recipe_for_booleanish_fields(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.table_name = "ust_tank"
        view_sql.cur = unittest.mock.MagicMock()
        view_sql.cur.fetchone.return_value = ("character varying", 7)
        view_sql._warn = unittest.mock.MagicMock()

        selected_column = view_sql.get_column_select_sql("federally_regulated", "FederalFlag")

        self.assertEqual(
            "case when lower(nullif(trim(\"FederalFlag\"::text), '')) in ('true', 't', 'yes', 'y', '1', '1.0') then 'Yes'::text when lower(nullif(trim(\"FederalFlag\"::text), '')) in ('false', 'f', 'no', 'n', '0', '0.0') then 'No'::text else null::text end as federally_regulated",
            selected_column,
        )

    def test_get_column_select_sql_uses_greater_than_one_recipe_for_compartments(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.table_name = "ust_tank"
        view_sql.cur = unittest.mock.MagicMock()
        view_sql.cur.fetchone.return_value = ("character varying", 7)
        view_sql._warn = unittest.mock.MagicMock()

        selected_column = view_sql.get_column_select_sql("compartmentalized_ust", "TankCompartmentNumber")

        self.assertEqual(
            "case when nullif(trim(\"TankCompartmentNumber\"::text), '') ~ '^[+-]?\\d+(\\.0+)?$' and (nullif(trim(\"TankCompartmentNumber\"::text), ''))::numeric > 1 then 'Yes'::text when nullif(trim(\"TankCompartmentNumber\"::text), '') ~ '^[+-]?\\d+(\\.0+)?$' then 'No'::text else null::text end as compartmentalized_ust",
            selected_column,
        )

    def test_get_column_select_sql_uses_yes_null_bucket_recipe_for_exact_matches(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.table_name = "ust_piping"
        view_sql.cur = unittest.mock.MagicMock()
        view_sql.cur.fetchone.return_value = ("character varying", 3)
        view_sql._warn = unittest.mock.MagicMock()

        selected_column = view_sql.get_column_select_sql("piping_material_steel", "TankPipingMaterial")

        self.assertEqual(
            "case when lower(nullif(trim(\"TankPipingMaterial\"::text), '')) in ('black steel', 'cath. protection', 'cath. steel', 'coated steel', 'steel', 'steel/aboveground', 'steel/cont', 'bare steel', 'steel isolated') then 'Yes'::text else null::text end as piping_material_steel",
            selected_column,
        )

    def test_get_column_select_sql_uses_yes_null_bucket_recipe_for_like_matches(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.table_name = "ust_piping"
        view_sql.cur = unittest.mock.MagicMock()
        view_sql.cur.fetchone.return_value = ("character varying", 3)
        view_sql._warn = unittest.mock.MagicMock()

        selected_column = view_sql.get_column_select_sql("piping_material_frp", "TankPipingMaterial")

        self.assertEqual(
            "case when lower(nullif(trim(\"TankPipingMaterial\"::text), '')) like '%fiberglass%' then 'Yes'::text else null::text end as piping_material_frp",
            selected_column,
        )

    def test_get_column_select_sql_uses_yes_null_bucket_recipe_for_detection_lists(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.table_name = "ust_piping"
        view_sql.cur = unittest.mock.MagicMock()
        view_sql.cur.fetchone.return_value = ("character varying", 7)
        view_sql._warn = unittest.mock.MagicMock()

        selected_column = view_sql.get_column_select_sql("piping_line_leak_detector", "TankPipingReleaseDetection")

        self.assertEqual(
            "case when lower(nullif(trim(\"TankPipingReleaseDetection\"::text), '')) in ('campo/miller lld', 'electronic lld', 'incon lld', 'mechanical lld', 'ppm 4000') then 'Yes'::text else null::text end as piping_line_leak_detector",
            selected_column,
        )

    def test_get_existing_cols_backfills_missing_required_parent_keys(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.dataset = SimpleNamespace(control_id=123, ust_or_release="ust")
        view_sql.table_name = "ust_compartment"
        view_sql.required_cols = {
            10: {"column_name": "facility_id", "data_type": "character varying", "character_maximum_length": 50},
            20: {"column_name": "tank_id", "data_type": "integer", "character_maximum_length": None},
            30: {"column_name": "compartment_name", "data_type": "character varying", "character_maximum_length": 50},
        }
        view_sql.table_aliases = {"ma_facility": "a", "ma_tank": "b", "ma_compartment": "c"}
        view_sql.warnings = []
        view_sql.mapped_epa_columns = set()

        view_sql.cur = unittest.mock.MagicMock()
        view_sql.cur.fetchall.side_effect = [
            [
                (30, "compartment_name", "compartment_nm", "c.\"compartment_nm\"::varchar(50) as compartment_name", None, "ma_compartment"),
            ],
            [
                (10, "facility_id", "facility_identifier", "ma_facility"),
                (20, "tank_id", "tank_identifier", "ma_tank"),
            ],
        ]
        view_sql.get_column_select_sql = unittest.mock.MagicMock(side_effect=[
            '"facility_identifier"::varchar(50) as facility_id',
            '"tank_identifier"::integer as tank_id',
        ])

        existing_cols = view_sql.get_existing_cols()

        self.assertEqual([10, 20, 30], view_sql.existing_col_ids)
        self.assertEqual("a.\"facility_identifier\"::varchar(50) as facility_id", existing_cols[10]["selected_column"])
        self.assertEqual("b.\"tank_identifier\"::integer as tank_id", existing_cols[20]["selected_column"])
        self.assertEqual("compartment_name", existing_cols[30]["column_name"])

    def test_get_existing_cols_prefers_recipe_over_query_logic(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.dataset = SimpleNamespace(control_id=123, ust_or_release="ust")
        view_sql.table_name = "ust_tank"
        view_sql.required_cols = {}
        view_sql.table_aliases = {"ma_tank": "a"}
        view_sql.warnings = []
        view_sql.mapped_epa_columns = set()

        view_sql.cur = unittest.mock.MagicMock()
        view_sql.cur.fetchall.side_effect = [
            [
                (10, "federally_regulated", "FederalFlag", 'a."FederalFlag"::varchar(7) as federally_regulated', 'when FederalFlag = TRUE then Yes', "ma_tank"),
            ],
            [],
        ]
        view_sql.get_column_select_sql = unittest.mock.MagicMock(
            return_value="case when lower(nullif(trim(\"FederalFlag\"::text), '')) in ('true', 't', 'yes', 'y', '1', '1.0') then 'Yes'::text when lower(nullif(trim(\"FederalFlag\"::text), '')) in ('false', 'f', 'no', 'n', '0', '0.0') then 'No'::text else null::text end as federally_regulated"
        )

        existing_cols = view_sql.get_existing_cols()

        view_sql.get_column_select_sql.assert_called_once_with("federally_regulated", "FederalFlag")
        self.assertEqual(
            "case when lower(nullif(trim(\"FederalFlag\"::text), '')) in ('true', 't', 'yes', 'y', '1', '1.0') then 'Yes'::text when lower(nullif(trim(\"FederalFlag\"::text), '')) in ('false', 'f', 'no', 'n', '0', '0.0') then 'No'::text else null::text end as federally_regulated",
            existing_cols[10]["selected_column"],
        )
        self.assertEqual("", existing_cols[10]["query_logic"])
        self.assertIn(
            'Overriding query_logic for ust_tank.federally_regulated with standardized recipe SQL.',
            view_sql.warnings,
        )

    def test_build_select_query_uses_query_logic_as_manual_sql(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.dataset = SimpleNamespace(organization_id="MA", ust_or_release="ust")
        view_sql.table_name = "ust_facility"
        view_sql.all_col_ids = [10]
        view_sql.existing_col_ids = [10]
        view_sql.required_cols = {}
        view_sql.mapped_epa_columns = {"facility_name"}
        view_sql.table_aliases = {"ma_facility": "a"}
        view_sql.existing_cols = {
            10: {
                "column_name": "facility_name",
                "selected_column": 'a."site_name"::varchar(100) as facility_name',
                "query_logic": 'upper(a."site_name")',
                "organization_table_name": "ma_facility",
                "organization_column_name": "site_name",
            }
        }

        view_sql.build_select_query()

        self.assertIn('!!! upper(a."site_name") as facility_name', view_sql.select_sql)
        self.assertIn('-- AUTO-GENERATED SOURCE: a."site_name"::varchar(100) as facility_name', view_sql.select_sql)

    def test_build_select_query_auto_compiles_when_fragments(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.dataset = SimpleNamespace(organization_id="HI", ust_or_release="ust")
        view_sql.table_name = "ust_tank"
        view_sql.all_col_ids = [10]
        view_sql.existing_col_ids = [10]
        view_sql.required_cols = {}
        view_sql.mapped_epa_columns = {"federally_regulated"}
        view_sql.table_aliases = {"hi_tank": "a"}
        view_sql.existing_cols = {
            10: {
                "column_name": "federally_regulated",
                "selected_column": 'a."FederallyRegulated"::character varying(7) as federally_regulated',
                "query_logic": 'when FederallyRegulated = TRUE then Yes, when FederallyRegulated = FALSE then N',
                "organization_table_name": "hi_tank",
                "organization_column_name": "FederallyRegulated",
            }
        }

        view_sql.build_select_query()

        self.assertIn('case', view_sql.select_sql)
        self.assertIn('when a."FederallyRegulated" = TRUE then', view_sql.select_sql)
        self.assertIn("then 'Yes'", view_sql.select_sql)
        self.assertIn("then 'N'", view_sql.select_sql)
        self.assertIn('end as federally_regulated', view_sql.select_sql)
        self.assertIn('-- AUTO-COMPILED FROM QUERY_LOGIC', view_sql.select_sql)
        self.assertNotIn('!!!', view_sql.select_sql)

    def test_build_select_query_auto_compiles_list_when_fragments(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.dataset = SimpleNamespace(organization_id="SD", ust_or_release="ust")
        view_sql.table_name = "ust_piping"
        view_sql.all_col_ids = [10]
        view_sql.existing_col_ids = [10]
        view_sql.required_cols = {}
        view_sql.mapped_epa_columns = {"piping_line_leak_detector"}
        view_sql.table_aliases = {"sd_piping": "a"}
        view_sql.existing_cols = {
            10: {
                "column_name": "piping_line_leak_detector",
                "selected_column": 'a."TankPipingReleaseDetection"::character varying(7) as piping_line_leak_detector',
                "query_logic": "when 'Campo/Miller LLD', 'Electronic LLD','Incon LLD','Mechanical LLD','PPM 4000' then 'Yes' else null en",
                "organization_table_name": "sd_piping",
                "organization_column_name": "TankPipingReleaseDetection",
            }
        }

        view_sql.build_select_query()

        self.assertIn("when nullif(trim(a.\"TankPipingReleaseDetection\"::text), '') in ('Campo/Miller LLD', 'Electronic LLD','Incon LLD','Mechanical LLD','PPM 4000') then 'Yes'", view_sql.select_sql)
        self.assertIn('else null', view_sql.select_sql)
        self.assertIn('end as piping_line_leak_detector', view_sql.select_sql)
        self.assertNotIn('!!!', view_sql.select_sql)

    def test_build_select_query_auto_compiles_where_equals_fragments(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.dataset = SimpleNamespace(organization_id="SD", ust_or_release="ust")
        view_sql.table_name = "ust_tank"
        view_sql.all_col_ids = [10]
        view_sql.existing_col_ids = [10]
        view_sql.required_cols = {}
        view_sql.mapped_epa_columns = {"overfill_prevention_flow_shutoff_device"}
        view_sql.table_aliases = {"sd_tank": "a"}
        view_sql.existing_cols = {
            10: {
                "column_name": "overfill_prevention_flow_shutoff_device",
                "selected_column": 'a."TankOverfillProtection"::character varying(7) as overfill_prevention_flow_shutoff_device',
                "query_logic": 'where = Automatic Shutoff Device',
                "organization_table_name": "sd_tank",
                "organization_column_name": "TankOverfillProtection",
            }
        }

        view_sql.build_select_query()

        self.assertIn("when nullif(trim(a.\"TankOverfillProtection\"::text), '') = 'Automatic Shutoff Device'", view_sql.select_sql)
        self.assertIn('end as overfill_prevention_flow_shutoff_device', view_sql.select_sql)
        self.assertNotIn('!!!', view_sql.select_sql)

    def test_build_select_query_auto_compiles_any_array_fragments(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.dataset = SimpleNamespace(organization_id="SD", ust_or_release="ust")
        view_sql.table_name = "ust_piping"
        view_sql.all_col_ids = [10]
        view_sql.existing_col_ids = [10]
        view_sql.required_cols = {}
        view_sql.mapped_epa_columns = {"piping_material_steel"}
        view_sql.table_aliases = {"sd_piping": "a"}
        view_sql.existing_cols = {
            10: {
                "column_name": "piping_material_steel",
                "selected_column": 'a."TankPipingMaterial"::character varying(3) as piping_material_steel',
                "query_logic": 'WHEN TankPipingMaterial = ANY (ARRAY[Black Steel::text, Cath. Protection::text, Cath. Steel::text]) THEN Yes::text ELSE NULL::text',
                "organization_table_name": "sd_piping",
                "organization_column_name": "TankPipingMaterial",
            }
        }

        view_sql.build_select_query()
        compiled_sql = view_sql.select_sql.lower()

        self.assertIn("when a.\"tankpipingmaterial\" = any (array['black steel'::text, 'cath. protection'::text, 'cath. steel'::text]) then 'yes'::text", compiled_sql)
        self.assertIn("else null::text", compiled_sql)
        self.assertIn('end as piping_material_steel', compiled_sql)
        self.assertNotIn('!!!', view_sql.select_sql)

    def test_build_select_query_auto_compiles_like_fragments(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.dataset = SimpleNamespace(organization_id="SD", ust_or_release="ust")
        view_sql.table_name = "ust_piping"
        view_sql.all_col_ids = [10]
        view_sql.existing_col_ids = [10]
        view_sql.required_cols = {}
        view_sql.mapped_epa_columns = {"piping_material_frp"}
        view_sql.table_aliases = {"sd_piping": "a"}
        view_sql.existing_cols = {
            10: {
                "column_name": "piping_material_frp",
                "selected_column": 'a."TankPipingMaterial"::character varying(3) as piping_material_frp',
                "query_logic": 'WHEN TankPipingMaterial ~~ %Fiberglass%::text THEN Yes::text ELSE NULL::text',
                "organization_table_name": "sd_piping",
                "organization_column_name": "TankPipingMaterial",
            }
        }

        view_sql.build_select_query()
        compiled_sql = view_sql.select_sql.lower()

        self.assertIn("when a.\"tankpipingmaterial\" ~~ '%fiberglass%'::text then 'yes'::text", compiled_sql)
        self.assertIn("else null::text", compiled_sql)
        self.assertIn('end as piping_material_frp', compiled_sql)
        self.assertNotIn('!!!', view_sql.select_sql)

    def test_build_select_query_auto_compiles_date_array_fragments(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.dataset = SimpleNamespace(organization_id="SD", ust_or_release="ust")
        view_sql.table_name = "ust_tank"
        view_sql.all_col_ids = [10]
        view_sql.existing_col_ids = [10]
        view_sql.required_cols = {}
        view_sql.mapped_epa_columns = {"tank_closure_date"}
        view_sql.table_aliases = {"sd_tank": "a"}
        view_sql.existing_cols = {
            10: {
                "column_name": "tank_closure_date",
                "selected_column": 'a."TankRemovedYear"::date as tank_closure_date',
                "query_logic": 'WHEN TankRemovedYear = ANY (ARRAY[04/10/1991::text, 11/15/1989::text]) THEN to_date(a."TankRemovedYear", mm/dd/yyyy::text) ELSE to_date(a."TankRemovedYear"::character varying::text, yyyy::text)',
                "organization_table_name": "sd_tank",
                "organization_column_name": "TankRemovedYear",
            }
        }

        view_sql.build_select_query()
        compiled_sql = view_sql.select_sql.lower()

        self.assertIn("when a.\"tankremovedyear\" = any (array['04/10/1991'::text, '11/15/1989'::text]) then to_date(a.\"tankremovedyear\", 'mm/dd/yyyy'::text)", compiled_sql)
        self.assertIn("else to_date(a.\"tankremovedyear\"::character varying::text, 'yyyy'::text)", compiled_sql)
        self.assertIn('end as tank_closure_date', compiled_sql)
        self.assertNotIn('!!!', view_sql.select_sql)

    def test_build_select_query_auto_compiles_date_fallback_fragments(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.dataset = SimpleNamespace(organization_id="SD", ust_or_release="ust")
        view_sql.table_name = "ust_tank"
        view_sql.all_col_ids = [10]
        view_sql.existing_col_ids = [10]
        view_sql.required_cols = {}
        view_sql.mapped_epa_columns = {"tank_installation_date"}
        view_sql.table_aliases = {"sd_tank": "a"}
        view_sql.existing_cols = {
            10: {
                "column_name": "tank_installation_date",
                "selected_column": 'a."TankInstalledYear"::date as tank_installation_date',
                "query_logic": 'WHEN TankInstalledYear = 1899::double precision THEN NULL::date ELSE to_date(a."TankInstalledYear"::character varying::text, yyyy::text)',
                "organization_table_name": "sd_tank",
                "organization_column_name": "TankInstalledYear",
            }
        }

        view_sql.build_select_query()
        compiled_sql = view_sql.select_sql.lower()

        self.assertIn("when a.\"tankinstalledyear\" = 1899::double precision then null::date", compiled_sql)
        self.assertIn("else to_date(a.\"tankinstalledyear\"::character varying::text, 'yyyy'::text)", compiled_sql)
        self.assertIn('end as tank_installation_date', compiled_sql)
        self.assertNotIn('!!!', view_sql.select_sql)

    def test_validate_generated_sql_executes_explain_query(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.table_name = "ust_tank"
        view_sql.strict = False
        view_sql.cur = unittest.mock.MagicMock()
        view_sql._warn = unittest.mock.MagicMock()
        view_sql.select_sql = 'select distinct\n\ta.col as tank_id\n'
        view_sql.from_sql = 'from ma_ust."tanks" a'
        view_sql.where_sql = '\nwhere 1=1\n;\n'

        view_sql._validate_generated_sql()

        view_sql.cur.execute.assert_called_once()
        validation_sql = view_sql.cur.execute.call_args.args[0]
        self.assertIn('explain select * from (', validation_sql.lower())
        self.assertIn('limit 0', validation_sql.lower())
        view_sql._warn.assert_not_called()

    def test_validate_generated_sql_skips_manual_placeholders(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.table_name = "ust_tank"
        view_sql.strict = False
        view_sql.cur = unittest.mock.MagicMock()
        view_sql._warn = unittest.mock.MagicMock()
        view_sql.select_sql = 'select distinct\n\t!!! case when a.col = 1 then yes end as tank_id\n'
        view_sql.from_sql = 'from ma_ust."tanks" a'
        view_sql.where_sql = '\nwhere 1=1\n;\n'

        view_sql._validate_generated_sql()

        view_sql.cur.execute.assert_not_called()
        view_sql._warn.assert_called_once_with('Skipping SQL validation for ust_tank because manual placeholders remain.')

    @patch.object(utils, "get_join_tables", return_value=[{"organization_table_name": "tanks"}])
    @patch.object(utils, "connect_db")
    def test_collect_table_preflight_reports_recipe_overrides(self, connect_db_mock, _get_join_tables_mock):
        dataset = SimpleNamespace(ust_or_release="ust", control_id=42)
        conn = unittest.mock.MagicMock()
        cur = unittest.mock.MagicMock()
        conn.cursor.return_value = cur
        connect_db_mock.return_value = conn
        cur.fetchall.side_effect = [
            [("facility_id",), ("federally_regulated",)],
            [("facility_id",), ("federally_regulated",)],
            [("facility_id",)],
            [("federally_regulated",), ("tank_name",)],
        ]

        result = _collect_table_preflight(dataset, "ust_tank")

        self.assertEqual(1, result["recipe_override_count"])
        self.assertEqual({"yes_no": 1}, result["recipe_override_family_counts"])
        self.assertIn(
            "Recipe overrides will normalize mapped query_logic for: federally_regulated",
            result["warnings"],
        )

    @patch.object(utils, "get_join_tables", return_value=[])
    @patch.object(utils, "connect_db")
    def test_collect_table_preflight_builds_suggested_fixes(self, connect_db_mock, _get_join_tables_mock):
        dataset = SimpleNamespace(ust_or_release="ust", control_id=42)
        conn = unittest.mock.MagicMock()
        cur = unittest.mock.MagicMock()
        conn.cursor.return_value = cur
        connect_db_mock.return_value = conn
        cur.fetchall.side_effect = [
            [("facility_id",), ("tank_id",), ("federally_regulated",)],
            [("facility_id",)],
            [("facility_id",)],
            [],
        ]

        result = _collect_table_preflight(dataset, "ust_tank")

        self.assertIn(
            "Add join metadata rows for ust_tank in public.ust_element_mapping_joins.",
            result["suggested_fixes"],
        )
        self.assertIn(
            {"severity": "blocking", "message": "Add join metadata rows for ust_tank in public.ust_element_mapping_joins."},
            result["suggested_fix_items"],
        )
        self.assertIn(
            "Add mapped rows for required columns in public.ust_element_mapping: federally_regulated, tank_id",
            result["suggested_fixes"],
        )
        self.assertIn(
            "Add key mapping for tank_id in public.ust_element_mapping for ust_tank.",
            result["suggested_fixes"],
        )
        self.assertEqual({"blocking": 3}, result["suggested_fix_severity_counts"])

    @patch("builtins.print")
    @patch("ust.python.state_processing.create_view_sql._collect_table_preflight")
    def test_preflight_report_prints_recipe_override_summary(self, collect_preflight_mock, print_mock):
        collect_preflight_mock.return_value = {
            "table_name": "ust_tank",
            "join_count": 2,
            "required_count": 10,
            "mapped_count": 9,
            "missing_required_count": 1,
            "recipe_override_count": 2,
            "recipe_override_columns": ["federally_regulated", "ust_status"],
            "recipe_override_family_counts": {"yes_no": 1, "yes_null_bucket": 1},
            "suggested_fixes": ["Add key mapping for tank_id in public.ust_element_mapping for ust_tank."],
            "suggested_fix_items": [
                {
                    "severity": "blocking",
                    "message": "Add key mapping for tank_id in public.ust_element_mapping for ust_tank.",
                }
            ],
            "suggested_fix_severity_counts": {"blocking": 1},
            "warnings": [],
            "errors": [],
        }

        preflight_report("ust", 42, table_name="ust_tank")

        print_mock.assert_any_call("  recipe overrides: 2")
        print_mock.assert_any_call("  suggested fixes: 1 (blocking=1)")
        print_mock.assert_any_call("  recipe override columns: federally_regulated, ust_status")
        print_mock.assert_any_call("  recipe override families: yes/no=1, yes/null bucket=1")
        print_mock.assert_any_call("  FIX[BLOCKING]: Add key mapping for tank_id in public.ust_element_mapping for ust_tank.")
        print_mock.assert_any_call("\nSuggested fix rollup: 1 total (blocking=1)")
        print_mock.assert_any_call(
            "\nRecipe family legend: greater-than-one yes/no=greater_than_one_yes_no, yes/no=yes_no, yes/null bucket=yes_null_bucket"
        )
        print_mock.assert_any_call("\nPreflight totals: warnings=0, errors=0, suggested_fixes=1 (blocking=1)")

    @patch("builtins.print")
    @patch("ust.python.state_processing.create_view_sql._collect_table_preflight")
    def test_preflight_report_prints_clean_summary_when_no_findings(self, collect_preflight_mock, print_mock):
        collect_preflight_mock.return_value = {
            "table_name": "ust_tank",
            "join_count": 2,
            "required_count": 10,
            "mapped_count": 10,
            "missing_required_count": 0,
            "recipe_override_count": 0,
            "recipe_override_columns": [],
            "recipe_override_family_counts": {},
            "suggested_fixes": [],
            "suggested_fix_items": [],
            "suggested_fix_severity_counts": {},
            "warnings": [],
            "errors": [],
        }

        preflight_report("ust", 42, table_name="ust_tank")

        print_mock.assert_any_call("\nPreflight totals: warnings=0, errors=0, suggested_fixes=0")
        print_mock.assert_any_call("\nPreflight summary: clean (no warnings, errors, or suggested fixes).")

    @patch.object(utils, "process_sql")
    def test_build_where_sql_uses_safe_key_predicates_for_ust(self, process_sql_mock):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.dataset = SimpleNamespace(ust_or_release="ust", schema="ma_ust", control_id=123)
        view_sql.table_name = "ust_compartment"
        view_sql.strict = False
        view_sql.conn = unittest.mock.MagicMock()
        view_sql.cur = unittest.mock.MagicMock()
        view_sql._warn = unittest.mock.MagicMock()
        view_sql.cur.fetchall.return_value = [
            ("facility_identifier", "facility_id"),
            ("tank_identifier", "tank_id"),
        ]

        view_sql.build_where_sql()

        process_sql_mock.assert_called_once()
        self.assertIn("nullif(trim(a.\"facility_identifier\"::text), '') = unreg.facility_id", view_sql.where_sql)
        self.assertIn(
            "case when nullif(trim(a.\"tank_identifier\"::text), '') ~ '^[+-]?\\d+$' then nullif(trim(a.\"tank_identifier\"::text), '')::integer else null::integer end = unreg.tank_id",
            view_sql.where_sql,
        )

    @patch.object(utils, "process_sql")
    def test_build_where_sql_uses_safe_key_predicates_for_release(self, process_sql_mock):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.dataset = SimpleNamespace(ust_or_release="release", schema="ma_release", control_id=123)
        view_sql.table_name = "ust_release_substance"
        view_sql.strict = False
        view_sql.conn = unittest.mock.MagicMock()
        view_sql.cur = unittest.mock.MagicMock()
        view_sql._warn = unittest.mock.MagicMock()
        view_sql.cur.fetchall.return_value = [
            ("release_identifier", "release_id"),
            ("substance_identifier", "substance_id"),
        ]

        view_sql.build_where_sql()

        process_sql_mock.assert_called_once()
        self.assertIn("nullif(trim(a.\"release_identifier\"::text), '') = unreg.release_id", view_sql.where_sql)
        self.assertIn("nullif(trim(a.\"substance_identifier\"::text), '') = unreg.substance_id", view_sql.where_sql)


if __name__ == "__main__":
    unittest.main()
