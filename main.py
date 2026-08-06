import argparse
import psycopg2

from ust.python.util import cli_profiles


def _add_common_dataset_args(parser: argparse.ArgumentParser, include_org: bool = False) -> None:
    parser.add_argument("--type", dest="ust_or_release", choices=["ust", "release"])
    parser.add_argument("--control-id", dest="control_id", type=int, default=0)
    if include_org:
        parser.add_argument("--organization-id", dest="organization_id")


def _add_yes_arg(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--yes", action="store_true", help="Skip interactive confirmation prompts")


def _add_dry_run_arg(parser: argparse.ArgumentParser) -> None:
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print resolved values and planned action without executing",
    )


def _apply_profile_defaults(args, required_fields: list[str], parser: argparse.ArgumentParser) -> None:
    active_name, active_profile = cli_profiles.get_active_profile()
    sourced: dict[str, str] = {}

    def maybe_source(field: str, profile_key: str | None = None, empty_value=None):
        key = profile_key or field
        current = getattr(args, field, None)
        if current == empty_value or current is None or current == "":
            if active_profile and active_profile.get(key) not in [None, ""]:
                setattr(args, field, active_profile[key])
                sourced[field] = key

    maybe_source("ust_or_release")
    maybe_source("organization_id")
    maybe_source("control_id", empty_value=0)

    for field in required_fields:
        value = getattr(args, field, None)
        if value in [None, ""] or (field == "control_id" and int(value) == 0):
            parser.error(
                f"{args.command} requires --{field.replace('_', '-')} or an active profile with that value set."
            )

    if sourced and not getattr(args, "yes", False) and not getattr(args, "dry_run", False):
        print("Using active profile defaults:")
        print(f"  profile: {active_name}")
        print(f"  type: {args.ust_or_release}")
        if getattr(args, "organization_id", None):
            print(f"  organization-id: {args.organization_id}")
        if getattr(args, "control_id", 0):
            print(f"  control-id: {args.control_id}")
        response = input("Proceed with these values? [y/N]: ").strip().lower()
        if response not in {"y", "yes"}:
            parser.error("Cancelled by user.")


def _confirm_dangerous_populate(args, parser: argparse.ArgumentParser) -> None:
    if (
        args.command == "populate"
        and args.delete_existing
        and not getattr(args, "yes", False)
        and not getattr(args, "dry_run", False)
    ):
        print("You are about to delete existing EPA table rows before repopulating.")
        print(f"  type: {args.ust_or_release}")
        print(f"  control-id: {args.control_id}")
        if getattr(args, "organization_id", None):
            print(f"  organization-id: {args.organization_id}")
        response = input("Continue with delete-existing? [y/N]: ").strip().lower()
        if response not in {"y", "yes"}:
            parser.error("Cancelled by user.")


def _require_control_or_org(args, parser: argparse.ArgumentParser) -> None:
    if int(getattr(args, "control_id", 0) or 0) == 0 and not getattr(args, "organization_id", None):
        parser.error(f"{args.command} requires --control-id or --organization-id (or an active profile with one of those values).")


