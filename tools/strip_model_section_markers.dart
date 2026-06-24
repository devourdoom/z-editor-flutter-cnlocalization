// ignore_for_file: avoid_print

import 'dart:io';

void main() {
  final re = RegExp(r'^\s*// =');
  for (final f in Directory(
    'lib/data/pvz_models',
  ).listSync().whereType<File>()) {
    if (!f.path.endsWith('.dart')) continue;
    final lines = f.readAsLinesSync();
    final kept = lines.where((l) => !re.hasMatch(l)).toList();
    if (kept.length != lines.length) {
      f.writeAsStringSync('${kept.join('\n')}\n');
      print(
        'stripped ${lines.length - kept.length} lines in ${f.uri.pathSegments.last}',
      );
    }
  }
}
