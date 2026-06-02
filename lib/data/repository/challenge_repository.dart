import 'package:flutter/material.dart';
import 'package:z_editor/data/pvz_models.dart';
import 'package:z_editor/l10n/resource_names.dart';

/// Challenge type metadata. Ported from Z-Editor-master ChallengeRepository.kt
class ChallengeTypeInfo {
  const ChallengeTypeInfo({
    required this.title,
    required this.objClass,
    required this.defaultAlias,
    required this.description,
    required this.icon,
    this.initialDataFactory,
  });

  final String title;
  final String objClass;
  final String defaultAlias;
  final String description;
  final IconData icon;
  final Object? Function()? initialDataFactory;

  static String _titleKey(String objClass) =>
      'starChallenge_${objClass}_title';

  static String _descKey(String objClass) => 'starChallenge_${objClass}_desc';

  String localizedTitle(BuildContext context) =>
      ChallengeRepository.localizedTitle(context, objClass);

  String localizedDescription(BuildContext context) =>
      ChallengeRepository.localizedDescription(context, objClass);
}

/// Challenge repository. Ported from Z-Editor-master ChallengeRepository.kt
class ChallengeRepository {
  ChallengeRepository._();

  static final List<ChallengeTypeInfo> allChallenges = [
    ChallengeTypeInfo(
      title: 'Level hint text',
      objClass: 'StarChallengeBeatTheLevelProps',
      defaultAlias: 'BeatTheLevel',
      description: 'Show hint text popup at level start',
      icon: Icons.campaign,
      initialDataFactory: () => StarChallengeBeatTheLevelData(),
    ),
    ChallengeTypeInfo(
      title: 'Don\'t lose mowers',
      objClass: 'StarChallengeSaveMowersProps',
      defaultAlias: 'SaveMowers',
      description: 'Do not lose lawn mowers',
      icon: Icons.cleaning_services,
      initialDataFactory: () => StarChallengeSaveMowerData(),
    ),
    ChallengeTypeInfo(
      title: 'Don\'t use plant food',
      objClass: 'StarChallengePlantFoodNonuseProps',
      defaultAlias: 'PlantfoodNonuse',
      description: 'Do not use plant food',
      icon: Icons.eco,
      initialDataFactory: () => StarChallengePlantFoodNonuseData(),
    ),
    ChallengeTypeInfo(
      title: 'Plants survive',
      objClass: 'StarChallengePlantsSurviveProps',
      defaultAlias: 'PlantsSurive',
      description: 'Specified plants must survive',
      icon: Icons.security,
      initialDataFactory: () => StarChallengePlantSurviveData(),
    ),
    ChallengeTypeInfo(
      title: 'Zombie distance',
      objClass: 'StarChallengeZombieDistanceProps',
      defaultAlias: 'ZombieDistance',
      description: 'Zombies must not step on flowers',
      icon: Icons.do_not_step,
      initialDataFactory: () => StarChallengeZombieDistanceData(),
    ),
    ChallengeTypeInfo(
      title: 'Sun produced',
      objClass: 'StarChallengeSunProducedProps',
      defaultAlias: 'SunProduced',
      description: 'Produce a certain amount of sun',
      icon: Icons.wb_sunny,
      initialDataFactory: () => StarChallengeSunProducedData(),
    ),
    ChallengeTypeInfo(
      title: 'Sun used',
      objClass: 'StarChallengeSunUsedProps',
      defaultAlias: 'SunUsed',
      description: 'Limit sun usage',
      icon: Icons.savings,
      initialDataFactory: () => StarChallengeSunUsedData(),
    ),
    ChallengeTypeInfo(
      title: 'Spend sun holdout',
      objClass: 'StarChallengeSpendSunHoldoutProps',
      defaultAlias: 'SpendSunHoldout',
      description: 'Survive while spending sun',
      icon: Icons.hourglass_empty,
      initialDataFactory: () => StarChallengeSpendSunHoldoutData(),
    ),
    ChallengeTypeInfo(
      title: 'Kill zombies in time',
      objClass: 'StarChallengeKillZombiesInTimeProps',
      defaultAlias: 'KillZombies',
      description: 'Kill X zombies within Y seconds',
      icon: Icons.pest_control,
      initialDataFactory: () => StarChallengeKillZombiesInTimeData(),
    ),
    ChallengeTypeInfo(
      title: 'Zombie speed',
      objClass: 'StarChallengeZombieSpeedProps',
      defaultAlias: 'ZombieSpeed',
      description: 'Increase zombie speed',
      icon: Icons.speed,
      initialDataFactory: () => StarChallengeZombieSpeedData(),
    ),
    ChallengeTypeInfo(
      title: 'Sun reduced',
      objClass: 'StarChallengeSunReducedProps',
      defaultAlias: 'SunReduced',
      description: 'Sun decays over time',
      icon: Icons.brightness_low,
      initialDataFactory: () => StarChallengeSunReducedData(),
    ),
    ChallengeTypeInfo(
      title: 'Plants lost',
      objClass: 'StarChallengePlantsLostProps',
      defaultAlias: 'PlantsLost',
      description: 'Do not lose more than X plants',
      icon: Icons.heart_broken,
      initialDataFactory: () => StarChallengePlantsLostData(),
    ),
    ChallengeTypeInfo(
      title: 'Simultaneous plants',
      objClass: 'StarChallengeSimultaneousPlantsProps',
      defaultAlias: 'SimultaneousPlants',
      description: 'Limit plants on field',
      icon: Icons.forest,
      initialDataFactory: () => StarChallengeSimultaneousPlantsData(),
    ),
    ChallengeTypeInfo(
      title: 'Unfreeze plants',
      objClass: 'StarChallengeUnfreezePlantsProps',
      defaultAlias: 'UnfreezePlants',
      description: 'Unfreeze X plants',
      icon: Icons.ac_unit,
      initialDataFactory: () => StarChallengeUnfreezePlantsData(),
    ),
    ChallengeTypeInfo(
      title: 'Blow zombie',
      objClass: 'StarChallengeBlowZombieProps',
      defaultAlias: 'BlowZombie',
      description: 'Blow away X zombies',
      icon: Icons.air,
      initialDataFactory: () => StarChallengeBlowZombieData(),
    ),
    ChallengeTypeInfo(
      title: 'Target score',
      objClass: 'StarChallengeTargetScoreProps',
      defaultAlias: 'ReachTheScore',
      description: 'Reach target score',
      icon: Icons.scoreboard,
      initialDataFactory: () => StarChallengeTargetScoreData(),
    ),
  ];

