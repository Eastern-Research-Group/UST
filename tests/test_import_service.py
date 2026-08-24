import unittest
from types import SimpleNamespace
from unittest.mock import patch

import pywintypes

from ust.python.state_processing.create_view_sql import (
    ViewSql,
    _collect_table_preflight,
    preflight_report,
)
from ust.python.state_processing.export_template import Template
from ust.python.state_processing.qa_check import QualityCheck
from ust.python.state_processing.create_unreg_tables import UnregTables
from ust.python.state_processing.exclude_unregulated import Exclude, get_table_alias
from ust.python.state_processing.qa_exclusions import Exclusions
from ust.python.util.peer_review import PeerReview
from ust.python.util import utils
from ust.python.util.database_importer import DatabaseImporter
from ust.python.util.emailer import Emailer
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


class EmailerTests(unittest.TestCase):
    @patch("ust.python.util.emailer.logger")
    @patch("ust.python.util.emailer.win32com.client.Dispatch")
    def test_email_returns_true_on_success(self, dispatch, logger_mock):
        outlook = unittest.mock.MagicMock()
        email_item = unittest.mock.MagicMock()
        outlook.CreateItem.return_value = email_item
        dispatch.return_value = outlook

        emailer = Emailer(recipient="test@example.com", subject="Subject", body="Body")

        result = emailer.email()

        self.assertTrue(result)
        email_item.Send.assert_called_once_with()
        logger_mock.info.assert_called_once_with("Email sent to %s", "test@example.com")
        logger_mock.error.assert_not_called()

    @patch("ust.python.util.emailer.logger")
    @patch("ust.python.util.emailer.win32com.client.Dispatch")
    def test_email_returns_false_when_send_fails(self, dispatch, logger_mock):
        outlook = unittest.mock.MagicMock()
        email_item = unittest.mock.MagicMock()
        email_item.Send.side_effect = pywintypes.com_error(-1, "boom", None, None)
        outlook.CreateItem.return_value = email_item
        dispatch.return_value = outlook

        emailer = Emailer(recipient="test@example.com", subject="Subject", body="Body")

        result = emailer.email()

        self.assertFalse(result)
        email_item.Send.assert_called_once_with()
        logger_mock.error.assert_called_once()
        logger_mock.info.assert_not_called()


class DatabaseImporterTests(unittest.TestCase):
    def test_get_table_name_from_file_name_handles_multiple_path_styles(self):
        importer = DatabaseImporter.__new__(DatabaseImporter)

        self.assertEqual("My_File", importer.get_table_name_from_file_name(r"C:\\tmp\\My File.xlsx"))
        self.assertEqual("another_file", importer.get_table_name_from_file_name("/tmp/another file.csv"))


class PeerReviewTests(unittest.TestCase):
    def test_build_row_difference_count_sql_omits_order_and_select_star(self):
        review = PeerReview.__new__(PeerReview)
        review.dataset = SimpleNamespace(schema="dc_ust", ust_or_release="ust", control_id=30)
        key_rows = [
            ("facility_id", "FacilityID"),
            ("tank_id", "TankID"),
            ("compartment_id", "CompartmentID"),
            ("piping_id", "PipingID"),
        ]

        count_sql = review._build_row_difference_count_sql("v_ust_piping", key_rows)

        self.assertTrue(count_sql.startswith("select count(*) from ("))
        self.assertIn("select 1 from dc_ust.v_ust_piping a", count_sql)
        self.assertIn("b.ust_control_id = 30", count_sql)
        self.assertNotIn("select *", count_sql.lower())
        self.assertNotIn("order by", count_sql.lower())

    def test_build_row_difference_sql_filters_public_view_by_release_control_id(self):
        review = PeerReview.__new__(PeerReview)
        review.dataset = SimpleNamespace(schema="dc_release", ust_or_release="release", control_id=18)

        sql = review._build_row_difference_sql("v_ust_release", [("release_id", "ReleaseID")])

        self.assertIn("from public.v_ust_release b", sql)
        self.assertIn("b.release_control_id = 18", sql)
        self.assertIn('a.release_id = b."ReleaseID"', sql)

    @patch("ust.python.util.peer_review.pd.read_sql")
    @patch.object(utils, "process_sql")
    def test_get_sql_counts_without_reading_full_diff_when_display_disabled(self, process_sql_mock, read_sql_mock):
        review = PeerReview.__new__(PeerReview)
        review.dataset = SimpleNamespace(schema="dc_ust", ust_or_release="ust", control_id=30)
        review.error_tables = ["v_ust_piping"]
        review.display_bad_data = False
        review.vsql = ""
        review.conn = unittest.mock.MagicMock()
        review.cur = unittest.mock.MagicMock()
        review.cur.fetchall.return_value = [("piping_id", "PipingID")]
        review.cur.fetchone.side_effect = [(7,), ("create view sql",)]

        review.get_sql()

        read_sql_mock.assert_not_called()
        self.assertIn("--There are 7 rows in dc_ust.v_ust_piping that do not exist in public.v_ust_piping", review.vsql)
        self.assertIn("select * from dc_ust.v_ust_piping a", review.vsql)

    def test_compare_row_counts_records_failed_state_view_count_and_continues(self):
        review = PeerReview.__new__(PeerReview)
        review.dataset = SimpleNamespace(schema="dc_ust", ust_or_release="ust", control_id=30)
        review.views_to_review = ["v_ust_tank"]
        review.error_tables = []
        review.vsql = ""
        review._fetchone_value = unittest.mock.MagicMock(return_value=None)

        review.compare_row_counts()

        self.assertEqual([], review.error_tables)
        self.assertIn("Unable to complete peer review row-count comparison for dc_ust.v_ust_tank", review.vsql)
        self.assertIn("select count(*) from dc_ust.v_ust_tank;", review.vsql)


