# avatar_fallback

[![pub version](https://img.shields.io/pub/v/avatar_fallback.svg)](https://pub.dev/packages/avatar_fallback)
[![pub likes](https://img.shields.io/pub/likes/avatar_fallback)](https://pub.dev/packages/avatar_fallback)
[![pub points](https://img.shields.io/pub/points/avatar_fallback)](https://pub.dev/packages/avatar_fallback)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

An avatar widget with a **reliable fallback chain**. It tries to show an image
from *any* `ImageProvider` and, if that fails, degrades by priority all the way
down to initials on a deterministically chosen colored background — a terminal
fallback that can never fail.

![avatar_fallback initials and deterministic colors](https://raw.githubusercontent.com/BagmanG/avatar_fallback/main/doc/screenshots/initials.png)

![avatar_fallback group with overflow](https://raw.githubusercontent.com/BagmanG/avatar_fallback/main/doc/screenshots/group.png)

## Why another avatar package?

| Feature | `avatar_fallback` | Typical alternatives |
| --- | --- | --- |
| Any `ImageProvider` (network / asset / memory / file) | ✅ | Often network-URL only |
| Real multi-step priority chain | ✅ | Usually image + single placeholder |
| Deterministic color, stable across runs & platforms | ✅ (FNV-1a, not `hashCode`) | Often `String.hashCode` (unstable) |
| Unicode-correct, grapheme-safe initials (emoji, RTL) | ✅ | Frequently `substring` (breaks emoji) |
| Material 3 theming via `ThemeExtension` | ✅ | Rare |
| `AvatarGroup` with `+N` overflow | ✅ | Sometimes |
| Badge slot, a11y semantics, image fade-in | ✅ | Partial |
| Zero heavy dependencies; all platforms | ✅ | Varies |

## Features

- 🖼 **Any image source** — pass any `ImageProvider`, or use `AvatarSource`
  for network / asset / icon / widget sources.
- 🔁 **Priority chain** — sources are tried in order; a failing image yields to
  the next, ending in initials that cannot fail.
- 🎨 **Stable deterministic colors** — the same name always gets the same color,
  on every device and every run (FNV-1a hash — **not** `hashCode`).
- 🔤 **Grapheme-safe initials** — emoji and combining marks are never split;
  RTL names work correctly.
- 🎛 **Material 3 theming** — set app-wide defaults with `AvatarFallbackTheme`.
- 👥 **`AvatarGroup`** — overlapping avatars with a customizable `+N` indicator.
- 🟢 **Badge slot** — overlay a status dot, counter, or anything else.
- ♿ **Accessibility** — a semantic label is exposed for screen readers.
- ✨ **Fade-in** — images fade in smoothly once resolved.
- 🪶 **Lightweight** — depends only on Flutter (+ `characters`). Works on
  Android, iOS, web, macOS, Windows and Linux.

## Installation

```yaml
dependencies:
  avatar_fallback: ^0.1.0
```

Then:

```dart
import 'package:avatar_fallback/avatar_fallback.dart';
```

## Quick start

```dart
AvatarFallback(
  name: 'John Doe',
  image: NetworkImage('https://example.com/john.png'),
);
```

If the image fails to load, the widget shows `JD` on a color deterministically
derived from the name. If no image is given, the initials show immediately.

## Cookbook

### 1. Initials only

```dart
AvatarFallback(name: 'Ada Lovelace'); // "AL" on a stable color
```

### 2. Custom size and shape

```dart
AvatarFallback(
  name: 'Grace Hopper',
  size: 64,
  shape: const AvatarShape.rounded(16), // or .square() / .circle()
);
```

### 3. A custom palette

```dart
AvatarFallback(
  name: 'Katherine Johnson',
  palette: const <Color>[Color(0xFF264653), Color(0xFF2A9D8F)],
);
```

### 4. A status badge

```dart
AvatarFallback(
  name: 'Online User',
  badge: Container(
    width: 14,
    height: 14,
    decoration: BoxDecoration(
      color: Colors.green,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 2),
    ),
  ),
);
```

### 5. An explicit source chain

```dart
AvatarFallback.sources(
  name: 'Chain Demo',
  sources: const <AvatarSource>[
    NetworkAvatarSource('https://primary.example/pic.png'),
    AssetAvatarSource('assets/fallback.png'),
    IconAvatarSource(Icons.person), // never "fails"
  ],
);
```

### 6. A group with overflow

```dart
AvatarGroup(
  maxVisible: 3,
  avatars: <Widget>[
    for (final String name in names) AvatarFallback(name: name),
  ],
);
```

### 7. Deterministic color, decoupled from the widget

```dart
final Color color = colorFromSeed('john@example.com', kDefaultAvatarPalette);
final String initials = initialsFromName('John Doe'); // "JD"
```

## Theming

Set app-wide defaults with `AvatarFallbackTheme` in `ThemeData.extensions`.
Any value you pass directly to an `AvatarFallback` overrides the theme.

```dart
MaterialApp(
  theme: ThemeData(
    extensions: const <ThemeExtension<dynamic>>[
      AvatarFallbackTheme(
        size: 48,
        shape: AvatarShape.rounded(12),
        fadeInDuration: Duration(milliseconds: 250),
      ),
    ],
  ),
);
```

## Pluggable caching

The package intentionally does **not** depend on `cached_network_image`. To add
caching, just pass a caching `ImageProvider`:

```dart
AvatarFallback(
  name: 'John Doe',
  image: CachedNetworkImageProvider('https://example.com/john.png'),
);
```

Or inside a source chain with `ImageAvatarSource(CachedNetworkImageProvider(...))`.
This keeps the package lightweight and lets you choose your own caching strategy.

## Example

A full showcase app lives in [`example/`](example/lib/main.dart), covering every
feature. Run it with:

```bash
cd example
flutter run
```

## Contributing

Issues and pull requests are welcome. Please run `dart format .`,
`dart analyze`, and `flutter test` before submitting.

## License

[MIT](LICENSE)
