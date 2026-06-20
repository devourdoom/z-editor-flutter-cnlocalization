import 'package:flutter/material.dart';

/// Search/replace helpers for the JSON code viewer.
class JsonViewerSearchOptions {
  const JsonViewerSearchOptions({
    this.caseSensitive = false,
    this.wholeWords = false,
    this.regex = false,
  });

  final bool caseSensitive;
  final bool wholeWords;
  final bool regex;
}

class JsonViewerTextMatch {
  const JsonViewerTextMatch({
    required this.start,
    required this.end,
    required this.lineIndex,
  });

  /// Inclusive start, exclusive end — offsets in the full document.
  final int start;
  final int end;
  final int lineIndex;
}

RegExp? buildJsonViewerSearchPattern(
  String query,
  JsonViewerSearchOptions options,
) {
  if (query.isEmpty) return null;
  try {
    if (options.regex) {
      return RegExp(query, caseSensitive: options.caseSensitive, multiLine: true);
    }
    var pattern = RegExp.escape(query);
    if (options.wholeWords) {
      pattern = r'\b' + pattern + r'\b';
    }
    return RegExp(pattern, caseSensitive: options.caseSensitive);
  } catch (_) {
    return null;
  }
}

List<JsonViewerTextMatch> findJsonViewerMatches(
  String text,
  String query,
  JsonViewerSearchOptions options,
) {
  final pattern = buildJsonViewerSearchPattern(query, options);
  if (pattern == null) return const [];

  final matches = <JsonViewerTextMatch>[];
  var lineIndex = 0;
  var lineStart = 0;
  for (var i = 0; i <= text.length; i++) {
    if (i == text.length || text.codeUnitAt(i) == 10) {
      final line = text.substring(lineStart, i);
      for (final match in pattern.allMatches(line)) {
        matches.add(
          JsonViewerTextMatch(
            start: lineStart + match.start,
            end: lineStart + match.end,
            lineIndex: lineIndex,
          ),
        );
      }
      lineStart = i + 1;
      lineIndex++;
    }
  }
  return matches;
}

String replaceJsonViewerMatch(
  String text,
  JsonViewerTextMatch match,
  String replacement,
) {
  return text.substring(0, match.start) +
      replacement +
      text.substring(match.end);
}

String replaceAllJsonViewerMatches(
  String text,
  String query,
  String replacement,
  JsonViewerSearchOptions options,
) {
  final pattern = buildJsonViewerSearchPattern(query, options);
  if (pattern == null) return text;
  return text.replaceAll(pattern, replacement);
}

/// Builds [TextSpan] children with optional match highlights.
List<InlineSpan> buildHighlightedTextSpans({
  required String text,
  required int segmentStartInLine,
  required int segmentEndInLine,
  required TextStyle baseStyle,
  required TextStyle highlightStyle,
  required TextStyle activeHighlightStyle,
  required List<JsonViewerTextMatch> lineMatches,
  JsonViewerTextMatch? activeMatch,
  required int lineStartOffset,
}) {
  if (lineMatches.isEmpty || text.isEmpty) {
    return [TextSpan(text: text, style: baseStyle)];
  }

  final localRanges = <({int start, int end, bool active})>[];
  for (var i = 0; i < lineMatches.length; i++) {
    final m = lineMatches[i];
    final localStart = m.start - lineStartOffset;
    final localEnd = m.end - lineStartOffset;
    final overlapStart = localStart.clamp(segmentStartInLine, segmentEndInLine);
    final overlapEnd = localEnd.clamp(segmentStartInLine, segmentEndInLine);
    if (overlapStart >= overlapEnd) continue;
    localRanges.add((
      start: overlapStart - segmentStartInLine,
      end: overlapEnd - segmentStartInLine,
      active: activeMatch != null &&
          activeMatch.start == m.start &&
          activeMatch.end == m.end,
    ));
  }

  if (localRanges.isEmpty) {
    return [TextSpan(text: text, style: baseStyle)];
  }

  localRanges.sort((a, b) => a.start.compareTo(b.start));
  final spans = <InlineSpan>[];
  var cursor = 0;
  for (final range in localRanges) {
    if (range.start > cursor) {
      spans.add(
        TextSpan(
          text: text.substring(cursor, range.start),
          style: baseStyle,
        ),
      );
    }
    spans.add(
      TextSpan(
        text: text.substring(range.start, range.end),
        style: range.active ? activeHighlightStyle : highlightStyle,
      ),
    );
    cursor = range.end;
  }
  if (cursor < text.length) {
    spans.add(TextSpan(text: text.substring(cursor), style: baseStyle));
  }
  return spans;
}