def _dry_run(args, action: str) -> bool:
    if not getattr(args, "dry_run", False):
        return False

    print("Dry run only; no database or filesystem changes will be made.")
    print(f"Planned action: {action}")
    print("Resolved arguments:")
    excluded = {"command", "yes", "dry_run", "profile_command", "use_profile_name"}
    for key, value in vars(args).items():
        if key in excluded:
            continue
        print(f"  {key}: {value}")
    return True


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="UST processing helper CLI")
    subparsers = parser.add_subparsers(dest="command", required=True)

    import_files = subparsers.add_parser("import-files", help="Import source files into <org>_<type> schema")
    import_files.add_argument("--type", dest="ust_or_release", choices=["ust", "release"])
    import_files.add_argument("--organization-id", dest="organization_id")
    import_files.add_argument("--path", dest="path", required=True)
    import_files.add_argument("--overwrite-table", action="store_true")
    _add_yes_arg(import_files)
    _add_dry_run_arg(import_files)

    init_dataset = subparsers.add_parser("init-dataset", help="Insert control row and create unregulated tables/views")
    init_dataset.add_argument("--type", dest="ust_or_release", choices=["ust", "release"])
    init_dataset.add_argument("--organization-id", dest="organization_id")
    init_dataset.add_argument("--data-source", dest="data_source", required=True)
    init_dataset.add_argument("--date-received", dest="date_received")
    init_dataset.add_argument("--date-processed", dest="date_processed")
    init_dataset.add_argument("--comments", dest="comments")
    init_dataset.add_argument("--organization-compartment-flag", dest="organization_compartment_flag")
    _add_yes_arg(init_dataset)
    _add_dry_run_arg(init_dataset)

    scaffold_template = subparsers.add_parser(
        "scaffold-template",
        help="Create a state SQL template from UST/Releases template and replace XX/ZZ placeholders",
    )
    scaffold_template.add_argument("--type", dest="ust_or_release", choices=["ust", "release"])
    scaffold_template.add_argument("--organization-id", dest="organization_id")
    scaffold_template.add_argument("--control-id", dest="control_id", type=int)
    scaffold_template.add_argument(
        "--no-control-lookup",
        dest="lookup_control",
        action="store_false",
        help="Do not look up the latest control_id when --control-id is not provided",
    )
    scaffold_template.add_argument(
        "--overwrite",
        action="store_true",
        help="Overwrite existing scaffold file if it already exists",
    )
    _add_yes_arg(scaffold_template)
    _add_dry_run_arg(scaffold_template)

    create_unreg = subparsers.add_parser("create-unreg", help="Create/recreate unregulated tables and mapping views")
    _add_common_dataset_args(create_unreg, include_org=True)
    create_unreg.add_argument("--drop-existing", action="store_true")
    create_unreg.add_argument("--views-only", action="store_true")
    _add_yes_arg(create_unreg)
    _add_dry_run_arg(create_unreg)

    generate_views = subparsers.add_parser("generate-views", help="Generate view creation SQL for one/all EPA tables")
    _add_common_dataset_args(generate_views)
    generate_views.add_argument("--table-name", dest="table_name")
    generate_views.add_argument("--append", dest="overwrite_sql_file", action="store_false")
    generate_views.add_argument("--print-console", action="store_true")
    generate_views.add_argument(
        "--preflight-only",
        action="store_true",
        help="Audit mapping/join readiness and print report without generating SQL",
    )
    generate_views.add_argument(
        "--strict-mapping",
        action="store_true",
        help="Treat critical preflight issues as errors",
    )
    _add_yes_arg(generate_views)
    _add_dry_run_arg(generate_views)

    generate_deagg = subparsers.add_parser("generate-deagg", help="Generate SQL guidance for potential deaggregation")
    _add_common_dataset_args(generate_deagg)
    generate_deagg.add_argument(
        "--all-columns",
        dest="only_incomplete",
        action="store_false",
        help="Include columns that already have value mappings",
    )
    _add_yes_arg(generate_deagg)
    _add_dry_run_arg(generate_deagg)

    generate_value_mapping = subparsers.add_parser(
        "generate-value-mapping",
        help="Generate SQL scaffold for mapping organization values to EPA lookup values",
    )
    _add_common_dataset_args(generate_value_mapping)
    generate_value_mapping.add_argument(
        "--all-columns",
        dest="only_incomplete",
        action="store_false",
        help="Include columns that already have value mappings",
    )
    generate_value_mapping.add_argument(
        "--append",
        dest="overwrite_existing",
        action="store_false",
        help="Append to existing generated SQL file instead of overwriting",
    )
    _add_yes_arg(generate_value_mapping)
    _add_dry_run_arg(generate_value_mapping)

    export_substance_mapping = subparsers.add_parser(
        "export-substance-mapping",
        help="Export substance mapping workbook and optionally email it for review",
    )
    _add_common_dataset_args(export_substance_mapping)
    export_substance_mapping.add_argument(
        "--no-email",
        dest="send_email",
        action="store_false",
        help="Skip automatic Outlook email",
    )
    _add_yes_arg(export_substance_mapping)
    _add_dry_run_arg(export_substance_mapping)

    mapping_xwalks = subparsers.add_parser(
        "mapping-xwalks",
        help="Create value mapping crosswalk views in the state schema",
    )
    _add_common_dataset_args(mapping_xwalks)
    _add_yes_arg(mapping_xwalks)
    _add_dry_run_arg(mapping_xwalks)

    create_missing_ids = subparsers.add_parser(
        "create-missing-ids",
        help="Create ERG ID tables for missing required identifier fields",
    )
    _add_common_dataset_args(create_missing_ids)
    create_missing_ids.add_argument("--table-name", dest="table_name")
    create_missing_ids.add_argument("--drop-existing", action="store_true")
    create_missing_ids.add_argument(
        "--no-write-sql",
        dest="write_sql",
        action="store_false",
        help="Skip exporting the SQL audit script",
    )
    create_missing_ids.add_argument(
        "--overwrite-sql-file",
        action="store_true",
        help="Overwrite the generated SQL file instead of appending",
    )
    _add_yes_arg(create_missing_ids)
    _add_dry_run_arg(create_missing_ids)

    populate_unreg = subparsers.add_parser(
        "populate-unreg",
        help="Populate unregulated facility/tank/substance tables from mappings",
    )
    _add_common_dataset_args(populate_unreg, include_org=True)
    populate_unreg.add_argument("--delete-auto-inserts", action="store_true")
    populate_unreg.add_argument("--delete-all", action="store_true")
    _add_yes_arg(populate_unreg)
    _add_dry_run_arg(populate_unreg)

    exclude_unreg = subparsers.add_parser(
        "exclude-unregulated",
        help="Generate and optionally execute SQL to exclude unregulated rows from state views",
    )
    _add_common_dataset_args(exclude_unreg, include_org=True)
    exclude_unreg.add_argument(
        "--skip-find-regulated",
        dest="find_regulated",
        action="store_false",
        help="Skip creating/checking unregulated tables before generating SQL",
    )
    exclude_unreg.add_argument(
        "--execute-sql",
        action="store_true",
        help="Execute generated view SQL in the database",
    )
    exclude_unreg.add_argument(
        "--no-export-sql",
        dest="export_sql",
        action="store_false",
        help="Do not export generated SQL to file",
    )
    exclude_unreg.add_argument("--print-sql", action="store_true")
    exclude_unreg.add_argument("--view-name", dest="view_name")
    exclude_unreg.add_argument("--override-existing-unreg-check", action="store_true")
    _add_yes_arg(exclude_unreg)
    _add_dry_run_arg(exclude_unreg)

    export_control_summary = subparsers.add_parser(
        "export-control-summary",
        help="Export control table summary workbook",
    )
    _add_common_dataset_args(export_control_summary, include_org=True)
    _add_yes_arg(export_control_summary)
    _add_dry_run_arg(export_control_summary)

    export_source_data = subparsers.add_parser(
        "export-source-data",
        help="Export source schema tables to CSV",
    )
    _add_common_dataset_args(export_source_data)
    export_source_data.add_argument(
        "--used-tables-only",
        dest="all_tables",
        action="store_false",
        help="Only export source tables referenced by element mapping",
    )
    export_source_data.add_argument(
        "--exclude-table",
        dest="tables_to_exclude",
        action="append",
        default=[],
        help="Table name to exclude from export (repeatable)",
    )
    export_source_data.add_argument(
        "--keep-existing-files",
        dest="empty_export_dir",
        action="store_false",
        help="Do not clear existing files in export directory",
    )
    _add_yes_arg(export_source_data)
    _add_dry_run_arg(export_source_data)

    qa = subparsers.add_parser("qa", help="Run QA checks and export QA workbook")
    _add_common_dataset_args(qa, include_org=True)
    qa.add_argument("--force-exclusions", action="store_true")
    qa.add_argument("--force-summary-counts", action="store_true")
    qa.add_argument(
        "--fast",
        dest="include_details",
        action="store_false",
        help="Skip detail worksheets and run QA in counts-only mode",
    )
    _add_yes_arg(qa)
    _add_dry_run_arg(qa)

    populate = subparsers.add_parser("populate", help="Insert data from state views into public EPA tables")
    _add_common_dataset_args(populate, include_org=True)
    populate.add_argument("--delete-existing", action="store_true")
    _add_yes_arg(populate)
    _add_dry_run_arg(populate)

    export_template = subparsers.add_parser("export-template", help="Export populated EPA template workbook")
    _add_common_dataset_args(export_template)
    export_template.add_argument("--data-only", action="store_true")
    export_template.add_argument("--template-only", action="store_true")
    _add_yes_arg(export_template)
    _add_dry_run_arg(export_template)

    export_review_materials = subparsers.add_parser(
        "export-review-materials",
        help="Export control summary, QA workbook, template workbook, and peer review SQL",
    )
    _add_common_dataset_args(export_review_materials, include_org=True)
    export_review_materials.add_argument("--exclude-qa", action="store_true")
    export_review_materials.add_argument("--refresh-epa-tables", action="store_true")
    export_review_materials.add_argument(
        "--fast-qa",
        dest="qa_include_details",
        action="store_false",
        help="Run QA in counts-only mode when exporting review materials",
    )
    export_review_materials.add_argument(
        "--skip-peer-review",
        dest="perform_peer_review",
        action="store_false",
        help="Skip generating peer review SQL",
    )
    export_review_materials.add_argument(
        "--peer-review-view-ddl",
        dest="peer_review_export_view_ddl",
        action="store_true",
        help="Also export view DDL during peer review",
    )
    _add_yes_arg(export_review_materials)
    _add_dry_run_arg(export_review_materials)

    review = subparsers.add_parser("review", help="Run peer review row-count checks and emit mismatch SQL")
    _add_common_dataset_args(review, include_org=True)
    review.add_argument("--display-bad-data", action="store_true")
    review.add_argument("--overwrite-existing", action="store_true")
    review.add_argument("--skip-view-ddl", dest="export_view_ddl", action="store_false")
    _add_yes_arg(review)
    _add_dry_run_arg(review)

    profile = subparsers.add_parser("profile", help="Manage saved CLI profiles")
    profile_subparsers = profile.add_subparsers(dest="profile_command", required=True)

    profile_set = profile_subparsers.add_parser("set", help="Create or update a named profile")
    profile_set.add_argument("name")
    profile_set.add_argument("--type", dest="ust_or_release", choices=["ust", "release"], required=True)
    profile_set.add_argument("--organization-id", dest="organization_id", required=True)
    profile_set.add_argument("--control-id", dest="control_id", type=int, required=True)
    profile_set.add_argument("--use", action="store_true", help="Set this profile as active")

    profile_use = profile_subparsers.add_parser("use", help="Set active profile")
    profile_use.add_argument("name")

    profile_subparsers.add_parser("show", help="Show active profile")
    profile_subparsers.add_parser("list", help="List saved profiles")
    profile_subparsers.add_parser("clear", help="Clear active profile")
    profile_sync_db = profile_subparsers.add_parser(
        "sync-db",
        help="Create/update profiles from control tables (most recent control IDs)",
    )
    profile_sync_db.add_argument(
        "--use",
        dest="use_profile_name",
        metavar="PROFILE",
        help="After syncing, set PROFILE as the active profile",
    )

    validate = subparsers.add_parser("validate", help="Run non-archive compile, import, and test validation checks")
    validate.add_argument("--include-archive", action="store_true")
    validate.add_argument("--skip-tests", dest="run_tests", action="store_false")

    return parser


