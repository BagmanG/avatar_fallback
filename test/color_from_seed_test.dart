import 'package:avatar_fallback/avatar_fallback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('stableHash', () {
    test('is deterministic for the same input', () {
      expect(stableHash('John Doe'), stableHash('John Doe'));
    });

    test('differs for different inputs', () {
      expect(stableHash('John Doe'), isNot(stableHash('Jane Doe')));
    });

    test('matches the known FNV-1a value for the empty string', () {
      // FNV-1a 32-bit offset basis.
      expect(stableHash(''), 0x811c9dc5);
    });

    test('is stable across runs (pinned value)', () {
      // Pinning a concrete value guards against accidental algorithm changes
      // that would shuffle everyone's avatar colors.
      expect(stableHash('a'), 0xe40c292c);
    });
  });

  group('colorFromSeed', () {
    const List<Color> palette = <Color>[
      Color(0xFF000001),
      Color(0xFF000002),
      Color(0xFF000003),
      Color(0xFF000004),
    ];

    test('same seed -> same color', () {
      expect(colorFromSeed('alice', palette), colorFromSeed('alice', palette));
    });

    test('pins the resolved index for a known seed', () {
      final int index = stableHash('alice') % palette.length;
      expect(colorFromSeed('alice', palette), palette[index]);
    });

    test('throws on empty palette', () {
      expect(() => colorFromSeed('x', const <Color>[]), throwsArgumentError);
    });

    test('uses the default palette without error', () {
      expect(kDefaultAvatarPalette, isNotEmpty);
      expect(
        colorFromSeed('someone', kDefaultAvatarPalette),
        isIn(kDefaultAvatarPalette),
      );
    });
  });

  group('contrastColorFor', () {
    test('white background -> black text', () {
      expect(contrastColorFor(const Color(0xFFFFFFFF)), Colors.black);
    });

    test('black background -> white text', () {
      expect(contrastColorFor(const Color(0xFF000000)), Colors.white);
    });
  });
}
