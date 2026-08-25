import json
import os
from pathlib import Path

from ust.python.util import utils


def _repo_root() -> Path:
    return Path(__file__).resolve().parents[3]


def _store_path() -> Path:
    override = os.getenv("UST_PROFILE_PATH")
    if override:
        return Path(override)
    return _repo_root() / ".ust" / "profiles.json"


def _default_store() -> dict:
    return {"active_profile": None, "profiles": {}}


def load_store() -> dict:
    path = _store_path()
    if not path.exists():
        return _default_store()
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)
    if "profiles" not in data or not isinstance(data["profiles"], dict):
        data["profiles"] = {}
    if "active_profile" not in data:
        data["active_profile"] = None
    return data


def save_store(store: dict) -> None:
    path = _store_path()
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(store, f, indent=2, sort_keys=True)


def normalize_profile_name(name: str) -> str:
    return name.strip().lower()


def suggested_profile_name(organization_id: str, ust_or_release: str) -> str:
    return f"{organization_id.strip().lower()}-{ust_or_release.strip().lower()}"


def set_profile(name: str, ust_or_release: str, organization_id: str, control_id: int, set_active: bool = False) -> str:
    profile_name = normalize_profile_name(name)
    store = load_store()
    store["profiles"][profile_name] = {
        "ust_or_release": ust_or_release,
        "organization_id": organization_id.upper(),
        "control_id": int(control_id),
    }
    if set_active:
        store["active_profile"] = profile_name
    save_store(store)
    return profile_name


def get_profile(name: str) -> dict | None:
    store = load_store()
    return store["profiles"].get(normalize_profile_name(name))


def list_profiles() -> tuple[dict, str | None]:
    store = load_store()
    return store["profiles"], store.get("active_profile")


def use_profile(name: str) -> str:
    profile_name = normalize_profile_name(name)
    store = load_store()
    if profile_name not in store["profiles"]:
        raise ValueError(f"Profile '{profile_name}' does not exist.")
    store["active_profile"] = profile_name
    save_store(store)
    return profile_name


def clear_active_profile() -> None:
    store = load_store()
    store["active_profile"] = None
    save_store(store)


def get_active_profile() -> tuple[str | None, dict | None]:
    store = load_store()
    active_name = store.get("active_profile")
    if not active_name:
        return None, None
    return active_name, store["profiles"].get(active_name)


def sync_profiles_from_db() -> list[str]:
    conn = utils.connect_db()
    cur = conn.cursor()
    created_or_updated: list[str] = []
    try:
        cur.execute(
            """
            select organization_id, max(ust_control_id) as control_id
            from public.ust_control
            group by organization_id
            """
        )
        ust_rows = cur.fetchall()

        cur.execute(
            """
            select organization_id, max(release_control_id) as control_id
            from public.release_control
            group by organization_id
            """
        )
        release_rows = cur.fetchall()
    finally:
        cur.close()
        conn.close()

    store = load_store()

    for organization_id, control_id in ust_rows:
        if not organization_id or control_id is None:
            continue
        name = suggested_profile_name(organization_id, "ust")
        store["profiles"][name] = {
            "ust_or_release": "ust",
            "organization_id": organization_id.upper(),
            "control_id": int(control_id),
        }
        created_or_updated.append(name)

    for organization_id, control_id in release_rows:
        if not organization_id or control_id is None:
            continue
        name = suggested_profile_name(organization_id, "release")
        store["profiles"][name] = {
            "ust_or_release": "release",
            "organization_id": organization_id.upper(),
            "control_id": int(control_id),
        }
        created_or_updated.append(name)

    save_store(store)
    return sorted(set(created_or_updated))