class TemplateTests(unittest.TestCase):
    @patch("ust.python.state_processing.export_template.op.Workbook")
    def test_process_saves_workbook_only_during_cleanup(self, workbook_cls):
        workbook = unittest.mock.MagicMock()
        workbook.sheetnames = []
        workbook_cls.return_value = workbook
        template = Template.__new__(Template)
        template.dataset = SimpleNamespace(export_file_path="C:/tmp/template.xlsx")
        template.data_only = True
        template.template_only = False
        template.substance_mapping_only = False
        template.make_data_tabs = unittest.mock.MagicMock()
        template.cleanup_wb = Template.cleanup_wb.__get__(template, Template)

        template.process()

        workbook.save.assert_called_once_with("C:/tmp/template.xlsx")

    @patch.object(utils, "connect_db")
    def test_get_headers_caches_metadata(self, connect_db_mock):
        conn = unittest.mock.MagicMock()
        cur = unittest.mock.MagicMock()
        conn.cursor.return_value = cur
        connect_db_mock.return_value = conn
        cur.fetchall.return_value = [("facility_id",), ("tank_id",)]
        template = Template.__new__(Template)
        template._headers_cache = {}

        first = template._get_headers("v_ust_tank", schema="dc_ust")
        second = template._get_headers("v_ust_tank", schema="dc_ust")

        self.assertEqual(["facility_id", "tank_id"], first)
        self.assertEqual(first, second)
        connect_db_mock.assert_called_once_with()
        cur.execute.assert_called_once()

    @patch.object(utils, "process_sql")
    def test_get_public_table_columns_caches_metadata(self, process_sql_mock):
        template = Template.__new__(Template)
        template._public_table_columns_cache = {}
        cur = unittest.mock.MagicMock()
        cur.fetchall.return_value = [("facility_type",), ("inactive_flag",)]

        first = template._get_public_table_columns(cur, "facility_types")
        second = template._get_public_table_columns(cur, "facility_types")

        self.assertEqual({"facility_type", "inactive_flag"}, first)
        self.assertEqual(first, second)
        process_sql_mock.assert_called_once()

    def test_substance_lookup_query_filters_to_ust_tank_substance_when_view_exists(self):
        template = Template.__new__(Template)
        template.dataset = SimpleNamespace(ust_or_release="ust", schema="sd_ust", control_id=9)
        cur = unittest.mock.MagicMock()
        cur.fetchone.return_value = (1,)
        cur.fetchall.return_value = [("substance_id", "integer")]

        sql, params = template._build_substance_lookup_query(cur)

        self.assertIn('"sd_ust"."v_ust_tank_substance"', sql)
        self.assertIn('substance_filter."substance_id" = s.substance_id', sql)
        self.assertNotIn('v_release_substance', sql)
        self.assertEqual([], params)

    def test_substance_mapping_query_filters_to_regulated_source_rows_when_possible(self):
        template = Template.__new__(Template)
        template.dataset = SimpleNamespace(ust_or_release="ust", schema="sd_ust", control_id=9)
        cur = unittest.mock.MagicMock()
        cur.fetchone.return_value = (1,)
        cur.fetchall.side_effect = [
            [("facility_id", "character varying"), ("tank_id", "integer"), ("substance_id", "integer")],
            [
                ("facility_id", "tanks", "FacilityNumber"),
                ("substance_id", "tanks", "TankProduct"),
                ("tank_id", "tanks", "TankNumber"),
            ],
            [("FacilityNumber",), ("TankNumber",), ("TankProduct",)],
        ]

        sql, params = template._build_substance_mapping_query(cur)

        self.assertIn('from "sd_ust"."tanks" substance_source', sql)
        self.assertIn('join "sd_ust"."v_ust_tank_substance" substance_filter', sql)
        self.assertIn('nullif(trim(substance_source."TankProduct"::text), \'\') = a.organization_value', sql)
        self.assertIn('nullif(trim(substance_source."FacilityNumber"::text), \'\') = substance_filter."facility_id"', sql)
        self.assertIn('nullif(trim(substance_source."TankNumber"::text), \'\')::integer else null::integer end = substance_filter."tank_id"', sql)
        self.assertIn('substance_filter."substance_id" = s.substance_id', sql)
        self.assertEqual([9], params)

    @patch.object(utils, "add_ws_filter")
    @patch.object(utils, "autowidth")
    @patch.object(utils, "process_sql")
    @patch.object(utils, "connect_db")
    def test_make_data_tab_adds_filter_to_data_tabs(self, connect_db_mock, process_sql_mock, autowidth_mock, add_filter_mock):
        template = Template.__new__(Template)
        template.dataset = SimpleNamespace(ust_or_release="ust", control_id=30)
        template.template_only = False
        template._headers_cache = {("public", "v_ust_tank"): ["ust_control_id", "FacilityID", "TankID"]}
        template.wb = unittest.mock.MagicMock()
        ws = unittest.mock.MagicMock()
        template.wb.create_sheet.return_value = ws
        conn = unittest.mock.MagicMock()
        cur = unittest.mock.MagicMock()
        conn.cursor.return_value = cur
        connect_db_mock.return_value = conn
        cur.fetchall.return_value = [(30, "F1", 1)]

        template.make_data_tab(("v_ust_tank", "Tank"))

        add_filter_mock.assert_called_once_with(ws)

    def test_substance_mapping_query_filters_release_raw_substances_when_view_exists(self):
        template = Template.__new__(Template)
        template.dataset = SimpleNamespace(ust_or_release="release", schema="ks_release", control_id=23)
        cur = unittest.mock.MagicMock()
        cur.fetchone.return_value = (1,)
        cur.fetchall.return_value = [("substance", "text")]

        sql, params = template._build_substance_mapping_query(cur)

        self.assertIn('"ks_release"."v_ust_release_substance"', sql)
        self.assertIn('nullif(trim(substance_filter."substance"::text), \'\') = a.organization_value', sql)
        self.assertNotIn('"ks_release"."v_release_substance"', sql)
        self.assertEqual([23], params)

    def test_quote_identifier_allows_spaces_and_escapes_quotes(self):
        template = Template.__new__(Template)

        self.assertEqual('"Substance Released1"', template._quote_identifier("Substance Released1"))
        self.assertEqual('"bad""name"', template._quote_identifier('bad"name'))

    def test_substance_mapping_query_is_unfiltered_when_state_view_is_missing(self):
        template = Template.__new__(Template)
        template.dataset = SimpleNamespace(ust_or_release="release", schema="ks_release", control_id=23)
        cur = unittest.mock.MagicMock()
        cur.fetchone.return_value = (0,)

        sql, params = template._build_substance_mapping_query(cur)

        self.assertNotIn('"ks_release"."v_ust_release_substance"', sql)
        self.assertNotIn('substance_filter', sql)
        self.assertEqual([23], params)

    def test_substance_mapping_query_resolves_source_column_case(self):
        template = Template.__new__(Template)
        template.dataset = SimpleNamespace(ust_or_release="ust", schema="hi_ust", control_id=37)
        cur = unittest.mock.MagicMock()
        cur.fetchone.return_value = (1,)
        cur.fetchall.side_effect = [
            [("facility_id", "character varying"), ("tank_id", "integer"), ("substance_id", "integer")],
            [
                ("facility_id", "tank_source", "FacilityID"),
                ("substance_id", "tank_source", "TankProduct"),
                ("tank_id", "tank_source", "TankID"),
            ],
            [("FacilityId",), ("TankID",), ("TankProduct",)],
            [("FacilityId",), ("TankID",), ("TankProduct",)],
            [("FacilityId",), ("TankID",), ("TankProduct",)],
        ]

        sql, params = template._build_substance_mapping_query(cur)

        self.assertIn('substance_source."FacilityId"', sql)
        self.assertNotIn('substance_source."FacilityID"', sql)
        self.assertEqual([37], params)


