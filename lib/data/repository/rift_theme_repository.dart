/// Known Penny Pursuit / Memory Lane rift theme ids for [RiftThemeDemoModuleProperties].
class RiftThemeRepository {
  RiftThemeRepository._();

  static const themeIds = [
    'zombie',
    'projectile',
    'rusher',
    'nuke',
    'gravity',
    'rift',
    'spawn_offset',
    'fire_reduce',
    'lighting_reduce',
    'cold_reduce',
    'miner_cheating',
    'mage_cheating',
    'knight_cheating',
    'invisible',
    'sun',
    'dark',
    'blizzard',
    'gravestone',
    'plant_exploder',
    'plant_aoe',
    'plant_fastcd',
    'plant_melee',
    'lemon',
    'balloon',
    'plant_seed',
    'piggy_bank',
    'energy_fly',
    'watering',
    'disable_boost',
    'printer',
    'cleaner',
    'pea_rain',
    'sun_disabled',
    'zombie_sun',
  ];

  static String nameKey(String id) => 'rift_theme_$id';

  static List<String> availableThemes(Iterable<String> used) {
    final usedSet = used.toSet();
    return themeIds.where((id) => !usedSet.contains(id)).toList();
  }

  static bool isKnown(String id) => themeIds.contains(id);
}
