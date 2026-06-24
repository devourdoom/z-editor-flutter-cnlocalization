String normalizeSelectionSearchQuery(String query) =>
    query.trim().toLowerCase();

bool matchesSelectionSearch(String query, Iterable<String?> values) {
  final normalizedQuery = normalizeSelectionSearchQuery(query);
  if (normalizedQuery.isEmpty) return true;

  for (final value in values) {
    if (value == null) continue;
    if (value.toLowerCase().contains(normalizedQuery)) return true;
  }
  return false;
}

List<T> mergeUniqueSelectionResults<T, K>(
  Iterable<T> primary,
  Iterable<T> additions,
  K Function(T item) keyOf,
) {
  final seen = <K>{};
  final merged = <T>[];

  void addIfNew(T item) {
    if (seen.add(keyOf(item))) {
      merged.add(item);
    }
  }

  for (final item in primary) {
    addIfNew(item);
  }
  for (final item in additions) {
    addIfNew(item);
  }

  return merged;
}
