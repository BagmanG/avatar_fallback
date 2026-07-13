import 'dart:ui' as ui show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'avatar_shape.dart';

/// App-level defaults for `AvatarFallback` widgets, applied through
/// [ThemeData.extensions].
///
/// Any value left `null` here falls back to the built-in default. Values set on
/// an individual `AvatarFallback` always take priority over the theme.
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: const <ThemeExtension<dynamic>>[
///       AvatarFallbackTheme(
///         size: 48,
///         shape: AvatarShape.rounded(12),
///       ),
///     ],
///   ),
/// );
/// ```
@immutable
class AvatarFallbackTheme extends ThemeExtension<AvatarFallbackTheme> {
  /// Creates a set of avatar defaults. All fields are optional.
  const AvatarFallbackTheme({
    this.size,
    this.shape,
    this.palette,
    this.textStyle,
    this.border,
    this.fadeInDuration,
  });

  /// The default avatar diameter in logical pixels.
  final double? size;

  /// The default avatar shape.
  final AvatarShape? shape;

  /// The default palette used for deterministic background colors.
  final List<Color>? palette;

  /// The default text style for initials.
  final TextStyle? textStyle;

  /// The default border drawn around the avatar.
  final BoxBorder? border;

  /// The default fade-in duration when an image resolves.
  final Duration? fadeInDuration;

  @override
  AvatarFallbackTheme copyWith({
    double? size,
    AvatarShape? shape,
    List<Color>? palette,
    TextStyle? textStyle,
    BoxBorder? border,
    Duration? fadeInDuration,
  }) {
    return AvatarFallbackTheme(
      size: size ?? this.size,
      shape: shape ?? this.shape,
      palette: palette ?? this.palette,
      textStyle: textStyle ?? this.textStyle,
      border: border ?? this.border,
      fadeInDuration: fadeInDuration ?? this.fadeInDuration,
    );
  }

  @override
  AvatarFallbackTheme lerp(covariant AvatarFallbackTheme? other, double t) {
    if (other == null) {
      return this;
    }
    return AvatarFallbackTheme(
      size: ui.lerpDouble(size, other.size, t),
      shape: t < 0.5 ? shape : other.shape,
      palette: t < 0.5 ? palette : other.palette,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      border: BoxBorder.lerp(border, other.border, t),
      fadeInDuration: _lerpDuration(fadeInDuration, other.fadeInDuration, t),
    );
  }

  static Duration? _lerpDuration(Duration? a, Duration? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    final Duration start = a ?? b!;
    final Duration end = b ?? a!;
    final int micros = ui
        .lerpDouble(
          start.inMicroseconds.toDouble(),
          end.inMicroseconds.toDouble(),
          t,
        )!
        .round();
    return Duration(microseconds: micros);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AvatarFallbackTheme &&
        other.size == size &&
        other.shape == shape &&
        listEquals(other.palette, palette) &&
        other.textStyle == textStyle &&
        other.border == border &&
        other.fadeInDuration == fadeInDuration;
  }

  @override
  int get hashCode => Object.hash(
    size,
    shape,
    palette == null ? null : Object.hashAll(palette!),
    textStyle,
    border,
    fadeInDuration,
  );
}