def _main(argv=None):
    parser = build_parser()
    args = parser.parse_args(argv)

    if args.command == "profile":
        if args.profile_command == "set":
            name = cli_profiles.set_profile(
                name=args.name,
                ust_or_release=args.ust_or_release,
                organization_id=args.organization_id,
                control_id=args.control_id,
                set_active=args.use,
            )
            if args.use:
                print(f"Saved profile '{name}' and set it active.")
            else:
                print(f"Saved profile '{name}'.")
            return

        if args.profile_command == "use":
            name = cli_profiles.use_profile(args.name)
            print(f"Active profile set to '{name}'.")
            return

        if args.profile_command == "show":
            active_name, active_profile = cli_profiles.get_active_profile()
            if not active_profile:
                print("No active profile set.")
                return
            print(f"Active profile: {active_name}")
            print(f"  type: {active_profile['ust_or_release']}")
            print(f"  organization-id: {active_profile['organization_id']}")
            print(f"  control-id: {active_profile['control_id']}")
            return

        if args.profile_command == "list":
            profiles, active_name = cli_profiles.list_profiles()
            if not profiles:
                print("No profiles saved.")
                return
            for name, profile in sorted(profiles.items()):
                marker = "*" if name == active_name else " "
                print(
                    f"{marker} {name}: type={profile['ust_or_release']}, "
                    f"organization-id={profile['organization_id']}, control-id={profile['control_id']}"
                )
            return

        if args.profile_command == "clear":
            cli_profiles.clear_active_profile()
            print("Cleared active profile.")
            return

        if args.profile_command == "sync-db":
            names = cli_profiles.sync_profiles_from_db()
            print(f"Created/updated {len(names)} profiles from control tables.")
            for name in names:
                print(f"  {name}")
            if args.use_profile_name:
                try:
                    active_name = cli_profiles.use_profile(args.use_profile_name)
                except ValueError as exc:
                    parser.error(str(exc))
                print(f"Active profile set to '{active_name}'.")
            return

    if args.command == "import-files":
        _apply_profile_defaults(args, required_fields=["ust_or_release", "organization_id"], parser=parser)
        if _dry_run(args, "Import files into organization schema"):
            return
        from ust.python.state_processing.import_data_from_files import import_files
        import_files(args.ust_or_release, args.organization_id, args.path, overwrite_table=args.overwrite_table)
        return

    if args.command == "init-dataset":
        _apply_profile_defaults(args, required_fields=["ust_or_release", "organization_id"], parser=parser)
        if _dry_run(args, "Insert control row and initialize unregulated tables"):
            return
        from ust.python.state_processing.dataset_initialize import main as init_main
        created_control_id = init_main(
            ust_or_release=args.ust_or_release,
            organization_id=args.organization_id,
            data_source=args.data_source,
            date_received=args.date_received,
            date_processed=args.date_processed,
            comments=args.comments,
            organization_compartment_flag=args.organization_compartment_flag,
        )
        profile_name = cli_profiles.suggested_profile_name(args.organization_id, args.ust_or_release)
        cli_profiles.set_profile(
            name=profile_name,
            ust_or_release=args.ust_or_release,
            organization_id=args.organization_id,
            control_id=created_control_id,
            set_active=True,
        )
        print(
            f"Saved and activated profile '{profile_name}' "
            f"(type={args.ust_or_release}, organization-id={args.organization_id.upper()}, control-id={created_control_id})."
        )
        return

    if args.command == "scaffold-template":
        _apply_profile_defaults(args, required_fields=["ust_or_release", "organization_id"], parser=parser)
        if _dry_run(args, "Create state SQL template scaffold"):
            return
        from ust.python.state_processing.scaffold_template import main as scaffold_template_main
        result = scaffold_template_main(
            ust_or_release=args.ust_or_release,
            organization_id=args.organization_id,
            control_id=args.control_id,
            lookup_control=args.lookup_control,
            overwrite=args.overwrite,
        )
        print(f"Created template: {result['output_file']}")
        if result.get("control_id"):
            print(f"Applied control-id replacement ZZ -> {result['control_id']}")
        else:
            print("Control-id placeholder ZZ retained (no control-id provided/found).")
        return

    if args.command == "create-unreg":
        _apply_profile_defaults(args, required_fields=["ust_or_release"], parser=parser)
        _require_control_or_org(args, parser)
        if _dry_run(args, "Create or refresh unregulated tables/views"):
            return
        from ust.python.state_processing.create_unreg_tables import main as unreg_main
        unreg_main(
            ust_or_release=args.ust_or_release,
            control_id=args.control_id,
            organization_id=args.organization_id,
            drop_existing=args.drop_existing,
            views_only=args.views_only,
        )
        return

    if args.command == "generate-views":
        _apply_profile_defaults(args, required_fields=["ust_or_release", "control_id"], parser=parser)
        action = "Run view SQL preflight audit" if args.preflight_only else "Generate EPA view SQL from mapping"
        if _dry_run(args, action):
            return
        from ust.python.state_processing.create_view_sql import main as views_main
        views_main(
            ust_or_release=args.ust_or_release,
            control_id=args.control_id,
            table_name=args.table_name,
            overwrite_sql_file=args.overwrite_sql_file,
            print_console=args.print_console,
            strict=args.strict_mapping,
            preflight_only=args.preflight_only,
        )
        return

    if args.command == "generate-deagg":
        _apply_profile_defaults(args, required_fields=["ust_or_release", "control_id"], parser=parser)
        if _dry_run(args, "Generate SQL guidance for deaggregating source values"):
            return
        from ust.python.state_processing.generate_deagg_code import main as deagg_main
        deagg_main(
            ust_or_release=args.ust_or_release,
            control_id=args.control_id,
            only_incomplete=args.only_incomplete,
        )
        return

    if args.command == "generate-value-mapping":
        _apply_profile_defaults(args, required_fields=["ust_or_release", "control_id"], parser=parser)
        if _dry_run(args, "Generate SQL scaffold for value mapping"):
            return
        from ust.python.state_processing.generate_value_mapping_sql import main as value_mapping_main
        value_mapping_main(
            ust_or_release=args.ust_or_release,
            control_id=args.control_id,
            only_incomplete=args.only_incomplete,
            overwrite_existing=args.overwrite_existing,
        )
        return

    if args.command == "export-substance-mapping":
        _apply_profile_defaults(args, required_fields=["ust_or_release", "control_id"], parser=parser)
        if _dry_run(args, "Export substance mapping workbook"):
            return
        from ust.python.state_processing.export_substance_mapping import main as substance_mapping_main
        substance_mapping_main(
            ust_or_release=args.ust_or_release,
            control_id=args.control_id,
            send_email=args.send_email,
        )
        return

    if args.command == "mapping-xwalks":
        _apply_profile_defaults(args, required_fields=["ust_or_release", "control_id"], parser=parser)
        if _dry_run(args, "Create mapping crosswalk views"):
            return
        from ust.python.state_processing.org_mapping_xwalks import main as xwalks_main
        xwalks_main(
            ust_or_release=args.ust_or_release,
            control_id=args.control_id,
        )
        return

    if args.command == "create-missing-ids":
        _apply_profile_defaults(args, required_fields=["ust_or_release", "control_id"], parser=parser)
        if _dry_run(args, "Create missing required ID tables"):
            return
        from ust.python.state_processing.create_missing_id_columns import main as missing_ids_main
        missing_ids_main(
            ust_or_release=args.ust_or_release,
            control_id=args.control_id,
            table_name=args.table_name,
            drop_existing=args.drop_existing,
            write_sql=args.write_sql,
            overwrite_sql_file=args.overwrite_sql_file,
        )
        return

    if args.command == "populate-unreg":
        _apply_profile_defaults(args, required_fields=["ust_or_release"], parser=parser)
        _require_control_or_org(args, parser)
        if _dry_run(args, "Populate unregulated tables from mapped data"):
            return
        from ust.python.state_processing.populate_unreg_tables import main as populate_unreg_main
        populate_unreg_main(
            ust_or_release=args.ust_or_release,
            control_id=args.control_id,
            organization_id=args.organization_id,
            delete_auto_inserts=args.delete_auto_inserts,
            delete_all=args.delete_all,
        )
        return

    if args.command == "exclude-unregulated":
        _apply_profile_defaults(args, required_fields=["ust_or_release"], parser=parser)
        _require_control_or_org(args, parser)
        if _dry_run(args, "Generate SQL to exclude unregulated rows from views"):
            return
        from ust.python.state_processing.exclude_unregulated import main as exclude_unreg_main
        exclude_unreg_main(
            ust_or_release=args.ust_or_release,
            control_id=args.control_id,
            organization_id=args.organization_id,
            find_regulated=args.find_regulated,
            execute_sql=args.execute_sql,
            export_sql=args.export_sql,
            print_sql=args.print_sql,
            view_name=args.view_name,
            override_existing_unreg_check=args.override_existing_unreg_check,
        )
        return

    if args.command == "export-control-summary":
        _apply_profile_defaults(args, required_fields=["ust_or_release"], parser=parser)
        _require_control_or_org(args, parser)
        if _dry_run(args, "Export control table summary workbook"):
            return
        from ust.python.state_processing.control_table_summary import main as control_summary_main
        control_summary_main(
            ust_or_release=args.ust_or_release,
            organization_id=args.organization_id,
            control_id=args.control_id,
        )
        return

    if args.command == "export-source-data":
        _apply_profile_defaults(args, required_fields=["ust_or_release", "control_id"], parser=parser)
        if _dry_run(args, "Export source schema tables to CSV"):
            return
        from ust.python.state_processing.export_source_data import main as export_source_main
        export_source_main(
            ust_or_release=args.ust_or_release,
            control_id=args.control_id,
            all_tables=args.all_tables,
            tables_to_exclude=args.tables_to_exclude,
            empty_export_dir=args.empty_export_dir,
        )
        return

    if args.command == "qa":
        _apply_profile_defaults(args, required_fields=["ust_or_release"], parser=parser)
        _require_control_or_org(args, parser)
        if _dry_run(args, "Run QA checks and export QA workbook"):
            return
        from ust.python.state_processing.qa_check import main as qa_main
        qa_main(
            ust_or_release=args.ust_or_release,
            control_id=args.control_id,
            organization_id=args.organization_id,
            force_exclusions=args.force_exclusions,
            force_summary_counts=args.force_summary_counts,
            include_details=args.include_details,
        )
        return

    if args.command == "populate":
        _apply_profile_defaults(args, required_fields=["ust_or_release"], parser=parser)
        _require_control_or_org(args, parser)
        _confirm_dangerous_populate(args, parser)
        if _dry_run(args, "Populate EPA tables from state views"):
            return
        from ust.python.state_processing.populate_epa_data_tables import main as populate_main
        populate_main(
            ust_or_release=args.ust_or_release,
            control_id=args.control_id,
            organization_id=args.organization_id,
            delete_existing=args.delete_existing,
        )
        return

    if args.command == "export-template":
        _apply_profile_defaults(args, required_fields=["ust_or_release", "control_id"], parser=parser)
        if _dry_run(args, "Export populated EPA template workbook"):
            return
        from ust.python.state_processing.export_template import main as export_main
        export_main(
            ust_or_release=args.ust_or_release,
            control_id=args.control_id,
            data_only=args.data_only,
            template_only=args.template_only,
        )
        return

    if args.command == "export-review-materials":
        _apply_profile_defaults(args, required_fields=["ust_or_release"], parser=parser)
        _require_control_or_org(args, parser)
        if _dry_run(args, "Export control summary, QA workbook, template workbook, and peer review SQL"):
            return
        from ust.python.state_processing.export_all_review_materials import main as export_all_review_main
        export_all_review_main(
            ust_or_release=args.ust_or_release,
            control_id=args.control_id,
            organization_id=args.organization_id,
            exclude_qa=args.exclude_qa,
            refresh_epa_tables=args.refresh_epa_tables,
            perform_peer_review=args.perform_peer_review,
            qa_include_details=args.qa_include_details,
            peer_review_export_view_ddl=args.peer_review_export_view_ddl,
        )
        return

    if args.command == "review":
        _apply_profile_defaults(args, required_fields=["ust_or_release"], parser=parser)
        _require_control_or_org(args, parser)
        if _dry_run(args, "Run peer review row-count checks and generate mismatch SQL"):
            return
        from ust.python.util.peer_review import main as review_main
        review_main(
            ust_or_release=args.ust_or_release,
            control_id=args.control_id,
            organization_id=args.organization_id,
            display_bad_data=args.display_bad_data,
            overwrite_existing=args.overwrite_existing,
            export_view_ddl=args.export_view_ddl,
        )
        return

    if args.command == "validate":
        from ust.python.util.validate_repo import main as validate_main
        validate_main(include_archive=args.include_archive, run_tests=args.run_tests)
        return

    parser.error(f"Unknown command: {args.command}")


def main(argv=None):
    try:
        return _main(argv)
    except psycopg2.OperationalError as exc:
        print(f"Database connection failed: {exc}")
        print("Check network/VPN access and database host availability, then retry.")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