class QualityCheckTests(unittest.TestCase):
    @patch.object(utils, "process_sql")
    def test_check_bad_mapping_writes_only_invalid_rows_to_detail_sheet(self, process_sql_mock):
        qc = QualityCheck.__new__(QualityCheck)
        qc.dataset = SimpleNamespace(ust_or_release="ust", control_id=9)
        qc.table_name = "ust_piping"
        qc.view_name = "v_ust_piping"
        qc.conn = unittest.mock.MagicMock()
        qc.cur = unittest.mock.MagicMock()
        qc.include_details = True
        qc.error_dict = {}
        qc.error_cnt_dict = {}
        qc.lookup_values_cache = {}
        qc.wb = unittest.mock.MagicMock()
        qc.header_cache = {}
        qc.write_invalid_epa_values_to_ws = unittest.mock.MagicMock()

        qc.cur.fetchall.side_effect = [
            [
                ("piping_wall_type_id", "Single walled", "piping_wall_types", "piping_wall_type"),
                ("piping_wall_type_id", "Single Wall", "piping_wall_types", "piping_wall_type"),
            ],
            [("Single Wall",), ("Double Wall",)],
        ]

        qc.check_bad_mapping()

        qc.write_invalid_epa_values_to_ws.assert_called_once_with(
            [
                (
                    "ust_piping",
                    "piping_wall_type_id",
                    "Single walled",
                    "piping_wall_types",
                    "piping_wall_type",
                    "Double Wall, Single Wall",
                )
            ],
        )
        self.assertEqual(
            {"Invalid EPA values in ust_element_value_mapping": 1},
            qc.error_cnt_dict,
        )
        self.assertEqual(
            {"Invalid EPA value in piping_wall_type_id: Single walled": "piping_wall_types.piping_wall_type"},
            qc.error_dict,
        )

    @patch.object(utils, "process_sql")
    def test_check_bad_mapping_accumulates_invalid_counts_across_views(self, process_sql_mock):
        qc = QualityCheck.__new__(QualityCheck)
        qc.dataset = SimpleNamespace(ust_or_release="ust", control_id=9)
        qc.table_name = "ust_piping"
        qc.view_name = "v_ust_piping"
        qc.conn = unittest.mock.MagicMock()
        qc.cur = unittest.mock.MagicMock()
        qc.include_details = False
        qc.error_dict = {}
        qc.error_cnt_dict = {"Invalid EPA values in ust_element_value_mapping": 2}
        qc.lookup_values_cache = {("piping_wall_types", "piping_wall_type"): {"Single Wall"}}

        qc.cur.fetchall.return_value = [
            ("piping_wall_type_id", "Single walled", "piping_wall_types", "piping_wall_type_id"),
        ]

        qc.check_bad_mapping()

        self.assertEqual(3, qc.error_cnt_dict["Invalid EPA values in ust_element_value_mapping"])

    @patch.object(utils, "get_table_existence", return_value=True)
    def test_check_missing_parent_view_keys_uses_except_keyset(self, _table_exists_mock):
        qc = QualityCheck.__new__(QualityCheck)
        qc.dataset = SimpleNamespace(ust_or_release="ust", schema="tn_ust")
        qc.view_name = "v_ust_piping"
        qc.views_to_review = ["v_ust_compartment", "v_ust_piping"]
        qc.view_columns_cache = {"v_ust_piping": ["facility_id", "tank_id", "compartment_id"]}
        qc.error_dict = {}
        qc.error_cnt_dict = {}
        qc.include_details = True
        qc._select_count = unittest.mock.MagicMock(return_value=0)

        qc.check_missing_parent_view_keys()

        sql = qc._select_count.call_args.args[0]
        self.assertIn("except", sql.lower())
        self.assertIn("with missing_keys as", sql.lower())
        self.assertNotIn("not exists", sql.lower())
        self.assertIn('from tn_ust.v_ust_piping', sql)
        self.assertIn('from tn_ust.v_ust_compartment', sql)

    @patch.object(utils, "get_table_existence", return_value=True)
    def test_check_missing_parent_view_keys_skips_in_fast_mode(self, _table_exists_mock):
        qc = QualityCheck.__new__(QualityCheck)
        qc.dataset = SimpleNamespace(ust_or_release="ust", schema="tn_ust")
        qc.view_name = "v_ust_piping"
        qc.views_to_review = ["v_ust_compartment", "v_ust_piping"]
        qc.error_dict = {}
        qc.error_cnt_dict = {}
        qc.include_details = False
        qc._select_count = unittest.mock.MagicMock()

        qc.check_missing_parent_view_keys()

        qc._select_count.assert_not_called()
        self.assertEqual(
            0,
            qc.error_cnt_dict["Rows in tn_ust.v_ust_piping missing keys in tn_ust.v_ust_compartment"],
        )

    @patch.object(utils, "get_table_existence", return_value=True)
    @patch.object(utils, "process_sql")
    def test_check_unregulated_parents_handles_missing_reason_column(self, process_sql_mock, _table_exists_mock):
        qc = QualityCheck.__new__(QualityCheck)
        qc.dataset = SimpleNamespace(ust_or_release="ust", schema="dc_ust")
        qc.view_name = "v_ust_tank"
        qc.conn = unittest.mock.MagicMock()
        qc.cur = unittest.mock.MagicMock()
        qc.include_details = True
        qc.error_dict = {}
        qc.error_cnt_dict = {}
        qc.view_columns_cache = {"v_ust_tank": ["facility_id", "tank_id"]}
        qc.relation_columns_cache = {("dc_ust", "erg_unregulated_tanks"): ["facility_id", "tank_id"]}
        qc._select_count = unittest.mock.MagicMock(return_value=1)
        qc.write_to_ws = unittest.mock.MagicMock()
        qc.cur.fetchall.return_value = [("F1", 1, None)]

        qc.check_unregulated_parents()

        detail_sql = process_sql_mock.call_args.args[2]
        self.assertIn("null::varchar(1000) as unregulated_reason", detail_sql)
        self.assertNotIn("b.unregulated_reason", detail_sql)
        qc.write_to_ws.assert_called_once_with([("F1", 1, None)], "Unreg tank")

    @patch.object(utils, "get_table_existence", return_value=True)
    @patch.object(utils, "process_sql")
    def test_check_unregulated_substances_handles_missing_reason_column(self, process_sql_mock, _table_exists_mock):
        qc = QualityCheck.__new__(QualityCheck)
        qc.dataset = SimpleNamespace(ust_or_release="ust", schema="dc_ust")
        qc.conn = unittest.mock.MagicMock()
        qc.cur = unittest.mock.MagicMock()
        qc.error_dict = {}
        qc.error_cnt_dict = {}
        qc.view_columns_cache = {"v_ust_facility": ["facility_id", "facility_type1"], "v_ust_compartment": []}
        qc.relation_columns_cache = {("dc_ust", "erg_unregulated_tanks"): ["facility_id", "tank_id"]}
        qc.cur.fetchone.side_effect = [(1,), (0,), (2,), (3,)]
        qc.cur.fetchall.return_value = [("F1", 1), ("F2", 2)]

        qc.check_unregulated_substances()

        self.assertEqual({"Rows with unregulated substances not excluded from views": 2}, qc.error_cnt_dict)
        message = next(iter(qc.error_dict))
        self.assertIn("missing unregulated_reason column", message)
        self.assertIn("create-unreg --drop-existing", message)

    def test_check_nonunique_skips_full_row_scan_in_fast_mode(self):
        qc = QualityCheck.__new__(QualityCheck)
        qc.dataset = SimpleNamespace(schema="dc_ust")
        qc.view_name = "v_ust_piping"
        qc.include_details = False
        qc.error_cnt_dict = {}
        qc._select_count = unittest.mock.MagicMock()

        qc.check_nonunique()

        qc._select_count.assert_not_called()
        self.assertEqual(
            0,
            qc.error_cnt_dict["nonunique rows in dc_ust.v_ust_piping"],
        )


