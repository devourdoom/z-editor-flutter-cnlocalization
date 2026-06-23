#!/usr/bin/env python3
"""Add stageField_* and resourceGroup_* keys to resource l10n JSON files."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
STAGES_CATALOG = ROOT / "assets/resources/Stages.json"
RESOURCE_FILES = [
    ROOT / "assets/l10n/resource_en.json",
    ROOT / "assets/l10n/resource_zh.json",
    ROOT / "assets/l10n/resource_ru.json",
]

STAGE_FIELD_LABELS_EN = {
    "BasicZombieTypeName": "Basic zombie type",
    "FlagZombieTypeName": "Flag zombie type",
    "Armor1ZombieTypeName": "Armor 1 zombie type",
    "Armor2ZombieTypeName": "Armor 2 zombie type",
    "Armor3ZombieTypeName": "Armor 3 zombie type",
    "ResourceGroupNames": "Resource groups",
    "GroupsToUnloadForAds": "Groups to unload for ads",
    "BackgroundImagePrefix": "Lawn appearance",
    "BackgroundResourceGroup": "Background resource group",
    "MusicSuffix": "Music suffix",
    "AmbientAudioSuffix": "Ambient audio suffix",
    "DisabledStreetCells": "Disabled street cells",
    "LinkedTilePropagationAlpha": "Linked tile propagation alpha",
    "BackgroundImageMiddle": "Background image middle",
    "InitSubmarineInfo": "Submarine info",
    "HasGridItemAirShip": "Grid item airship",
    "HasCannon": "Airship cannon",
    "AutoCannonDamage1": "Auto cannon damage 1",
    "AutoCannonDamage2": "Auto cannon damage 2",
    "AutoCannonDamage3": "Auto cannon damage 3",
    "SkillCannonDamage2": "Skill cannon damage 2",
    "SkillCannonDamage3": "Skill cannon damage 3",
    "AutoFireInterval": "Auto fire interval",
    "SkillFireInterval": "Skill fire interval",
}


def load_json(path: Path) -> dict[str, str]:
    with path.open(encoding="utf-8") as f:
        raw = json.load(f)
    return {str(k): str(v) for k, v in raw.items()}


def save_json(path: Path, data: dict[str, str]) -> None:
    with path.open("w", encoding="utf-8", newline="\n") as f:
        json.dump(dict(sorted(data.items())), f, ensure_ascii=False, indent=2)
        f.write("\n")


def collect_fields() -> set[str]:
    data = json.loads(STAGES_CATALOG.read_text(encoding="utf-8"))
    names: set[str] = set(STAGE_FIELD_LABELS_EN)
    for section in data:
        for field in section.get("fields", []):
            if isinstance(field, dict) and isinstance(field.get("name"), str):
                names.add(field["name"])
    return names


def collect_resource_groups() -> set[str]:
    data = json.loads(STAGES_CATALOG.read_text(encoding="utf-8"))
    groups: set[str] = set()
    for section in data:
        for impl in section.get("implementations", []):
            objdata = impl.get("objdata", {})
            for key in ("ResourceGroupNames", "GroupsToUnloadForAds"):
                for item in objdata.get(key, []) or []:
                    if isinstance(item, str) and item:
                        groups.add(item)
    return groups


def collect_objclasses() -> dict[str, str | None]:
    """Map stage properties objclass -> primary implementation alias (for seed labels)."""
    data = json.loads(STAGES_CATALOG.read_text(encoding="utf-8"))
    result: dict[str, str | None] = {}
    for section in data:
        objclass = section.get("objclass")
        if not isinstance(objclass, str) or not objclass:
            continue
        impls = section.get("implementations") or []
        alias = None
        if impls and isinstance(impls[0], dict):
            raw_alias = impls[0].get("alias")
            if isinstance(raw_alias, str) and raw_alias:
                alias = raw_alias
        result[objclass] = alias
    return result


def objclass_fallback_label(objclass: str) -> str:
    label = objclass
    for suffix in ("StageProperties", "Properties"):
        if label.endswith(suffix):
            label = label[: -len(suffix)]
            break
    return label or objclass


def main() -> None:
    fields = collect_fields()
    groups = collect_resource_groups()
    objclasses = collect_objclasses()
    for path in RESOURCE_FILES:
        data = load_json(path)
        for name in sorted(fields):
            key = f"stageField_{name}"
            data.setdefault(key, STAGE_FIELD_LABELS_EN.get(name, name))
        for group in sorted(groups):
            key = f"resourceGroup_{group}"
            data.setdefault(key, group)
        for objclass in sorted(objclasses):
            key = f"stageObjclass_{objclass}"
            if key in data:
                continue
            alias = objclasses[objclass]
            seed_key = f"stage_{alias}" if alias else None
            if seed_key and seed_key in data:
                data[key] = data[seed_key]
            elif path == RESOURCE_FILES[0]:
                data[key] = objclass_fallback_label(objclass)
            else:
                data[key] = objclass
        save_json(path, data)
    print(
        f"Updated {len(RESOURCE_FILES)} files with {len(fields)} stage fields, "
        f"{len(groups)} resource groups, and {len(objclasses)} stage objclasses."
    )


if __name__ == "__main__":
    main()