  static List<ChallengeTypeInfo> search(String query, [BuildContext? context]) {
    if (query.trim().isEmpty) return allChallenges;
    final lower = query.toLowerCase();
    return allChallenges
        .where((c) {
          final title = context != null
              ? c.localizedTitle(context)
              : c.title;
          final description = context != null
              ? c.localizedDescription(context)
              : c.description;
          return title.toLowerCase().contains(lower) ||
              description.toLowerCase().contains(lower) ||
              c.title.toLowerCase().contains(lower) ||
              c.description.toLowerCase().contains(lower) ||
              c.objClass.toLowerCase().contains(lower) ||
              c.defaultAlias.toLowerCase().contains(lower);
        })
        .toList();
  }

  static String localizedTitle(BuildContext context, String objClass) {
    final key = ChallengeTypeInfo._titleKey(objClass);
    final localized = ResourceNames.lookup(context, key);
    if (localized != key) return localized;
    return getInfo(objClass)?.title ?? objClass;
  }

  static String localizedDescription(BuildContext context, String objClass) {
    final key = ChallengeTypeInfo._descKey(objClass);
    final localized = ResourceNames.lookup(context, key);
    if (localized != key) return localized;
    return getInfo(objClass)?.description ?? '';
  }

  static ChallengeTypeInfo? getInfo(String objClass) {
    try {
      return allChallenges.firstWhere((c) => c.objClass == objClass);
    } catch (_) {
      return null;
    }
  }
}