class ExclusionsTests(unittest.TestCase):
    @patch.object(utils, "connect_db")
    @patch.object(utils, "process_sql")
    def test_release_exclusions_only_query_release_unregulated_tables(self, process_sql_mock, connect_db_mock):
        conn = unittest.mock.MagicMock()
        cur = unittest.mock.MagicMock()
        conn.cursor.return_value = cur
        connect_db_mock.return_value = conn
        cur.fetchall.return_value = []

        Exclusions(SimpleNamespace(schema="dc_release", ust_or_release="release"))

        params = process_sql_mock.call_args.kwargs["params"]
        self.assertEqual(("dc_release", ["erg_unregulated_releases", "erg_unregulated_substances"]), params)

    @patch.object(utils, "connect_db")
    @patch.object(utils, "process_sql")
    def test_ust_exclusions_only_query_ust_unregulated_tables(self, process_sql_mock, connect_db_mock):
        conn = unittest.mock.MagicMock()
        cur = unittest.mock.MagicMock()
        conn.cursor.return_value = cur
        connect_db_mock.return_value = conn
        cur.fetchall.return_value = []

        Exclusions(SimpleNamespace(schema="dc_ust", ust_or_release="ust"))

        params = process_sql_mock.call_args.kwargs["params"]
        self.assertEqual(("dc_ust", ["erg_unregulated_facilities", "erg_unregulated_tanks"]), params)


