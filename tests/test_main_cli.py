import unittest
from unittest.mock import patch
import os
import tempfile

import main


class MainCliTests(unittest.TestCase):
    def setUp(self):
        self.tmpdir = tempfile.TemporaryDirectory()
        self.profile_path = os.path.join(self.tmpdir.name, "profiles.json")
        os.environ["UST_PROFILE_PATH"] = self.profile_path

    def tearDown(self):
        os.environ.pop("UST_PROFILE_PATH", None)
        self.tmpdir.cleanup()

    @patch("ust.python.util.validate_repo.main")
    def test_validate_command_dispatches_to_validate_repo(self, validate_main):
        main.main(["validate", "--include-archive", "--skip-tests"])

        validate_main.assert_called_once_with(include_archive=True, run_tests=False)

    @patch("ust.python.state_processing.import_data_from_files.import_files")
    def test_import_files_command_dispatches_expected_arguments(self, import_files):
        main.main([
            "import-files",
            "--type",
            "ust",
            "--organization-id",
            "TX",
            "--path",
            r"C:\\tmp\\input",
            "--overwrite-table",
        ])

        import_files.assert_called_once_with("ust", "TX", r"C:\\tmp\\input", overwrite_table=True)

    @patch("builtins.print")
    @patch("ust.python.state_processing.scaffold_template.main")
    def test_scaffold_template_dispatches_expected_arguments(self, scaffold_main, print_mock):
        scaffold_main.return_value = {
            "output_file": "C:/tmp/MA_UST.sql",
            "control_id": 42,
            "template_file": "C:/tmp/UST.sql",
        }

        main.main([
            "scaffold-template",
            "--type",
            "ust",
            "--organization-id",
            "MA",
            "--control-id",
            "42",
            "--no-control-lookup",
            "--overwrite",
        ])

        scaffold_main.assert_called_once_with(
            ust_or_release="ust",
            organization_id="MA",
            control_id=42,
            lookup_control=False,
            overwrite=True,
        )
        printed = "\n".join(" ".join(str(a) for a in c.args) for c in print_mock.call_args_list)
        self.assertIn("Created template", printed)

    @patch("ust.python.state_processing.scaffold_template.main")
    def test_scaffold_template_uses_active_profile_defaults(self, scaffold_main):
        scaffold_main.return_value = {
            "output_file": "C:/tmp/TX_UST.sql",
            "control_id": 9,
            "template_file": "C:/tmp/UST.sql",
        }

        main.main([
            "profile",
            "set",
            "tx-ust",
            "--type",
            "ust",
            "--organization-id",
            "TX",
            "--control-id",
            "9",
            "--use",
        ])

        main.main([
            "scaffold-template",
            "--yes",
        ])

        scaffold_main.assert_called_once_with(
            ust_or_release="ust",
            organization_id="TX",
            control_id=9,
            lookup_control=True,
            overwrite=False,
        )

    @patch("ust.python.state_processing.export_all_review_materials.main")
    def test_export_review_materials_dispatches_expected_arguments(self, export_review_main):
        main.main([
            "export-review-materials",
            "--type",
            "ust",
            "--control-id",
            "123",
            "--organization-id",
            "TX",
            "--exclude-qa",
            "--refresh-epa-tables",
            "--fast-qa",
            "--skip-peer-review",
            "--yes",
        ])

        export_review_main.assert_called_once_with(
            ust_or_release="ust",
            control_id=123,
            organization_id="TX",
            exclude_qa=True,
            refresh_epa_tables=True,
            perform_peer_review=False,
            qa_include_details=False,
            peer_review_export_view_ddl=False,
        )

    @patch("ust.python.state_processing.qa_check.main")
    def test_qa_fast_dispatches_expected_arguments(self, qa_main):
        main.main([
            "qa",
            "--type",
            "ust",
            "--control-id",
            "123",
            "--organization-id",
            "TX",
            "--force-exclusions",
            "--force-summary-counts",
            "--fast",
            "--materialize-views",
            "--yes",
        ])

        qa_main.assert_called_once_with(
            ust_or_release="ust",
            control_id=123,
            organization_id="TX",
            force_exclusions=True,
            force_summary_counts=True,
            include_details=False,
            materialize_views=True,
        )

    @patch("ust.python.state_processing.populate_unreg_tables.main")
    @patch("ust.python.state_processing.create_unreg_tables.main")
    def test_create_unreg_populate_dispatches_expected_arguments(self, create_unreg_main, populate_unreg_main):
        main.main([
            "create-unreg",
            "--type",
            "ust",
            "--control-id",
            "123",
            "--organization-id",
            "DC",
            "--drop-existing",
            "--populate",
            "--yes",
        ])

        create_unreg_main.assert_called_once_with(
            ust_or_release="ust",
            control_id=123,
            organization_id="DC",
            drop_existing=True,
            views_only=False,
        )
        populate_unreg_main.assert_called_once_with(
            ust_or_release="ust",
            control_id=123,
            organization_id="DC",
            delete_auto_inserts=False,
            delete_all=False,
        )

    @patch("ust.python.state_processing.populate_unreg_tables.main")
    @patch("ust.python.state_processing.create_unreg_tables.main")
    def test_create_unreg_populate_rejects_views_only(self, create_unreg_main, populate_unreg_main):
        with self.assertRaises(SystemExit):
            main.main([
                "create-unreg",
                "--type",
                "ust",
                "--control-id",
                "123",
                "--views-only",
                "--populate",
                "--yes",
            ])

        create_unreg_main.assert_not_called()
        populate_unreg_main.assert_not_called()

    @patch("ust.python.state_processing.create_view_sql.main")
    def test_generate_views_preflight_dispatches_expected_arguments(self, views_main):
        main.main([
            "generate-views",
            "--type",
            "ust",
            "--control-id",
            "123",
            "--table-name",
            "ust_facility",
            "--preflight-only",
            "--strict-mapping",
        ])

        views_main.assert_called_once_with(
            ust_or_release="ust",
            control_id=123,
            table_name="ust_facility",
            overwrite_sql_file=True,
            print_console=False,
            strict=True,
            preflight_only=True,
        )

    @patch("ust.python.state_processing.dataset_audit.main")
    def test_audit_dataset_dispatches_query_logic_fix_flag(self, audit_main):
        main.main([
            "audit-dataset",
            "--type",
            "ust",
            "--control-id",
            "123",
            "--organization-id",
            "TN",
            "--fix-query-logic",
            "--fix-source-identifiers",
            "--yes",
        ])

        audit_main.assert_called_once_with(
            ust_or_release="ust",
            control_id=123,
            organization_id="TN",
            fix_query_logic=True,
            fix_source_identifiers=True,
            write_sql=True,
            print_sql=False,
        )

    @patch("ust.python.state_processing.generate_value_mapping_sql.main")
    def test_generate_value_mapping_dispatches_expected_arguments(self, value_mapping_main):
        main.main([
            "generate-value-mapping",
            "--type",
            "ust",
            "--control-id",
            "123",
            "--all-columns",
            "--append",
        ])

        value_mapping_main.assert_called_once_with(
            ust_or_release="ust",
            control_id=123,
            only_incomplete=False,
            overwrite_existing=False,
        )

    @patch("ust.python.state_processing.exclude_unregulated.main")
    def test_exclude_unregulated_dispatches_expected_arguments(self, exclude_unreg_main):
        main.main([
            "exclude-unregulated",
            "--type",
            "release",
            "--control-id",
            "222",
            "--organization-id",
            "MA",
            "--execute-sql",
            "--no-export-sql",
            "--view-name",
            "v_ust_release",
            "--override-existing-unreg-check",
            "--yes",
        ])

        exclude_unreg_main.assert_called_once_with(
            ust_or_release="release",
            control_id=222,
            organization_id="MA",
            find_regulated=True,
            execute_sql=True,
            export_sql=False,
            print_sql=False,
            view_name="v_ust_release",
            override_existing_unreg_check=True,
        )

    @patch("builtins.print")
    @patch("ust.python.state_processing.qa_check.main")
    def test_qa_dry_run_skips_execution(self, qa_main, print_mock):
        main.main([
            "qa",
            "--type",
            "ust",
            "--control-id",
            "123",
            "--organization-id",
            "TX",
            "--dry-run",
        ])

        qa_main.assert_not_called()
        printed = "\n".join(" ".join(str(a) for a in c.args) for c in print_mock.call_args_list)
        self.assertIn("Dry run only", printed)
        self.assertIn("Planned action", printed)

    @patch("ust.python.state_processing.import_data_from_files.import_files")
    def test_import_files_uses_active_profile_defaults(self, import_files):
        main.main([
            "profile",
            "set",
            "tx-ust",
            "--type",
            "ust",
            "--organization-id",
            "TX",
            "--control-id",
            "9",
            "--use",
        ])

        main.main([
            "import-files",
            "--path",
            r"C:\\tmp\\input",
            "--yes",
        ])

        import_files.assert_called_once_with("ust", "TX", r"C:\\tmp\\input", overwrite_table=False)

    @patch("builtins.print")
    def test_profile_show_prints_active_profile(self, print_mock):
        main.main([
            "profile",
            "set",
            "sd-release",
            "--type",
            "release",
            "--organization-id",
            "SD",
            "--control-id",
            "22",
            "--use",
        ])

        main.main(["profile", "show"])

        printed = "\n".join(" ".join(str(a) for a in c.args) for c in print_mock.call_args_list)
        self.assertIn("Active profile: sd-release", printed)
        self.assertIn("type: release", printed)
        self.assertIn("organization-id: SD", printed)
        self.assertIn("control-id: 22", printed)

    @patch("ust.python.util.cli_profiles.use_profile")
    @patch("ust.python.util.cli_profiles.sync_profiles_from_db")
    def test_profile_sync_db_can_set_active_profile(self, sync_profiles, use_profile):
        sync_profiles.return_value = ["sd-ust", "sd-release"]
        use_profile.return_value = "sd-ust"

        main.main(["profile", "sync-db", "--use", "sd-ust"])

        sync_profiles.assert_called_once_with()
        use_profile.assert_called_once_with("sd-ust")


if __name__ == "__main__":
    unittest.main()
