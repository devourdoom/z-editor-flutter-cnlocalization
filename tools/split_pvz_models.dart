// ignore_for_file: avoid_print

/// Reads lib/data/pvz_models.dart and writes lib/data/pvz_models/<Class>.dart
/// Run: dart run tool/split_pvz_models.dart

import 'dart:io';

final _dartKw = <String>{
  'String',
  'int',
  'double',
  'bool',
  'num',
  'Object',
  'Map',
  'List',
  'Set',
  'Iterable',
  'Iterator',
  'RegExp',
  'dynamic',
  'void',
};

void main() {
  final root = Directory.current.path;
  final srcFile = File('$root/lib/data/pvz_models.dart');
  if (!srcFile.existsSync()) {
    stderr.writeln('Missing ${srcFile.path}');
    exit(1);
  }
  final text = srcFile.readAsStringSync();
  final lines = text.split('\n');

  var startIdx = 0;
  while (startIdx < lines.length &&
      (lines[startIdx].startsWith('library') ||
          lines[startIdx].startsWith('///') ||
          lines[startIdx].trim().isEmpty)) {
    startIdx++;
  }

  final classStarts = <int>[];
  final classNames = <String>[];
  final reClass = RegExp(r'^class ([A-Za-z_]\w*)\b');
  for (var i = startIdx; i < lines.length; i++) {
    final m = reClass.firstMatch(lines[i]);
    if (m != null) {
      classStarts.add(i);
      classNames.add(m.group(1)!);
    }
  }

  if (classStarts.isEmpty) {
    stderr.writeln('No classes found');
    exit(1);
  }

  final outDir = Directory('$root/lib/data/pvz_models');
  if (outDir.existsSync()) {
    for (final e in outDir.listSync()) {
      if (e is File && e.path.endsWith('.dart')) {
        e.deleteSync();
      }
    }
  } else {
    outDir.createSync(recursive: true);
  }

  /// Public class name as used in code (envelope rename).
  String publicName(String sourceName) =>
      sourceName == 'PvzObject' ? 'PvzFileObject' : sourceName;

  final publicNames = <String>{
    for (final c in classNames) publicName(c),
    'PvzObject', // abstract base (not from source list as top-level split)
  };

  bool hasJsonFactories(String cls, List<String> bodyLines) {
    final body = bodyLines.join('\n');
    if (!body.contains(
      RegExp(r'Map\s*<\s*String\s*,\s*dynamic\s*>\s*toJson\s*\('),
    )) {
      return false;
    }
    return body.contains(RegExp(r'factory\s+$cls\s*\.\s*fromJson\b'));
  }

  bool needsExtendsObjData(String sourceCls, List<String> bodyLines) {
    if (sourceCls == 'PvzLevelFile' ||
        sourceCls == 'ParsedLevelData' ||
        sourceCls == 'ZombieStats' ||
        sourceCls == 'PvzObject') {
      return false;
    }
    return hasJsonFactories(sourceCls, bodyLines);
  }

  String transformBody(String sourceCls, List<String> bodyLines) {
    var s = bodyLines.join('\n');
    // JSON row wrapper: rename to PvzFileObject extending abstract PvzObject.
    if (sourceCls == 'PvzObject') {
      s = s.replaceFirst(
        RegExp(r'^class PvzObject\b'),
        'class PvzFileObject extends PvzObject',
      );
      s = s.replaceAll(
        RegExp(r'factory PvzObject\.fromJson'),
        'factory PvzFileObject.fromJson',
      );
      s = s.replaceAll('PvzObject(', 'PvzFileObject(');
    }
    if (sourceCls == 'PvzLevelFile') {
      s = s.replaceAll('List<PvzObject>', 'List<PvzFileObject>');
      s = s.replaceAll('PvzObject.fromJson', 'PvzFileObject.fromJson');
    }
    if (sourceCls == 'ParsedLevelData') {
      s = s.replaceAll('Map<String, PvzObject>', 'Map<String, PvzFileObject>');
    }

    return s;
  }

  bool references(String body, String symbol) {
    return RegExp(r'\b' + RegExp.escape(symbol) + r'\b').hasMatch(body);
  }

  List<String> importsFor(String outFileClass, String transformedBody) {
    final imps = <String>{};
    for (final name in publicNames) {
      if (name == outFileClass) continue;
      if (_dartKw.contains(name)) continue;
      if (!references(transformedBody, name)) continue;
      imps.add("import 'package:c_editor/data/pvz_models/$name.dart';");
    }
    final sorted = imps.toList()..sort();
    return sorted;
  }

  File('${outDir.path}/PvzObject.dart').writeAsStringSync(
    '/// Base for JSON-serializable objdata payloads (not the level file root).\n'
    'abstract class PvzObject {\n'
    '  Map<String, dynamic> toJson();\n'
    '}\n',
  );
  print('Wrote PvzObject.dart (abstract base)');

  final exports = <String>["export 'pvz_models/PvzObject.dart';"];

  for (var ci = 0; ci < classStarts.length; ci++) {
    final start = classStarts[ci];
    final end = ci + 1 < classStarts.length
        ? classStarts[ci + 1] - 1
        : lines.length - 1;
    final rawBody = lines.sublist(start, end + 1);
    final sourceCls = classNames[ci];
    final outName = publicName(sourceCls);

    var transformed = transformBody(sourceCls, rawBody);

    final hdrInjection = RegExp(
      '^class ${RegExp.escape(sourceCls)}\\b(\\s*[^{]*)\\{',
      multiLine: true,
    );
    if (needsExtendsObjData(sourceCls, rawBody)) {
      transformed = transformed.replaceFirstMapped(hdrInjection, (m) {
        final after = m.group(1)!;
        if (after.contains('extends')) return m.group(0)!;
        return 'class $sourceCls extends PvzObject$after{';
      });
    }

    final imps = importsFor(outName, transformed);
    final out = StringBuffer();
    for (final i in imps) {
      out.writeln(i);
    }
    if (imps.isNotEmpty) out.writeln();
    out.write(transformed);
    out.writeln();

    File('${outDir.path}/$outName.dart').writeAsStringSync(out.toString());
    exports.add("export 'pvz_models/$outName.dart';");
    print('Wrote $outName.dart');
  }

  exports.sort();
  // Keep PvzObject export first
  exports.removeWhere((e) => e.contains("PvzObject.dart"));
  exports.insert(0, "export 'pvz_models/PvzObject.dart';");

  final barrel = StringBuffer();
  barrel.writeln('/// PVZ2 level file and object models (split by class).');
  barrel.writeln('library;');
  barrel.writeln();
  for (final e in exports) {
    barrel.writeln(e);
  }
  srcFile.writeAsStringSync(barrel.toString());
  print('Updated ${srcFile.path} (${exports.length} exports)');
}
