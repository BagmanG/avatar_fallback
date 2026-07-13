/// An avatar widget with a reliable fallback chain: it tries to show an image
/// from any [ImageProvider] and, if that fails, degrades by priority all the
/// way down to initials on a deterministically colored background that can
/// never fail.
///
/// Highlights:
///
/// * Accepts any `ImageProvider` (network, asset, memory, file, or a pluggable
///   cache like `CachedNetworkImageProvider`) — not just URLs.
/// * A real priority chain via [AvatarFallback.sources] and [AvatarSource].
/// * Stable, deterministic colors from names (FNV-1a hash, not `hashCode`).
/// * Unicode-correct, grapheme-safe initials.
/// * Material 3 theming through [AvatarFallbackTheme] ([ThemeExtension]).
/// * [AvatarGroup] with a "+N" overflow indicator.
/// * A badge slot, accessibility semantics, and image fade-in.
///
/// ```dart
/// AvatarFallback(
///   name: 'John Doe',
///   image: NetworkImage('https://example.com/john.png'),
/// );
/// ```
library;

export 'src/avatar_fallback.dart';
export 'src/avatar_group.dart';
export 'src/avatar_shape.dart';
export 'src/avatar_source.dart';
export 'src/avatar_theme.dart';
export 'src/color_from_seed.dart'
    show colorFromSeed, contrastColorFor, stableHash;
export 'src/default_palette.dart' show kDefaultAvatarPalette;
export 'src/initials.dart' show initialsFromName;
