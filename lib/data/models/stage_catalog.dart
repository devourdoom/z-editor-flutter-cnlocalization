/// Schema and helper metadata for stage property sheets (`Stages.json`, helpers).
class StageFieldSpec {
  const StageFieldSpec({
    required this.name,
    required this.type,
    this.defaultValue,
  });

  final String name;
  final String type;
  final dynamic defaultValue;

  bool get isZombieType =>
      type == 'zombieType' || type == 'List<zombieType>';

  factory StageFieldSpec.fromJson(Map<String, dynamic> json) {
    return StageFieldSpec(
      name: json['name'] as String,
      type: json['type'] as String? ?? 'string',
      defaultValue: json['default'],
    );
  }
}

class StageImplementation {
  const StageImplementation({
    required this.alias,
    required this.objclass,
    required this.objdata,
    this.image,
    this.tag,
  });

  final String alias;
  final String objclass;
  final Map<String, dynamic> objdata;
  final String? image;
  final String? tag;
}

class StageCatalogSection {
  const StageCatalogSection({
    required this.objclass,
    required this.fields,
    required this.implementations,
  });

  final String objclass;
  final List<StageFieldSpec> fields;
  final List<StageImplementation> implementations;

  StageImplementation? implementationFor(String alias) {
    for (final impl in implementations) {
      if (impl.alias == alias) return impl;
    }
    return null;
  }

  StageImplementation? get primaryImplementation =>
      implementations.isNotEmpty ? implementations.first : null;

  factory StageCatalogSection.fromJson(Map<String, dynamic> json) {
    final fieldsRaw = json['fields'];
    final implRaw = json['implementations'];
    return StageCatalogSection(
      objclass: json['objclass'] as String,
      fields: fieldsRaw is List
          ? fieldsRaw
              .map(
                (e) => StageFieldSpec.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList()
          : const [],
      implementations: implRaw is List
          ? implRaw.map((e) {
              final map = Map<String, dynamic>.from(e as Map);
              return StageImplementation(
                alias: map['alias'] as String,
                objclass: json['objclass'] as String,
                objdata: Map<String, dynamic>.from(
                  map['objdata'] as Map? ?? const {},
                ),
                image: map['image'] as String?,
                tag: map['tag'] as String?,
              );
            }).toList()
          : const [],
    );
  }
}

class StageBackgroundOption {
  const StageBackgroundOption({
    required this.delayLoadGroup,
    required this.imagePrefix,
    required this.image,
    required this.nameKey,
  });

  final String delayLoadGroup;
  final String imagePrefix;
  final String image;
  final String nameKey;
}
