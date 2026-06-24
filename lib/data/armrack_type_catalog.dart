/// Weapon stand (armrack) variant types and their grid preview icons.
class ArmrackTypeInfo {
  const ArmrackTypeInfo({
    required this.type,
    required this.iconFile,
    this.gridScale = 0.82,
  });

  final String type;
  final String iconFile;

  /// Scale within a lawn grid cell (tuned per asset aspect ratio).
  final double gridScale;
}

const List<ArmrackTypeInfo> kArmrackTypes = [
  ArmrackTypeInfo(
    type: 'ArmrackFlag',
    iconFile: 'ArmrackFlag.webp',
    gridScale: 0.68,
  ),
  ArmrackTypeInfo(
    type: 'ArmrackTorch',
    iconFile: 'ArmrackTorch.webp',
    gridScale: 0.72,
  ),
  ArmrackTypeInfo(
    type: 'ArmrackNunchaku',
    iconFile: 'ArmrackNunchaku.webp',
    gridScale: 0.80,
  ),
  ArmrackTypeInfo(
    type: 'ArmrackBlade',
    iconFile: 'ArmrackBlade.webp',
    gridScale: 0.86,
  ),
  ArmrackTypeInfo(
    type: 'ArmrackHammer',
    iconFile: 'ArmrackHammer.webp',
    gridScale: 0.84,
  ),
  ArmrackTypeInfo(
    type: 'ArmrackBomb',
    iconFile: 'ArmrackBomb.webp',
    gridScale: 0.78,
  ),
  ArmrackTypeInfo(
    type: 'ArmrackArmor',
    iconFile: 'ArmrackArmor.webp',
    gridScale: 0.80,
  ),
];

String armrackIconAsset(String type) {
  for (final info in kArmrackTypes) {
    if (info.type == type) {
      return 'assets/images/griditems/${info.iconFile}';
    }
  }
  return 'assets/images/griditems/ArmrackRandom.webp';
}

double armrackGridScale(String type) {
  for (final info in kArmrackTypes) {
    if (info.type == type) return info.gridScale;
  }
  return 0.82;
}
