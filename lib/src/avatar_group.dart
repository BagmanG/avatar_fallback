import 'package:flutter/material.dart';

/// A horizontal stack of overlapping [avatars] with an optional "+N" overflow
/// indicator.
///
/// Typically the [avatars] are [AvatarFallback] widgets, but any widgets of the
/// given [size] work. When there are more avatars than [maxVisible], the last
/// slot shows an overflow indicator (a circle with the hidden count by default,
/// customizable via [overflowBuilder]).
///
/// Each avatar is wrapped in a separating ring (see [borderColor] and
/// [borderWidth]) so overlapping avatars stay visually distinct. The ring is
/// circular, matching the common case of circular grouped avatars.
class AvatarGroup extends StatelessWidget {
  /// Creates a group of overlapping avatars.
  const AvatarGroup({
    super.key,
    required this.avatars,
    this.overlap = 0.4,
    this.maxVisible,
    this.size = 40,
    this.overflowBuilder,
    this.direction,
    this.borderColor,
    this.borderWidth = 2,
  }) : assert(overlap >= 0 && overlap <= 1, 'overlap must be within 0..1'),
       assert(maxVisible == null || maxVisible > 0, 'maxVisible must be > 0');

  /// The avatars to display, in order.
  final List<Widget> avatars;

  /// The fraction (0..1) by which adjacent avatars overlap.
  final double overlap;

  /// How many avatars to show before collapsing the rest into a "+N"
  /// indicator. When `null`, all avatars are shown.
  final int? maxVisible;

  /// The diameter of each avatar slot in logical pixels.
  final double size;

  /// Builds a custom overflow indicator given the number of hidden avatars.
  final Widget Function(int overflowCount)? overflowBuilder;

  /// The layout direction. Defaults to the ambient [Directionality].
  final TextDirection? direction;

  /// The color of the separating ring around each avatar. Defaults to the
  /// theme's surface color.
  final Color? borderColor;

  /// The width of the separating ring.
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final TextDirection resolvedDirection =
        direction ?? Directionality.of(context);
    final Color ringColor =
        borderColor ?? Theme.of(context).colorScheme.surface;

    final bool hasOverflow = maxVisible != null && avatars.length > maxVisible!;
    final int visibleCount = hasOverflow ? maxVisible! : avatars.length;
    final int overflowCount = avatars.length - visibleCount;

    final List<Widget> slots = <Widget>[
      for (int i = 0; i < visibleCount; i++)
        _RingWrapper(color: ringColor, width: borderWidth, child: avatars[i]),
      if (hasOverflow)
        _RingWrapper(
          color: ringColor,
          width: borderWidth,
          child:
              overflowBuilder?.call(overflowCount) ??
              _OverflowIndicator(count: overflowCount, size: size),
        ),
    ];

    final double step = size * (1 - overlap);
    final int count = slots.length;
    final double totalWidth = count == 0 ? 0 : size + step * (count - 1);
    final bool isRtl = resolvedDirection == TextDirection.rtl;

    return SizedBox(
      width: totalWidth,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          // Paint later avatars first so earlier ones overlap on top.
          for (int i = count - 1; i >= 0; i--)
            Positioned(
              left: isRtl ? null : i * step,
              right: isRtl ? i * step : null,
              child: slots[i],
            ),
        ],
      ),
    );
  }
}

/// Wraps a child in a circular ring used to separate overlapping avatars.
class _RingWrapper extends StatelessWidget {
  const _RingWrapper({
    required this.child,
    required this.color,
    required this.width,
  });

  final Widget child;
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: width),
      ),
      child: child,
    );
  }
}

/// The default "+N" overflow indicator.
class _OverflowIndicator extends StatelessWidget {
  const _OverflowIndicator({required this.count, required this.size});

  final int count;
  final double size;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.surfaceContainerHighest,
      ),
      child: Text(
        '+$count',
        style: TextStyle(
          fontSize: size * 0.32,
          fontWeight: FontWeight.w600,
          color: colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
