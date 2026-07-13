import 'package:flutter/material.dart';

import 'avatar_shape.dart';
import 'avatar_source.dart';
import 'avatar_theme.dart';
import 'color_from_seed.dart';
import 'default_palette.dart';
import 'initials.dart';

/// An avatar with a reliable fallback chain.
///
/// [AvatarFallback] tries to show an image and, if that fails, degrades
/// gracefully by priority all the way down to a terminal text fallback
/// (initials) drawn on a deterministically chosen colored background. The
/// terminal fallback can never itself fail.
///
/// The convenience constructor covers the common case (one image with an
/// initials fallback):
///
/// ```dart
/// AvatarFallback(
///   name: 'John Doe',
///   image: NetworkImage('https://example.com/john.png'),
/// );
/// ```
///
/// Use [AvatarFallback.sources] for an explicit priority chain of
/// [AvatarSource]s.
///
/// Defaults for [size], [shape], [palette], [textStyle], [border] and
/// [fadeInDuration] can be provided app-wide through an [AvatarFallbackTheme]
/// registered in [ThemeData.extensions]; values passed to the constructor
/// always take priority over the theme.
class AvatarFallback extends StatelessWidget {
  /// Creates an avatar that shows [image] (if any) and falls back to initials
  /// derived from [name].
  ///
  /// If [image] fails to load, the widget automatically shows the initials. If
  /// [image] is `null`, initials are shown immediately. If [name] is empty or
  /// whitespace-only, [emptyPlaceholder] is shown instead.
  const AvatarFallback({
    super.key,
    this.name,
    ImageProvider? image,
    this.size,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.palette,
    this.colorSeed,
    this.textStyle,
    this.border,
    this.badge,
    this.badgeAlignment = Alignment.bottomRight,
    this.maxInitials = 2,
    this.emptyPlaceholder = '?',
    this.semanticLabel,
    this.fadeInDuration,
    this.loadingBuilder,
  }) : _image = image,
       _sources = null;

  /// Creates an avatar from an explicit priority chain of [sources].
  ///
  /// Each source is tried in order; an image source that fails to load yields
  /// to the next. A terminal initials fallback derived from [name] is always
  /// present and cannot fail.
  const AvatarFallback.sources({
    super.key,
    required List<AvatarSource> sources,
    required String this.name,
    this.size,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.palette,
    this.colorSeed,
    this.textStyle,
    this.border,
    this.badge,
    this.badgeAlignment = Alignment.bottomRight,
    this.maxInitials = 2,
    this.emptyPlaceholder = '?',
    this.semanticLabel,
    this.fadeInDuration,
    this.loadingBuilder,
  }) : _sources = sources,
       _image = null;

  /// The name used to derive initials, the color seed, and the semantic label.
  final String? name;

  /// The avatar diameter in logical pixels.
  ///
  /// Falls back to [AvatarFallbackTheme.size] and then to `40`.
  final double? size;

  /// The avatar shape.
  ///
  /// Falls back to [AvatarFallbackTheme.shape] and then to
  /// [AvatarShape.circle].
  final AvatarShape? shape;

  /// Overrides the deterministic background color.
  final Color? backgroundColor;

  /// The color of the initials text. Defaults to an automatically chosen
  /// contrasting color (black or white) for the background.
  final Color? foregroundColor;

  /// The palette used to pick a deterministic background color.
  ///
  /// Falls back to [AvatarFallbackTheme.palette] and then to the built-in
  /// default palette.
  final List<Color>? palette;

  /// The string to hash for the deterministic color. Defaults to [name].
  final String? colorSeed;

  /// The text style for the initials.
  ///
  /// Merged on top of a size-derived base style and any
  /// [AvatarFallbackTheme.textStyle].
  final TextStyle? textStyle;

  /// An optional border drawn around the avatar.
  ///
  /// Falls back to [AvatarFallbackTheme.border].
  final BoxBorder? border;

  /// An optional badge (status dot, counter, …) overlaid on the avatar.
  final Widget? badge;

  /// Where the [badge] is aligned within the avatar bounds.
  final AlignmentGeometry badgeAlignment;

  /// The maximum number of initials to display.
  final int maxInitials;

  /// Shown when [name] yields no initials (empty or whitespace-only).
  final String emptyPlaceholder;

  /// The semantic label for accessibility. Defaults to [name].
  final String? semanticLabel;

  /// How long the image fades in once resolved.
  ///
  /// Falls back to [AvatarFallbackTheme.fadeInDuration] and then to 200ms.
  final Duration? fadeInDuration;

  /// Builder for the widget shown while an image is loading. Defaults to a
  /// light circular progress indicator.
  final WidgetBuilder? loadingBuilder;

  final ImageProvider? _image;
  final List<AvatarSource>? _sources;

