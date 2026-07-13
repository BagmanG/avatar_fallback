import 'package:avatar_fallback/avatar_fallback.dart';
import 'package:flutter/material.dart';

void main() => runApp(const AvatarFallbackExampleApp());

/// The demo application showcasing every feature of `avatar_fallback`.
class AvatarFallbackExampleApp extends StatelessWidget {
  /// Creates the example app.
  const AvatarFallbackExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'avatar_fallback demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        // App-wide avatar defaults via ThemeExtension.
        extensions: const <ThemeExtension<dynamic>>[
          AvatarFallbackTheme(fadeInDuration: Duration(milliseconds: 250)),
        ],
      ),
      home: const _ShowcasePage(),
    );
  }
}

// A deliberately broken URL, used to demonstrate the fallback to initials.
const String _brokenUrl = 'https://example.invalid/does-not-exist.png';

class _ShowcasePage extends StatelessWidget {
  const _ShowcasePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('avatar_fallback')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const <Widget>[
          _Section(
            title: '1. Network image with fallback',
            description:
                'A broken URL degrades automatically to initials on a '
                'deterministic color.',
            child: _NetworkFallbackDemo(),
          ),
          _Section(
            title: '2. Initials only',
            description: 'No image — each name maps to a stable, unique color.',
            child: _InitialsDemo(),
          ),
          _Section(
            title: '3. Custom palette',
            description: 'Provide your own colors for the deterministic hash.',
            child: _CustomPaletteDemo(),
          ),
          _Section(
            title: '4. Shapes',
            description: 'circle / square / rounded.',
            child: _ShapesDemo(),
          ),
          _Section(
            title: '5. Status badge',
            description: 'A green online dot overlaid on the avatar.',
            child: _BadgeDemo(),
          ),
          _Section(
            title: '6. Avatar group with "+N"',
            description: 'Overlapping avatars collapse into an overflow chip.',
            child: _GroupDemo(),
          ),
          _Section(
            title: '7. Explicit source chain',
            description:
                'Two broken images, then an icon fallback — tried in order.',
            child: _SourceChainDemo(),
          ),
          _Section(
            title: '8. Themed defaults (rounded, larger)',
            description:
                'A nested Theme sets rounded shape and size 64 for all avatars.',
            child: _ThemedDemo(),
          ),
        ],
      ),
    );
  }
}

class _NetworkFallbackDemo extends StatelessWidget {
  const _NetworkFallbackDemo();

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 16,
      children: <Widget>[
        AvatarFallback(
          name: 'Grace Hopper',
          image: NetworkImage(_brokenUrl),
          size: 56,
        ),
        AvatarFallback(
          name: 'Alan Turing',
          image: NetworkImage(_brokenUrl),
          size: 56,
        ),
      ],
    );
  }
}

class _InitialsDemo extends StatelessWidget {
  const _InitialsDemo();

  @override
  Widget build(BuildContext context) {
    const List<String> names = <String>[
      'John Doe',
      'Jane Smith',
      'محمد علي',
      'David Cohen',
      'A',
      '',
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        for (final String name in names) AvatarFallback(name: name, size: 48),
      ],
    );
  }
}

class _CustomPaletteDemo extends StatelessWidget {
  const _CustomPaletteDemo();

  @override
  Widget build(BuildContext context) {
    const List<Color> palette = <Color>[
      Color(0xFF264653),
      Color(0xFF2A9D8F),
      Color(0xFFE9C46A),
      Color(0xFFF4A261),
      Color(0xFFE76F51),
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        for (final String name in <String>['Rio', 'Nadia', 'Sven', 'Ola'])
          AvatarFallback(name: name, palette: palette, size: 48),
      ],
    );
  }
}

class _ShapesDemo extends StatelessWidget {
  const _ShapesDemo();

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 16,
      children: <Widget>[
        AvatarFallback(name: 'Circle', size: 56),
        AvatarFallback(name: 'Square', size: 56, shape: AvatarShape.square()),
        AvatarFallback(
          name: 'Rounded',
          size: 56,
          shape: AvatarShape.rounded(16),
        ),
      ],
    );
  }
}

class _BadgeDemo extends StatelessWidget {
  const _BadgeDemo();

  @override
  Widget build(BuildContext context) {
    return AvatarFallback(
      name: 'Online User',
      size: 64,
      badge: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}

class _GroupDemo extends StatelessWidget {
  const _GroupDemo();

  @override
  Widget build(BuildContext context) {
    return AvatarGroup(
      maxVisible: 4,
      size: 48,
      avatars: <Widget>[
        for (final String name in <String>[
          'Ada Lovelace',
          'Grace Hopper',
          'Katherine Johnson',
          'Alan Turing',
          'Linus Torvalds',
          'Margaret Hamilton',
        ])
          AvatarFallback(name: name, size: 48),
      ],
    );
  }
}

class _SourceChainDemo extends StatelessWidget {
  const _SourceChainDemo();

  @override
  Widget build(BuildContext context) {
    return const AvatarFallback.sources(
      name: 'Chain Demo',
      size: 64,
      sources: <AvatarSource>[
        NetworkAvatarSource(_brokenUrl),
        NetworkAvatarSource(_brokenUrl),
        IconAvatarSource(Icons.person),
      ],
    );
  }
}

class _ThemedDemo extends StatelessWidget {
  const _ThemedDemo();

  @override
  Widget build(BuildContext context) {
    final ThemeData base = Theme.of(context);
    return Theme(
      data: base.copyWith(
        extensions: <ThemeExtension<dynamic>>[
          const AvatarFallbackTheme(size: 64, shape: AvatarShape.rounded(20)),
        ],
      ),
      child: const Wrap(
        spacing: 12,
        runSpacing: 12,
        children: <Widget>[
          AvatarFallback(name: 'Theme One'),
          AvatarFallback(name: 'Theme Two'),
          AvatarFallback(name: 'Theme Three'),
        ],
      ),
    );
  }
}

/// A titled, described section wrapping one demo.
class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(description, style: textTheme.bodySmall),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