class ExcludeUnregulatedTests(unittest.TestCase):
    def test_get_table_alias_handles_quoted_schema_table_and_alias(self):
        view_def = 'select *\nfrom "hi_release"."tblLUSTSite" a join "hi_release"."tblFacility" b on true'

        self.assertEqual('a', get_table_alias(view_def, 'hi_release.tblLUSTSite'))

    def test_get_new_view_def_adds_release_parent_and_substance_exclusions(self):
        exclude = Exclude.__new__(Exclude)
        exclude.dataset = SimpleNamespace(schema="hi_release", ust_or_release="release")
        exclude.unreg = SimpleNamespace(
            unreg_parent_table="hi_release.erg_unregulated_releases",
            unreg_parent_col="release_id",
            unreg_substance_table="hi_release.erg_unregulated_substances",
        )
        exclude.override_existing_unreg_check = False
        exclude.df = __import__('pandas').DataFrame([
            {
                "epa_table_name": "ust_release_substance",
                "epa_column_name": "release_id",
                "table_name": "tblLUSTSite",
                "column_name": "EventID",
            },
            {
                "epa_table_name": "ust_release_substance",
                "epa_column_name": "substance_id",
                "table_name": "tblLUSTSite",
                "column_name": "Substance Released1",
            },
        ])
        exclude.get_view_def = unittest.mock.MagicMock(
            return_value='\n\ncreate or replace view "hi_release"."v_ust_release_substance" as\nselect *\nfrom "hi_release"."tblLUSTSite" a'
        )

        view_def = exclude.get_new_view_def("v_ust_release_substance")

        self.assertIn('not exists (select 1 from hi_release.erg_unregulated_releases unregparent', view_def)
        self.assertIn('a."EventID"::varchar(50) = unregparent.release_id', view_def)
        self.assertIn('not exists (select 1 from hi_release.erg_unregulated_substances unregsub', view_def)
        self.assertIn('a."Substance Released1" = unregsub.organization_substance', view_def)


