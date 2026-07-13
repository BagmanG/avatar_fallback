import 'package:characters/characters.dart';

/// Derives up to [maxInitials] initials from [name].
///
/// The algorithm is Unicode-correct: it operates on grapheme clusters via
/// [Characters], so emoji and combining marks are never split, and RTL names
/// (Arabic, Hebrew, …) are handled the same as LTR ones.
///
/// Rules:
///
/// * Leading/trailing whitespace is trimmed and internal runs of whitespace are
///   collapsed before splitting into words.
/// * Multiple words → the first grapheme of the first word plus the first
///   grapheme of the last word, truncated to [maxInitials].
/// * A single word → its first grapheme only (a single letter is enough to
///   identify one word; [maxInitials] only expands multi-word initials).
/// * Empty input, or input that is only whitespace → [emptyPlaceholder].
///
/// The result is upper-cased.
///
/// Examples:
///
/// ```dart
/// initialsFromName('John Doe');   // 'JD'
/// initialsFromName('John');       // 'J'
/// initialsFromName('  a  b  ');   // 'AB'
/// initialsFromName('');           // '?'
/// ```
String initialsFromName(
  String name, {
  int maxInitials = 2,
  String emptyPlaceholder = '?',
}) {
  final List<String> words = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((String word) => word.isNotEmpty)
      .toList();

  if (words.isEmpty) {
    return emptyPlaceholder;
  }

  final int limit = maxInitials < 1 ? 1 : maxInitials;
  final List<String> graphemes = <String>[words.first.characters.first];
  if (words.length > 1) {
    graphemes.add(words.last.characters.first);
  }

  return graphemes.take(limit).join().toUpperCase();
}
