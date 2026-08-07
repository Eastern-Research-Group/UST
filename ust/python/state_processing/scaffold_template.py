from pathlib import Path

from ust.python.util import utils
from ust.python.util.logger_factory import logger


def _resolve_paths(ust_or_release: str, organization_id: str) -> tuple[Path, Path]:
    project_ust_dir = Path(__file__).resolve().parents[2]
    template_name = "UST.sql" if ust_or_release == "ust" else "releases.sql"
    template_path = project_ust_dir / "sql" / "templates" / template_name

    pretty_type = utils.get_pretty_ust_or_release(ust_or_release)
    state_dir = project_ust_dir / "sql" / "states" / organization_id.upper() / pretty_type
    state_dir.mkdir(parents=True, exist_ok=True)
    state_file_suffix = "UST" if ust_or_release == "ust" else "releases"
    output_path = state_dir / f"{organization_id.upper()}_{state_file_suffix}.sql"
    return template_path, output_path


def _resolve_control_id(ust_or_release: str, organization_id: str, control_id: int | None, lookup_control: bool) -> int | None:
    if control_id:
        return control_id
    if not lookup_control:
        return None
    try:
        return utils.get_control_id(ust_or_release, organization_id)
    except LookupError:
        logger.info(
            "No existing %s control_id found for %s; keeping ZZ placeholder in scaffold.",
            ust_or_release,
            organization_id.upper(),
        )
        return None


def main(
    ust_or_release: str,
    organization_id: str,
    control_id: int | None = None,
    lookup_control: bool = True,
    overwrite: bool = False,
):
    normalized_type = utils.verify_ust_or_release(ust_or_release)
    normalized_org = organization_id.upper()

    template_path, output_path = _resolve_paths(normalized_type, normalized_org)
    if not template_path.exists():
        raise FileNotFoundError(f"Template file not found: {template_path}")
    if output_path.exists() and not overwrite:
        raise FileExistsError(
            f"Target file already exists: {output_path}. Re-run with overwrite=True to replace it."
        )

    resolved_control_id = _resolve_control_id(normalized_type, normalized_org, control_id, lookup_control)

    content = template_path.read_text(encoding="utf-8")
    content = content.replace("XX", normalized_org)
    if resolved_control_id:
        content = content.replace("ZZ", str(resolved_control_id))

    output_path.write_text(content, encoding="utf-8")
    logger.info("Created scaffold template %s from %s", output_path, template_path)

    return {
        "output_file": str(output_path),
        "control_id": resolved_control_id,
        "template_file": str(template_path),
    }


if __name__ == "__main__":
    raise SystemExit("Use via CLI: ust scaffold-template --help")
