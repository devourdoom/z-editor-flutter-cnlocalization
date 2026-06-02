#!/usr/bin/env python3
"""Report star challenge title/desc coverage in resource_*.json."""

from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT / "lib/data/repository/challenge_repository.dart"


def main() -> None:
    classes = re.findall(r"objClass: '([^']+)'", REPO.read_text(encoding="utf-8"))
    print(f"Repository: {len(classes)} challenges")
    for loc in ("en", "ru", "zh"):
        data = json.loads((ROOT / f"assets/l10n/resource_{loc}.json").read_text(encoding="utf-8"))
        missing_title = [c for c in classes if f"starChallenge_{c}_title" not in data]
        missing_desc = [c for c in classes if f"starChallenge_{c}_desc" not in data]
        en = json.loads((ROOT / "assets/l10n/resource_en.json").read_text(encoding="utf-8"))
        same_as_en = []
        if loc != "en":
            for c in classes:
                tk = f"starChallenge_{c}_title"
                dk = f"starChallenge_{c}_desc"
                if tk in data and data[tk] == en.get(tk):
                    same_as_en.append(f"{c} (title)")
                if dk in data and data[dk] == en.get(dk):
                    same_as_en.append(f"{c} (desc)")
        print(f"{loc}: missing title={missing_title or 'none'}")
        print(f"    missing desc={missing_desc or 'none'}")
        if loc != "en":
            print(f"    untranslated (same as en): {len(same_as_en)}")


if __name__ == "__main__":
    main()