  @override
  Widget build(BuildContext context) {
    final AvatarFallbackTheme? theme = Theme.of(
      context,
    ).extension<AvatarFallbackTheme>();

    final double resolvedSize = size ?? theme?.size ?? 40;
    final AvatarShape resolvedShape =
        shape ?? theme?.shape ?? const AvatarShape.circle();
    final List<Color> resolvedPalette =
        palette ?? theme?.palette ?? kDefaultAvatarPalette;
    final Duration resolvedFadeIn =
        fadeInDuration ??
        theme?.fadeInDuration ??
        const Duration(milliseconds: 200);
    final BoxBorder? resolvedBorder = border ?? theme?.border;

    final String seed = colorSeed ?? name ?? '';
    final Color background =
        backgroundColor ?? colorFromSeed(seed, resolvedPalette);
    final Color foreground = foregroundColor ?? contrastColorFor(background);

    final TextStyle resolvedTextStyle =
        TextStyle(
              fontSize: resolvedSize * 0.4,
              fontWeight: FontWeight.w600,
              height: 1,
            )
            .merge(theme?.textStyle)
            .merge(textStyle)
            .copyWith(
              color: foregroundColor ?? theme?.textStyle?.color ?? foreground,
            );

    final String initials = initialsFromName(
      name ?? '',
      maxInitials: maxInitials,
      emptyPlaceholder: emptyPlaceholder,
    );

    final Widget initialsContent = Center(
      child: Text(
        initials,
        style: resolvedTextStyle,
        textAlign: TextAlign.center,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.visible,
      ),
    );

    final List<AvatarSource> sources =
        _sources ??
        (_image != null
            ? <AvatarSource>[ImageAvatarSource(_image)]
            : const <AvatarSource>[]);

    final Widget content = sources.isEmpty
        ? initialsContent
        : _AvatarSourceChain(
            sources: sources,
            fallback: initialsContent,
            foregroundColor: foreground,
            fadeInDuration: resolvedFadeIn,
            loadingBuilder: loadingBuilder,
          );

    Widget avatar = _AvatarBox(
      size: resolvedSize,
      shape: resolvedShape,
      backgroundColor: background,
      border: resolvedBorder,
      child: content,
    );

    if (badge != null) {
      avatar = _AvatarWithBadge(
        alignment: badgeAlignment,
        badge: badge!,
        child: avatar,
      );
    }

    final String? label = semanticLabel ?? name;
    if (label != null && label.trim().isNotEmpty) {
      avatar = Semantics(
        label: label,
        image: sources.any(
          (AvatarSource s) => s.resolveImageProvider() != null,
        ),
        container: true,
        child: ExcludeSemantics(child: avatar),
      );
    }

    return avatar;
  }
}

/// The decorated, clipped container that gives the avatar its shape, background
/// and border.
class _AvatarBox extends StatelessWidget {
  const _AvatarBox({
    required this.size,
    required this.shape,
    required this.backgroundColor,
    required this.border,
    required this.child,
  });

  final double size;
  final AvatarShape shape;
  final Color backgroundColor;
  final BoxBorder? border;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: shape.isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: shape.isCircle ? null : shape.resolveBorderRadius(size),
        border: border,
      ),
      child: child,
    );
  }
}

/// Overlays a [badge] on top of the avatar without clipping it.
class _AvatarWithBadge extends StatelessWidget {
  const _AvatarWithBadge({
    required this.child,
    required this.badge,
    required this.alignment,
  });

  final Widget child;
  final Widget badge;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        child,
        Positioned.fill(
          child: Align(alignment: alignment, child: badge),
        ),
      ],
    );
  }
}

/// Walks the [sources] chain, advancing to the next source whenever an image
/// source fails to load, and rendering [fallback] once the chain is exhausted.
class _AvatarSourceChain extends StatefulWidget {
  const _AvatarSourceChain({
    required this.sources,
    required this.fallback,
    required this.foregroundColor,
    required this.fadeInDuration,
    required this.loadingBuilder,
  });

  final List<AvatarSource> sources;
  final Widget fallback;
  final Color foregroundColor;
  final Duration fadeInDuration;
  final WidgetBuilder? loadingBuilder;

  @override
  State<_AvatarSourceChain> createState() => _AvatarSourceChainState();
}

class _AvatarSourceChainState extends State<_AvatarSourceChain> {
  int _index = 0;
  bool _advanceScheduled = false;

  @override
  void didUpdateWidget(_AvatarSourceChain oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sources != widget.sources) {
      _index = 0;
      _advanceScheduled = false;
    }
  }

  void _scheduleAdvance() {
    if (_advanceScheduled) {
      return;
    }
    _advanceScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _index++;
        _advanceScheduled = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_index >= widget.sources.length) {
      return widget.fallback;
    }

    final AvatarSource source = widget.sources[_index];
    final ImageProvider? provider = source.resolveImageProvider();
    if (provider != null) {
      return _buildImage(provider);
    }

    return switch (source) {
      IconAvatarSource(:final IconData icon, :final Color? color) => Center(
        child: Icon(icon, color: color ?? widget.foregroundColor),
      ),
      WidgetAvatarSource(:final Widget child) => child,
      _ => widget.fallback,
    };
  }

  Widget _buildImage(ImageProvider provider) {
    return Image(
      image: provider,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      gaplessPlayback: true,
      frameBuilder:
          (
            BuildContext context,
            Widget child,
            int? frame,
            bool wasSynchronouslyLoaded,
          ) {
            if (wasSynchronouslyLoaded) {
              return child;
            }
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: widget.fadeInDuration,
              curve: Curves.easeOut,
              child: child,
            );
          },
      loadingBuilder:
          (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) {
              return child;
            }
            return widget.loadingBuilder?.call(context) ??
                const _DefaultLoader();
          },
      errorBuilder: (BuildContext context, Object error, StackTrace? stack) {
        _scheduleAdvance();
        // While advancing to the next source, show nothing so the background
        // shows through instead of flashing the terminal initials.
        return const SizedBox.expand();
      },
    );
  }
}

/// A light, centered progress indicator shown while an image loads.
class _DefaultLoader extends StatelessWidget {
  const _DefaultLoader();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
