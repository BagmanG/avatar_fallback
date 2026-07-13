import 'package:flutter/widgets.dart';

/// The visual outline of an avatar.
///
/// Use one of the const factories to pick a shape:
///
/// ```dart
/// const AvatarShape.circle();
/// const AvatarShape.square();
/// const AvatarShape.rounded(12);
/// ```
sealed class AvatarShape {
  /// Const base constructor for subclasses.
  const AvatarShape();

  /// A perfectly round avatar. This is the default.
  const factory AvatarShape.circle() = CircleAvatarShape;

  /// A square avatar with sharp corners.
  const factory AvatarShape.square() = SquareAvatarShape;

  /// A square avatar with rounded corners of the given [radius].
  const factory AvatarShape.rounded(double radius) = RoundedAvatarShape;

  /// Whether this shape should be rendered as a circle.
  ///
  /// When `true`, callers should use [BoxShape.circle] and ignore
  /// [resolveBorderRadius].
  bool get isCircle;

  /// The corner radius to apply for non-circular shapes.
  ///
  /// Returns `null` for [CircleAvatarShape]. The [size] is the avatar diameter
  /// and is provided so shapes may derive a radius from it if needed.
  BorderRadius? resolveBorderRadius(double size);
}

/// A perfectly round avatar shape.
class CircleAvatarShape extends AvatarShape {
  /// Creates a circular avatar shape.
  const CircleAvatarShape();

  @override
  bool get isCircle => true;

  @override
  BorderRadius? resolveBorderRadius(double size) => null;
}

/// A square avatar shape with sharp corners.
class SquareAvatarShape extends AvatarShape {
  /// Creates a square avatar shape.
  const SquareAvatarShape();

  @override
  bool get isCircle => false;

  @override
  BorderRadius? resolveBorderRadius(double size) => BorderRadius.zero;
}

/// A square avatar shape with rounded corners.
class RoundedAvatarShape extends AvatarShape {
  /// Creates a rounded avatar shape with the given corner [radius].
  const RoundedAvatarShape(this.radius);

  /// The corner radius in logical pixels.
  final double radius;

  @override
  bool get isCircle => false;

  @override
  BorderRadius? resolveBorderRadius(double size) =>
      BorderRadius.circular(radius);
}