class UnregTablesTests(unittest.TestCase):
    @patch.object(utils, "process_sql")
    def test_build_join_predicate_uses_actual_join_table_column_case(self, process_sql_mock):
        unreg = UnregTables.__new__(UnregTables)
        unreg.dataset = SimpleNamespace(schema="hi_release")
        unreg.conn = unittest.mock.MagicMock()
        unreg.cur = unittest.mock.MagicMock()
        unreg.source_columns_cache = {}
        unreg.cur.fetchall.side_effect = [
            [("FacilityId",)],
            [("FacilityID",), ("Facility Description",)],
        ]

        predicate = unreg._build_join_predicate(
            "tblLUSTSite",
            "tblFacility",
            "FacilityID",
            None,
            "a",
            "b",
        )

        self.assertEqual('a."FacilityId" = b."FacilityID"', predicate)

    @patch.object(utils, "process_sql")
    def test_build_join_predicate_uses_join_fk_when_available(self, process_sql_mock):
        unreg = UnregTables.__new__(UnregTables)
        unreg.dataset = SimpleNamespace(schema="hi_release")
        unreg.conn = unittest.mock.MagicMock()
        unreg.cur = unittest.mock.MagicMock()
        unreg.source_columns_cache = {}
        unreg.cur.fetchall.side_effect = [
            [("FacilityId",)],
            [("FacilityID",)],
        ]

        predicate = unreg._build_join_predicate(
            "tblLUSTSite",
            "tblFacility",
            "FacilityId",
            "FacilityID",
            "a",
            "b",
        )

        self.assertEqual('a."FacilityId" = b."FacilityID"', predicate)

    @patch.object(utils, "process_sql")
    def test_append_missing_source_join_infers_common_key_columns(self, process_sql_mock):
        unreg = UnregTables.__new__(UnregTables)
        unreg.dataset = SimpleNamespace(schema="dc_ust")
        unreg.conn = unittest.mock.MagicMock()
        unreg.cur = unittest.mock.MagicMock()
        unreg.source_columns_cache = {
            "compartment": ["FacilityID", "TankID", "CompartmentSubstanceStored"],
            "tank": ["FacilityID", "TankID", "TankName"],
        }

        from_sql = unreg._append_missing_source_join(
            '\nfrom dc_ust."compartment" a',
            {"compartment"},
            "compartment",
            "tank",
            {"compartment": "a", "tank": "b"},
        )

        self.assertIn('join dc_ust."tank" b', from_sql)
        self.assertIn('a."FacilityID" = b."FacilityID"', from_sql)
        self.assertIn('a."TankID" = b."TankID"', from_sql)

    def test_resolve_source_column_uses_single_close_match(self):
        unreg = UnregTables.__new__(UnregTables)
        unreg.source_columns_cache = {"tn_compartments": ["Facility Id Ust", "Tank Id"]}

        self.assertEqual(
            "Facility Id Ust",
            unreg._resolve_source_column("tn_compartments", "Facility Id US"),
        )

    def test_create_tables_rebuilds_drop_existing_with_view_preservation(self):
        unreg = UnregTables.__new__(UnregTables)
        unreg.views_only = False
        unreg.drop_existing = True
        unreg.connect_db = unittest.mock.MagicMock()
        unreg.disconnect_db = unittest.mock.MagicMock()
        unreg.rebuild_tables_preserving_views = unittest.mock.MagicMock()

        unreg.create_tables()

        unreg.rebuild_tables_preserving_views.assert_called_once_with()
        unreg.disconnect_db.assert_called_once_with()

    def test_rebuild_tables_preserving_views_backs_up_drops_recreates_and_restores(self):
        unreg = UnregTables.__new__(UnregTables)
        unreg.dataset = SimpleNamespace(schema="dc_ust", ust_or_release="ust")
        unreg.unreg_substance_table = "dc_ust.erg_unregulated_tanks"
        unreg.unreg_parent_table = "dc_ust.erg_unregulated_facilities"
        unreg.conn = unittest.mock.MagicMock()
        unreg.cur = unittest.mock.MagicMock()
        unreg._capture_dependent_view_definitions = unittest.mock.MagicMock(return_value={"v_ust_tank": "select 1 as facility_id"})
        unreg._table_exists = unittest.mock.MagicMock(return_value=True)
        unreg.backup_table = unittest.mock.MagicMock()
        unreg._create_unreg_substance_table = unittest.mock.MagicMock()
        unreg._create_unreg_parent_table = unittest.mock.MagicMock()
        unreg._restore_schema_views = unittest.mock.MagicMock()

        with patch.object(utils, "process_sql") as process_sql_mock:
            unreg.rebuild_tables_preserving_views()

        self.assertEqual(2, unreg.backup_table.call_count)
        self.assertEqual(2, process_sql_mock.call_count)
        self.assertIn('drop table dc_ust."erg_unregulated_tanks" cascade', process_sql_mock.call_args_list[0].args[2])
        unreg._capture_dependent_view_definitions.assert_called_once_with([
            "dc_ust.erg_unregulated_tanks",
            "dc_ust.erg_unregulated_facilities",
        ])
        unreg._create_unreg_substance_table.assert_called_once_with()
        unreg._create_unreg_parent_table.assert_called_once_with()
        unreg._restore_schema_views.assert_called_once_with({"v_ust_tank": "select 1 as facility_id"})

    @patch.object(utils, "process_sql")
    def test_capture_dependent_view_definitions_filters_to_target_tables(self, process_sql_mock):
        unreg = UnregTables.__new__(UnregTables)
        unreg.dataset = SimpleNamespace(schema="dc_ust")
        unreg.cur = unittest.mock.MagicMock()
        unreg.cur.fetchall.return_value = [("v_ust_tank", "select 1")]

        result = unreg._capture_dependent_view_definitions([
            "dc_ust.erg_unregulated_tanks",
            "dc_ust.erg_unregulated_facilities",
        ])

        sql = process_sql_mock.call_args.args[2]
        params = process_sql_mock.call_args.kwargs["params"]
        self.assertIn("pg_depend", sql)
        self.assertIn("source_table.relname = any", sql)
        self.assertEqual(("dc_ust", ["erg_unregulated_tanks", "erg_unregulated_facilities"]), params)
        self.assertEqual({"v_ust_tank": "select 1"}, result)


