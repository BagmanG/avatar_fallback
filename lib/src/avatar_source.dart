import 'package:flutter/widgets.dart';

/// A single candidate to display inside an avatar.
///
/// Sources are tried in order (see `AvatarFallback.sources`). An image source
/// that fails to load automatically yields to the next source in the chain. The
/// widget always keeps a terminal text fallback (initials) that cannot fail.
sealed class AvatarSource {
  /// Const base constructor for subclasses.
  const AvatarSource();

  /// The [ImageProvider] this source resolves to, or `null` for sources that
  /// render directly (icons, widgets) rather than loading an image.
  ImageProvider? resolveImageProvider() => null;
}

/// An avatar source backed by any [ImageProvider].
///
/// This is the most flexible source: pass `NetworkImage`, `AssetImage`,
/// `MemoryImage`, `FileImage`, or a pluggable provider such as
/// `CachedNetworkImageProvider`.
class ImageAvatarSource extends AvatarSource {
  /// Creates a source from an existing [provider].
  const ImageAvatarSource(this.provider);

  /// The image provider to display.
  final ImageProvider provider;

  @override
  ImageProvider resolveImageProvider() => provider;
}

/// A convenience source that loads an image from a network [url].
class NetworkAvatarSource extends AvatarSource {
  /// Creates a network source for [url], with optional request [headers].
  const NetworkAvatarSource(this.url, {this.headers});

  /// The URL to load the image from.
  final String url;

  /// Optional HTTP headers sent with the request.
  final Map<String, String>? headers;

  @override
  ImageProvider resolveImageProvider() => NetworkImage(url, headers: headers);
}

/// A convenience source that loads an image from a bundled asset.
class AssetAvatarSource extends AvatarSource {
  /// Creates an asset source for [assetPath].
  const AssetAvatarSource(this.assetPath, {this.bundle, this.package});

  /// The asset key/path.
  final String assetPath;

  /// The bundle to load from. Defaults to the root bundle when `null`.
  final AssetBundle? bundle;

  /// The package the asset belongs to, if any.
  final String? package;

  @override
  ImageProvider resolveImageProvider() =>
      AssetImage(assetPath, bundle: bundle, package: package);
}

/// A terminal source that renders an [icon] instead of initials.
///
/// Icons do not "fail", so any sources after an [IconAvatarSource] are never
/// reached.
class IconAvatarSource extends AvatarSource {
  /// Creates an icon source.
  const IconAvatarSource(this.icon, {this.color});

  /// The icon to render.
  final IconData icon;

  /// The icon color. Defaults to the resolved foreground color when `null`.
  final Color? color;
}

/// A terminal source that renders an arbitrary [child] widget.
///
/// Like [IconAvatarSource], a widget source never "fails", so any sources after
/// it are never reached.
class WidgetAvatarSource extends AvatarSource {
  /// Creates a widget source.
  const WidgetAvatarSource(this.child);

  /// The widget to render inside the avatar.
  final Widget child;
}
