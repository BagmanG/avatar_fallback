import 'dart:convert';

import 'package:flutter/material.dart';

/// Computes a stable 32-bit [FNV-1a](https://en.wikipedia.org/wiki/Fowler%E2%80%93Noll%E2%80%93Vo_hash_function)
/// hash of [input].
///
/// Unlike [Object.hashCode], this hash is guaranteed to be identical across
/// platforms and across separate runs of the application for the same input.
/// That stability is what lets the same name always resolve to the same avatar
/// color everywhere.
///
/// The input is encoded as UTF-8 bytes before hashing so that the result is
/// independent of the platform's string representation.
int stableHash(String input) {
  const int fnvOffsetBasis = 0x811c9dc5;
  const int fnvPrime = 0x01000193;
  var hash = fnvOffsetBasis;
  for (final int byte in utf8.encode(input)) {
    hash ^= byte;
    hash = (hash * fnvPrime) & 0xFFFFFFFF;
  }
  return hash;
}

/// Deterministically picks a color from [palette] for the given [seed].
///
/// The same [seed] always yields the same color for a given [palette], on every
/// device and every run. Throws [ArgumentError] if [palette] is empty.
Color colorFromSeed(String seed, List<Color> palette) {
  if (palette.isEmpty) {
    throw ArgumentError.value(palette, 'palette', 'must not be empty');
  }
  return palette[stableHash(seed) % palette.length];
}

/// Returns a readable foreground color (black or white) for text drawn on top
/// of [background], chosen by the background's relative luminance.
Color contrastColorFor(Color background) {
  return background.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}