class ViewSqlTests(unittest.TestCase):
    def test_apply_table_alias_resolves_source_column_case(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.table_aliases = {"tblLUSTSite": "a"}
        view_sql.table_alias_fallbacks = {}
        view_sql._source_table_columns_cache = {"tblLUSTSite": {"FacilityId"}}
        view_sql._has_value = ViewSql._has_value.__get__(view_sql, ViewSql)

        selected_column = view_sql._apply_table_alias(
            "tblLUSTSite",
            'nullif(trim("FacilityID"::text), \'\')::character varying(50) as facility_id',
        )

        self.assertIn('a."FacilityId"', selected_column)
        self.assertNotIn('a."FacilityID"', selected_column)

    def test_build_from_sql_resolves_join_column_case(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.dataset = SimpleNamespace(schema="hi_release")
        view_sql.from_sql = "from hi_release.\"tblLUSTSite\" a"
        view_sql.table_aliases = {"tblLUSTSite": "a"}
        view_sql.used_aliases = {"a"}
        view_sql._source_table_columns_cache = {
            "tblLUSTSite": {"FacilityId"},
            "tblFacility": {"FacilityID", "Facility Description"},
        }
        view_sql.join_info = {
            "table_type": "org",
            "organization_join_column": "FacilityID",
            "organization_join_fk": "FacilityID",
            "organization_join_column2": None,
            "organization_join_fk2": None,
            "organization_join_column3": None,
            "organization_join_fk3": None,
        }
        view_sql._has_value = ViewSql._has_value.__get__(view_sql, ViewSql)

        view_sql.build_from_sql("tblFacility", "b", "a")

        self.assertIn('a."FacilityId" = b."FacilityID"', view_sql.from_sql)

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

    def test_get_existing_cols_uses_fallback_alias_for_skipped_join_table(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.dataset = SimpleNamespace(control_id=123, ust_or_release="ust")
        view_sql.table_name = "ust_piping"
        view_sql.required_cols = {
            10: {"column_name": "compartment_id", "data_type": "integer", "character_maximum_length": None},
        }
        view_sql.table_aliases = {"tanks": "a"}
        view_sql.table_alias_fallbacks = {"erg_piping": "a"}
        view_sql.warnings = []
        view_sql.mapped_epa_columns = set()

        view_sql.cur = unittest.mock.MagicMock()
        view_sql.cur.fetchall.side_effect = [
            [],
            [(10, "compartment_id", "compartment_id", "erg_piping")],
        ]
        view_sql.cur.fetchone.return_value = ("integer", None)
        view_sql._warn = unittest.mock.MagicMock()

        existing_cols = view_sql.get_existing_cols()

        self.assertEqual(
            "case when nullif(trim(a.\"compartment_id\"::text), '') ~ '^[+-]?\\d+$' then nullif(trim(a.\"compartment_id\"::text), '')::integer else null::integer end as compartment_id",
            existing_cols[10]["selected_column"],
        )

    def test_get_existing_cols_applies_alias_to_recipe_overrides(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.dataset = SimpleNamespace(control_id=123, ust_or_release="ust")
        view_sql.table_name = "ust_piping"
        view_sql.required_cols = {}
        view_sql.table_aliases = {"tanks": "a"}
        view_sql.table_alias_fallbacks = {}
        view_sql.warnings = []
        view_sql.mapped_epa_columns = set()

        view_sql.cur = unittest.mock.MagicMock()
        view_sql.cur.fetchall.side_effect = [
            [
                (10, "piping_material_steel", "TankPipingMaterial", '"TankPipingMaterial"::character varying(3) as piping_material_steel', 'WHEN Steel THEN Yes', "tanks"),
            ],
            [],
        ]
        view_sql.cur.fetchone.return_value = ("character varying", 3)
        view_sql._warn = unittest.mock.MagicMock(side_effect=view_sql.warnings.append)

        existing_cols = view_sql.get_existing_cols()

        self.assertIn('a."TankPipingMaterial"', existing_cols[10]["selected_column"])
        self.assertEqual("", existing_cols[10]["query_logic"])

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
            "case when lower(nullif(trim(a.\"FederalFlag\"::text), '')) in ('true', 't', 'yes', 'y', '1', '1.0') then 'Yes'::text when lower(nullif(trim(a.\"FederalFlag\"::text), '')) in ('false', 'f', 'no', 'n', '0', '0.0') then 'No'::text else null::text end as federally_regulated",
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

        self.assertIn('upper(a."site_name") as facility_name', view_sql.select_sql)
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

    def test_build_from_query_infers_id_table_join_from_mapped_keys(self):
        view_sql = ViewSql.__new__(ViewSql)
        view_sql.dataset = SimpleNamespace(schema="sd_ust", control_id=9, ust_or_release="ust")
        view_sql.table_name = "ust_piping"
        view_sql.join_tables = [
            {
                "organization_table_name": "tanks",
                "alias": "a",
                "table_type": "org",
                "organization_join_table": None,
                "organization_join_column": None,
                "organization_join_fk": None,
                "organization_join_column2": None,
                "organization_join_fk2": None,
                "organization_join_column3": None,
                "organization_join_fk3": None,
            },
            {
                "organization_table_name": "erg_piping",
                "alias": "b",
                "table_type": "id",
                "organization_join_table": "tanks",
                "organization_join_column": None,
                "organization_join_fk": None,
                "organization_join_column2": None,
                "organization_join_fk2": None,
                "organization_join_column3": None,
                "organization_join_fk3": None,
            },
        ]
        view_sql.join_info = {}
        view_sql.table_aliases = {}
        view_sql._source_table_columns_cache = {"erg_piping": {"facility_id", "tank_id", "piping_id"}}
        view_sql.cur = unittest.mock.MagicMock()
        view_sql.cur.fetchall.return_value = [
            ("facility_id", "tanks", "FacilityNumber"),
            ("tank_id", "tanks", "TankNumber"),
        ]

        view_sql.build_from_query()

        self.assertIn('from sd_ust."tanks" a', view_sql.from_sql)
        self.assertIn('left join sd_ust."erg_piping" b on', view_sql.from_sql)
        self.assertIn('nullif(trim(a."FacilityNumber"::text), \'\') = b."facility_id"', view_sql.from_sql)
        self.assertIn('nullif(trim(a."TankNumber"::text), \'\')::integer else null::integer end = b."tank_id"', view_sql.from_sql)
        self.assertEqual({"tanks": "a", "erg_piping": "b"}, view_sql.table_aliases)
        self.assertEqual({"a", "b"}, view_sql.used_aliases)

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
        self.assertIn("nullif(trim(a.\"facility_identifier\"::text), '') = unreg_fac.facility_id", view_sql.where_sql)
        self.assertIn(
            "case when nullif(trim(a.\"tank_identifier\"::text), '') ~ '^[+-]?\\d+$' then nullif(trim(a.\"tank_identifier\"::text), '')::integer else null::integer end = unreg_tank.tank_id",
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
