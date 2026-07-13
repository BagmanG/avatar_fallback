import 'package:flutter/material.dart';

/// A curated set of Material 3 tones used as the default background palette
/// for deterministic avatar colors.
///
/// The colors are chosen to be pleasant, sufficiently saturated, and
/// contrasting enough to work with either black or white foreground text.
/// The contrast decision itself is made per-color at render time (see
/// `contrastColorFor`), so this list only needs to provide good background
/// candidates.
const List<Color> kDefaultAvatarPalette = <Color>[
  Color(0xFFE53935), // red
  Color(0xFFD81B60), // pink
  Color(0xFF8E24AA), // purple
  Color(0xFF5E35B1), // deep purple
  Color(0xFF3949AB), // indigo
  Color(0xFF1E88E5), // blue
  Color(0xFF039BE5), // light blue
  Color(0xFF00897B), // teal
  Color(0xFF43A047), // green
  Color(0xFF7CB342), // light green
  Color(0xFFF4511E), // deep orange
  Color(0xFF6D4C41), // brown
  Color(0xFF546E7A), // blue grey
  Color(0xFFC0CA33), // lime
  Color(0xFFFB8C00), // orange
  Color(0xFF00ACC1), // cyan
];
