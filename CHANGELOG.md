## 0.1.0

Initial release.

- `AvatarFallback` widget with a convenience constructor (image + initials
  fallback) and an `AvatarFallback.sources` constructor for an explicit
  priority chain.
- `AvatarSource` sealed hierarchy: `ImageAvatarSource`, `NetworkAvatarSource`,
  `AssetAvatarSource`, `IconAvatarSource`, `WidgetAvatarSource`.
- Support for any `ImageProvider` (network, asset, memory, file, or a pluggable
  cache such as `CachedNetworkImageProvider`).
- Stable, deterministic background colors from names using an FNV-1a hash
  (not `String.hashCode`), with automatic contrasting text color.
- Unicode-correct, grapheme-safe initials that handle emoji, combining marks
  and RTL names.
- `AvatarShape` sealed type: `circle`, `square`, and `rounded(radius)`.
- `AvatarGroup` with overlap control and a customizable `+N` overflow indicator.
- Badge slot, accessibility semantics, and image fade-in.
- Material 3 theming via `AvatarFallbackTheme` (`ThemeExtension`).
- Zero heavy dependencies; works on Android, iOS, web, macOS, Windows and Linux.
