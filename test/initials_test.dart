import 'package:avatar_fallback/avatar_fallback.dart';
import 'package:characters/characters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('initialsFromName', () {
    test('two words -> first grapheme of each', () {
      expect(initialsFromName('John Doe'), 'JD');
    });

    test('single word -> first grapheme only', () {
      expect(initialsFromName('John'), 'J');
    });

    test('collapses and trims surrounding whitespace', () {
      expect(initialsFromName('  a  b  '), 'AB');
    });

    test('empty string -> placeholder', () {
      expect(initialsFromName(''), '?');
    });

    test('whitespace-only string -> placeholder', () {
      expect(initialsFromName('   '), '?');
    });

    test('custom placeholder is honored', () {
      expect(initialsFromName('', emptyPlaceholder: '#'), '#');
    });

    test('single letter name', () {
      expect(initialsFromName('a'), 'A');
    });

    test('emoji at the start is not split', () {
      // U+1F600 grinning face.
      final String result = initialsFromName('\u{1F600} Smith');
      expect(result.characters.first, '\u{1F600}');
      expect(result.characters.length, 2);
    });

    test('combining characters stay intact', () {
      // "e" + combining acute accent (U+0301) must stay one grapheme.
      const String composed = 'é';
      final String first = initialsFromName(
        '$composed lastname',
      ).characters.first;
      expect(first, composed.toUpperCase());
      expect(first.characters.length, 1);
    });

    test('RTL Arabic name uses first grapheme of each word', () {
      // "Muhammad Ali" in Arabic.
      const String arabic = 'محمد علي';
      final String result = initialsFromName(arabic);
      expect(result.characters.length, 2);
    });

    test('RTL Hebrew name', () {
      // "David Cohen" in Hebrew.
      const String hebrew = 'דוד כהן';
      final String result = initialsFromName(hebrew);
      expect(result.characters.length, 2);
    });

    test('maxInitials of 1 truncates multi-word initials', () {
      expect(initialsFromName('John Doe', maxInitials: 1), 'J');
    });

    test('more than two words uses first and last', () {
      expect(initialsFromName('John Michael Doe'), 'JD');
    });

    test('maxInitials below 1 is clamped to 1', () {
      expect(initialsFromName('John Doe', maxInitials: 0), 'J');
    });
  });
}
