#!/usr/bin/env python3
"""Merge star challenge + zombie condition keys into resource_*.json."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONDITIONS_PATH = ROOT / "conditions.txt"
RESOURCE_DIR = ROOT / "assets/l10n"

# objClass -> locale -> (title, description)
CHALLENGES: dict[str, dict[str, tuple[str, str]]] = {
    "StarChallengeBeatTheLevelProps": {
        "en": ("Level hint text", "Show hint text popup at level start"),
        "ru": ("Подсказка уровня", "Показать всплывающую подсказку в начале уровня"),
        "zh": ("关卡提示文字", "在关卡开始时显示提示弹窗"),
    },
    "StarChallengeSaveMowersProps": {
        "en": ("Don't lose mowers", "Do not lose lawn mowers"),
        "ru": ("Не потерять газонокосилки", "Все газонокосилки должны остаться целыми"),
        "zh": ("不损失小推车", "不能损失任何小推车"),
    },
    "StarChallengePlantFoodNonuseProps": {
        "en": ("Don't use plant food", "Do not use plant food"),
        "ru": ("Не использовать растительный корм", "Запрещено использовать растительный корм"),
        "zh": ("不使用植物食物", "不能使用植物食物"),
    },
    "StarChallengePlantsSurviveProps": {
        "en": ("Plants survive", "Specified plants must survive"),
        "ru": ("Растения должны выжить", "Указанные растения должны остаться живыми"),
        "zh": ("植物存活", "指定植物必须存活"),
    },
    "StarChallengeZombieDistanceProps": {
        "en": ("Zombie distance", "Zombies must not step on flowers"),
        "ru": ("Дистанция зомби", "Зомби не должны наступать на цветы"),
        "zh": ("僵尸距离", "僵尸不能踩到花朵"),
    },
    "StarChallengeSunProducedProps": {
        "en": ("Sun produced", "Produce a certain amount of sun"),
        "ru": ("Собрать солнце", "Произвести определённое количество солнца"),
        "zh": ("生产阳光", "生产一定数量的阳光"),
    },
    "StarChallengeSunUsedProps": {
        "en": ("Sun used", "Limit sun usage"),
        "ru": ("Ограничение солнца", "Ограничить расход солнца"),
        "zh": ("阳光使用", "限制阳光使用量"),
    },
    "StarChallengeSpendSunHoldoutProps": {
        "en": ("Spend sun holdout", "Survive while spending sun"),
        "ru": ("Удержание солнца", "Выжить, тратя солнце"),
        "zh": ("阳光消耗坚守", "在消耗阳光的情况下坚守"),
    },
    "StarChallengeKillZombiesInTimeProps": {
        "en": ("Kill zombies in time", "Kill X zombies within Y seconds"),
        "ru": ("Убить зомби вовремя", "Убить X зомби за Y секунд"),
        "zh": ("限时击杀僵尸", "在 Y 秒内击杀 X 个僵尸"),
    },
    "StarChallengeZombieSpeedProps": {
        "en": ("Zombie speed", "Increase zombie speed"),
        "ru": ("Скорость зомби", "Увеличить скорость зомби"),
        "zh": ("僵尸速度", "提高僵尸移动速度"),
    },
    "StarChallengeSunReducedProps": {
        "en": ("Sun reduced", "Sun decays over time"),
        "ru": ("Уменьшение солнца", "Солнце со временем уменьшается"),
        "zh": ("阳光衰减", "阳光会随时间减少"),
    },
    "StarChallengePlantsLostProps": {
        "en": ("Plants lost", "Do not lose more than X plants"),
        "ru": ("Потеря растений", "Не потерять больше X растений"),
        "zh": ("植物损失", "损失植物不超过 X 株"),
    },
    "StarChallengeSimultaneousPlantsProps": {
        "en": ("Simultaneous plants", "Limit plants on field"),
        "ru": ("Лимит растений", "Ограничить число растений на поле"),
        "zh": ("同时植物数量", "限制场上植物数量"),
    },
    "StarChallengeUnfreezePlantsProps": {
        "en": ("Unfreeze plants", "Unfreeze X plants"),
        "ru": ("Разморозить растения", "Разморозить X растений"),
        "zh": ("解冻植物", "解冻 X 株植物"),
    },
    "StarChallengeBlowZombieProps": {
        "en": ("Blow zombie", "Blow away X zombies"),
        "ru": ("Сдуть зомби", "Сдуть X зомби"),
        "zh": ("吹飞僵尸", "吹飞 X 个僵尸"),
    },
    "StarChallengeTargetScoreProps": {
        "en": ("Target score", "Reach target score"),
        "ru": ("Целевой счёт", "Достичь целевого счёта"),
        "zh": ("目标分数", "达到目标分数"),
    },
    "ApplyZombieConditionsChallengeProps": {
        "en": ("Apply zombie conditions", "Inflict status effects on zombies"),
        "ru": ("Наложить состояния", "Наложить на зомби негативные эффекты"),
        "zh": ("施加僵尸状态", "对僵尸施加负面状态效果"),
    },
    "PlantDefeatZombieChallengeProps": {
        "en": ("Defeat with plant", "Kill zombies using a specific plant"),
        "ru": ("Победа растением", "Убить зомби определённым растением"),
        "zh": ("植物击杀", "使用指定植物击杀僵尸"),
    },
    "DefeatZombiesOfTypeChallengeProps": {
        "en": ("Defeat zombies of type", "Kill zombies from a whitelist or blacklist"),
        "ru": ("Убить зомби по типу", "Убить зомби из белого или чёрного списка"),
        "zh": ("击杀指定类型僵尸", "击杀白名单或黑名单中的僵尸"),
    },
    "DestroyGridItemsChallengeProps": {
        "en": ("Destroy grid items", "Destroy obstacles such as gravestones"),
        "ru": ("Уничтожить объекты сетки", "Уничтожить препятствия, например надгробия"),
        "zh": ("破坏场地障碍", "破坏墓碑等场地障碍"),
    },
    "StarChallengeDisablePlantProps": {
        "en": ("Disable plant profession", "Disable a plant profession category"),
        "ru": ("Отключить профессию", "Отключить категорию растений по профессии"),
        "zh": ("禁用植物职业", "禁用某一职业类别的植物"),
    },
    "StarChallengeSandstormZombieKillProps": {
        "en": ("Sandstorm zombie kills", "Kill zombies spawned from sandstorms"),
        "ru": ("Убийства из песчаной бури", "Убить зомби, вызванных песчаной бурей"),
        "zh": ("沙尘暴击杀", "击杀沙尘暴出现的僵尸"),
    },
    "StarChallengeTentZombieKillProps": {
        "en": ("Tent zombie kills", "Kill zombies from tents"),
        "ru": ("Убийства из палаток", "Убить зомби из палаток"),
        "zh": ("帐篷击杀", "击杀帐篷中出现的僵尸"),
    },
    "StarChallengeBufferTileZombieKillProps": {
        "en": ("Buff tile zombie kills", "Kill zombies empowered by Zomboss tiles"),
        "ru": ("Убийства с усиления плит", "Убить зомби, усиленных плитами Зомбосса"),
        "zh": ("增益瓷砖击杀", "击杀僵王瓷砖增益的僵尸"),
    },
    "StarChallengePotionZombieKillProps": {
        "en": ("Potion zombie kills", "Kill zombies empowered by potions"),
        "ru": ("Убийства с зельями", "Убить зомби, усиленных зельями"),
        "zh": ("药水僵尸击杀", "击杀被药水强化的僵尸"),
    },
    "StarChallengeBarrelPowderZombieKillProps": {
        "en": ("Barrel powder kills", "Kill zombies with explosive barrels"),
        "ru": ("Убийства пороховыми бочками", "Убить зомби взрывными бочками"),
        "zh": ("火药桶击杀", "用火药桶击杀僵尸"),
    },
    "StarChallengeBlowBarrelZombieProps": {
        "en": ("Blow barrel zombies", "Blow away zombies from rolling barrels"),
        "ru": ("Сдуть бочковых зомби", "Сдуть зомби с катящихся бочек"),
        "zh": ("吹飞滚桶僵尸", "吹飞滚桶中的僵尸"),
    },
    "StarChallengeFirecrackerZombieKillProps": {
        "en": ("Firecracker kills", "Kill zombies with firecrackers"),
        "ru": ("Убийства хлопушками", "Убить зомби хлопушками"),
        "zh": ("鞭炮击杀", "用鞭炮击杀僵尸"),
    },
    "StarChallengeFireworksZombieKillProps": {
        "en": ("Fireworks kills", "Kill zombies with fireworks"),
        "ru": ("Убийства фейерверками", "Убить зомби фейерверками"),
        "zh": ("烟花击杀", "用烟花击杀僵尸"),
    },
    "ZombiePerfumerChallengeProps": {
        "en": ("Clean poison mist", "Clear Perfumer Zombie poison mist"),
        "ru": ("Рассеять ядовитый туман", "Убрать ядовитый туман Зомби-Парфюмера"),
        "zh": ("清除毒雾", "清除调香师僵尸的毒雾"),
    },
    "BalletSlipChallengeProps": {
        "en": ("Ballet slip", "Trip Ballet Zombie with olive oil"),
        "ru": ("Подставить балерину", "Подставить Балерину-Зомби оливковым маслом"),
        "zh": ("滑倒芭蕾僵尸", "用橄榄油使芭蕾僵尸滑倒"),
    },
    "ZombieExplodenutChallengeProps": {
        "en": ("Explode-o-nut limit", "Do not let Explode-o-nut Zombies explode too many times"),
        "ru": ("Лимит взрывов ореха", "Не допустить слишком много взрывов Зомби-Взрывоореха"),
        "zh": ("爆炸坚果限制", "限制爆炸坚果僵尸的爆炸次数"),
    },
    "ZombieJalapenoChallengeProps": {
        "en": ("Jalapeno zombie limit", "Do not let Jalapeno Zombies explode too many times"),
        "ru": ("Лимит взрывов халапеньо", "Не допустить слишком много взрывов Зомби-Халапеньо"),
        "zh": ("火爆辣椒僵尸限制", "限制火爆辣椒僵尸的爆炸次数"),
    },
    "RenaiRollerChallengeProps": {
        "en": ("Renai roller", "Do not let Renaissance rings crush too many plants"),
        "ru": ("Ренессансные кольца", "Не дать кольцам Ренессанса раздавить слишком много растений"),
        "zh": ("文艺复兴滚环", "限制文艺复兴滚环碾压的植物数量"),
    },
    "ZombiePeaChallengeProps": {
        "en": ("Zombie pea hits", "Limit plants hit by Plant Zombie bullets"),
        "ru": ("Попадания гороха зомби", "Ограничить число растений, поражённых пулями Растение-Зомби"),
        "zh": ("僵尸豌豆命中", "限制被植物僵尸子弹命中的植物数量"),
    },
    "SteamManholeChallengeProps": {
        "en": ("Steam manhole", "Do not let zombies enter sewers too many times"),
        "ru": ("Паровой люк", "Не допустить слишком много зомби, вошедших в канализацию"),
        "zh": ("蒸汽井盖", "限制僵尸进入下水道的次数"),
    },
    "StarChallengeSaveBombsProps": {
        "en": ("Save bombs", "Do not let explosive barrels detonate"),
        "ru": ("Сохранить бомбы", "Не допустить взрыва бочек с порохом"),
        "zh": ("保护炸弹", "阻止炸药桶爆炸"),
    },
}

FIELD_LABELS = {
    "en": {
        "starChallengeField_Description": "Description",
        "starChallengeField_ChallengeDescription": "Description",
        "starChallengeField_DescriptiveName": "Descriptive name",
        "starChallengeField_NumZombiesToKill": "Zombies to kill",
        "starChallengeField_NumZombieConditionsToApply": "Conditions to apply",
        "starChallengeField_IncludeBurnedToAsh": "Count burned to ash",
        "starChallengeField_IncludeElectrified": "Count electrified",
        "starChallengeField_ConditionToInflict": "Conditions to inflict",
        "starChallengeField_PlantTypeName": "Plant",
        "starChallengeField_TypesToKill": "Zombie types",
        "starChallengeField_ListType": "List type",
        "starChallengeField_GridItemType": "Grid item type",
        "starChallengeField_GridItemsToDestroy": "Grid items to destroy",
        "starChallengeField_Profession": "Profession",
        "starChallengeField_Count": "Count",
        "starChallengeField_PoisonToClean": "Poison mist to clean",
        "starChallengeField_BalletToSlip": "Ballet zombies to trip",
        "starChallengeField_MaximumExplode": "Maximum explosions",
        "starChallengeField_MaximumJalapeno": "Maximum explosions",
        "starChallengeField_MaximumPlantsDied": "Maximum plants crushed",
        "starChallengeField_MaximumPlantsHitted": "Maximum plants hit",
        "starChallengeField_MaximumManholeEntered": "Maximum sewer entries",
        "starChallengeField_TargetDistance": "Target distance",
        "starChallengeField_TargetSun": "Target sun",
        "starChallengeField_MaximumSun": "Maximum sun",
        "starChallengeField_HoldoutSeconds": "Holdout seconds",
        "starChallengeField_SpeedModifier": "Speed modifier",
        "starChallengeField_sunModifier": "Sun modifier",
        "starChallengeField_MaximumPlantsLost": "Maximum plants lost",
        "starChallengeField_MaximumPlants": "Maximum plants",
        "starChallengeField_TargetScore": "Target score",
        "starChallengeListType_whitelist": "Whitelist",
        "starChallengeListType_blacklist": "Blacklist",
        "starChallengeProfession_warrior": "Vanguard",
        "starChallengeProfession_shooter": "Shooter",
        "starChallengeProfession_specialist": "Specialist",
        "starChallengeProfession_supporter": "Supporter",
        "starChallengeProfession_protector": "Protector",
        "starChallengeProfession_sunmaker": "Sunmaker",
    },
    "ru": {
        "starChallengeField_Description": "Описание",
        "starChallengeField_ChallengeDescription": "Описание",
        "starChallengeField_DescriptiveName": "Отображаемое имя",
        "starChallengeField_NumZombiesToKill": "Зомби для убийства",
        "starChallengeField_NumZombieConditionsToApply": "Состояний для наложения",
        "starChallengeField_IncludeBurnedToAsh": "Считать сожжённых",
        "starChallengeField_IncludeElectrified": "Считать электризованных",
        "starChallengeField_ConditionToInflict": "Накладываемые состояния",
        "starChallengeField_PlantTypeName": "Растение",
        "starChallengeField_TypesToKill": "Типы зомби",
        "starChallengeField_ListType": "Тип списка",
        "starChallengeField_GridItemType": "Тип объекта сетки",
        "starChallengeField_GridItemsToDestroy": "Объектов для уничтожения",
        "starChallengeField_Profession": "Профессия",
        "starChallengeField_Count": "Количество",
        "starChallengeField_PoisonToClean": "Ядовитых туманов",
        "starChallengeField_BalletToSlip": "Балерин для подставы",
        "starChallengeField_MaximumExplode": "Максимум взрывов",
        "starChallengeField_MaximumJalapeno": "Максимум взрывов",
        "starChallengeField_MaximumPlantsDied": "Максимум раздавленных растений",
        "starChallengeField_MaximumPlantsHitted": "Максимум поражённых растений",
        "starChallengeField_MaximumManholeEntered": "Максимум входов в канализацию",
        "starChallengeField_TargetDistance": "Целевая дистанция",
        "starChallengeField_TargetSun": "Целевое солнце",
        "starChallengeField_MaximumSun": "Максимум солнца",
        "starChallengeField_HoldoutSeconds": "Секунд удержания",
        "starChallengeField_SpeedModifier": "Модификатор скорости",
        "starChallengeField_sunModifier": "Модификатор солнца",
        "starChallengeField_MaximumPlantsLost": "Максимум потерянных растений",
        "starChallengeField_MaximumPlants": "Максимум растений",
        "starChallengeField_TargetScore": "Целевой счёт",
        "starChallengeListType_whitelist": "Белый список",
        "starChallengeListType_blacklist": "Чёрный список",
        "starChallengeProfession_warrior": "Передовая",
        "starChallengeProfession_shooter": "Стрелок",
        "starChallengeProfession_specialist": "Специалист",
        "starChallengeProfession_supporter": "Поддержка",
        "starChallengeProfession_protector": "Защитник",
        "starChallengeProfession_sunmaker": "Солнце",
    },
    "zh": {
        "starChallengeField_Description": "描述",
        "starChallengeField_ChallengeDescription": "描述",
        "starChallengeField_DescriptiveName": "显示名称",
        "starChallengeField_NumZombiesToKill": "击杀僵尸数",
        "starChallengeField_NumZombieConditionsToApply": "施加状态数",
        "starChallengeField_IncludeBurnedToAsh": "计入灰烬",
        "starChallengeField_IncludeElectrified": "计入电击",
        "starChallengeField_ConditionToInflict": "施加的状态",
        "starChallengeField_PlantTypeName": "植物",
        "starChallengeField_TypesToKill": "僵尸类型",
        "starChallengeField_ListType": "列表类型",
        "starChallengeField_GridItemType": "场地物品类型",
        "starChallengeField_GridItemsToDestroy": "需破坏数量",
        "starChallengeField_Profession": "职业",
        "starChallengeField_Count": "数量",
        "starChallengeField_PoisonToClean": "需清除毒雾数",
        "starChallengeField_BalletToSlip": "需滑倒芭蕾僵尸数",
        "starChallengeField_MaximumExplode": "最大爆炸次数",
        "starChallengeField_MaximumJalapeno": "最大爆炸次数",
        "starChallengeField_MaximumPlantsDied": "最大碾压植物数",
        "starChallengeField_MaximumPlantsHitted": "最大命中植物数",
        "starChallengeField_MaximumManholeEntered": "最大入井次数",
        "starChallengeField_TargetDistance": "目标距离",
        "starChallengeField_TargetSun": "目标阳光",
        "starChallengeField_MaximumSun": "最大阳光",
        "starChallengeField_HoldoutSeconds": "坚守秒数",
        "starChallengeField_SpeedModifier": "速度修正",
        "starChallengeField_sunModifier": "阳光修正",
        "starChallengeField_MaximumPlantsLost": "最大损失植物数",
        "starChallengeField_MaximumPlants": "最大植物数",
        "starChallengeField_TargetScore": "目标分数",
        "starChallengeListType_whitelist": "白名单",
        "starChallengeListType_blacklist": "黑名单",
        "starChallengeProfession_warrior": "先锋",
        "starChallengeProfession_shooter": "远程",
        "starChallengeProfession_specialist": "奇兵",
        "starChallengeProfession_supporter": "辅助",
        "starChallengeProfession_protector": "坚韧",
        "starChallengeProfession_sunmaker": "阳光",
    },
}


CHALLENGE_PROPERTIES: dict[str, list[str]] = {
    "StarChallengeBeatTheLevelProps": ["Description", "DescriptiveName"],
    "StarChallengePlantsSurviveProps": ["Count"],
    "StarChallengeZombieDistanceProps": ["TargetDistance"],
    "StarChallengeSunProducedProps": ["TargetSun"],
    "StarChallengeSunUsedProps": ["MaximumSun"],
    "StarChallengeSpendSunHoldoutProps": ["HoldoutSeconds"],
    "StarChallengeKillZombiesInTimeProps": ["Count"],
    "StarChallengeZombieSpeedProps": ["SpeedModifier"],
    "StarChallengeSunReducedProps": ["sunModifier"],
    "StarChallengePlantsLostProps": ["MaximumPlantsLost"],
    "StarChallengeSimultaneousPlantsProps": ["MaximumPlants"],
    "StarChallengeUnfreezePlantsProps": ["Count"],
    "StarChallengeBlowZombieProps": ["Count"],
    "StarChallengeTargetScoreProps": ["TargetScore"],
    "ApplyZombieConditionsChallengeProps": [
        "NumZombieConditionsToApply",
        "IncludeBurnedToAsh",
        "IncludeElectrified",
        "ConditionToInflict",
    ],
    "PlantDefeatZombieChallengeProps": [
        "Description",
        "NumZombiesToKill",
        "PlantTypeName",
    ],
    "DefeatZombiesOfTypeChallengeProps": [
        "Description",
        "NumZombiesToKill",
        "ListType",
        "TypesToKill",
    ],
    "DestroyGridItemsChallengeProps": [
        "ChallengeDescription",
        "GridItemsToDestroy",
        "GridItemType",
    ],
    "StarChallengeDisablePlantProps": ["Profession"],
    "StarChallengeSandstormZombieKillProps": ["Count"],
    "StarChallengeTentZombieKillProps": ["Count"],
    "StarChallengeBufferTileZombieKillProps": ["Count"],
    "StarChallengePotionZombieKillProps": ["Count"],
    "StarChallengeBarrelPowderZombieKillProps": ["Count"],
    "StarChallengeBlowBarrelZombieProps": ["Count"],
    "StarChallengeFirecrackerZombieKillProps": ["Count"],
    "StarChallengeFireworksZombieKillProps": ["Count"],
    "ZombiePerfumerChallengeProps": ["PoisonToClean"],
    "BalletSlipChallengeProps": ["BalletToSlip"],
    "ZombieExplodenutChallengeProps": ["MaximumExplode"],
    "ZombieJalapenoChallengeProps": ["MaximumJalapeno"],
    "RenaiRollerChallengeProps": ["MaximumPlantsDied"],
    "ZombiePeaChallengeProps": ["MaximumPlantsHitted"],
    "SteamManholeChallengeProps": ["MaximumManholeEntered"],
}

LIST_TYPE_CHALLENGES = {
    "DefeatZombiesOfTypeChallengeProps": ["whitelist", "blacklist"],
}


def _property_label(locale: str, property_name: str) -> str:
    field_key = f"starChallengeField_{property_name}"
    return FIELD_LABELS[locale].get(field_key, property_name)


def _challenge_property_entries(locale: str) -> dict[str, str]:
    entries: dict[str, str] = {}
    for objclass, properties in CHALLENGE_PROPERTIES.items():
        for prop in properties:
            entries[f"{objclass}_{prop}"] = _property_label(locale, prop)
    for objclass, values in LIST_TYPE_CHALLENGES.items():
        for value in values:
            generic = f"starChallengeListType_{value}"
            entries[f"{objclass}_ListType_{value}"] = FIELD_LABELS[locale].get(
                generic, value
            )
    return entries


def parse_conditions() -> dict[str, str]:
    out: dict[str, str] = {}
    if not CONDITIONS_PATH.is_file():
        return out
    for line in CONDITIONS_PATH.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line:
            continue
        parts = line.split()
        if len(parts) < 2:
            continue
        cond_id = parts[-1]
        label = " ".join(parts[:-1])
        out[cond_id] = label
    return out


def build_locale_entries(locale: str) -> dict[str, str]:
    entries: dict[str, str] = {}
    for objclass, locales in CHALLENGES.items():
        title, desc = locales[locale]
        entries[f"starChallenge_{objclass}_title"] = title
        entries[f"starChallenge_{objclass}_desc"] = desc
    entries.update(FIELD_LABELS[locale])
    entries.update(_challenge_property_entries(locale))
    return entries


def load_json(path: Path) -> dict[str, str]:
    with path.open(encoding="utf-8") as f:
        return {str(k): str(v) for k, v in json.load(f).items()}


def save_json(path: Path, data: dict[str, str]) -> None:
    with path.open("w", encoding="utf-8", newline="\n") as f:
        json.dump(dict(sorted(data.items(), key=lambda x: x[0].lower())), f, ensure_ascii=False, indent=2)
        f.write("\n")


def main() -> None:
    en_values = build_locale_entries("en")
    updated = 0
    for locale in ("en", "ru", "zh"):
        path = RESOURCE_DIR / f"resource_{locale}.json"
        existing = load_json(path)
        generated = build_locale_entries(locale)
        for key, value in generated.items():
            if key not in existing:
                existing[key] = value
                updated += 1
                continue
            if locale != "en" and existing[key] == en_values.get(key):
                existing[key] = value
                updated += 1
        save_json(path, existing)
        print(f"{path.name}: {len(existing)} keys")
    print(f"Updated/added {updated} entries")


if __name__ == "__main__":
    main()
