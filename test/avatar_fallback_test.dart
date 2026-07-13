import 'package:avatar_fallback/avatar_fallback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// An [ImageProvider] whose load always fails, used to exercise the fallback.
class _FailingImageProvider extends ImageProvider<_FailingImageProvider> {
  @override
  Future<_FailingImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<_FailingImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    _FailingImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return OneFrameImageStreamCompleter(
      Future<ImageInfo>.error(Exception('failed to load')),
    );
  }
}

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  testWidgets('renders initials when no image is given', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_wrap(const AvatarFallback(name: 'John Doe')));

    expect(find.text('JD'), findsOneWidget);
  });

  testWidgets('shows empty placeholder for blank name', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const AvatarFallback(name: '   ', emptyPlaceholder: '?')),
    );

    expect(find.text('?'), findsOneWidget);
  });

  testWidgets('degrades to initials when the image fails to load', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(AvatarFallback(name: 'Jane Roe', image: _FailingImageProvider())),
    );

    // Let the failing image resolve and the fallback advance to run.
    await tester.pumpAndSettle();

    expect(find.text('JR'), findsOneWidget);
  });

  testWidgets('degrades through an explicit source chain', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        AvatarFallback.sources(
          name: 'Ada Lovelace',
          sources: <AvatarSource>[
            ImageAvatarSource(_FailingImageProvider()),
            ImageAvatarSource(_FailingImageProvider()),
          ],
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('AL'), findsOneWidget);
  });

  testWidgets('exposes a semantic label', (WidgetTester tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();

    await tester.pumpWidget(_wrap(const AvatarFallback(name: 'John Doe')));

    expect(find.bySemanticsLabel('John Doe'), findsOneWidget);

    handle.dispose();
  });

  testWidgets('semanticLabel overrides name for accessibility', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();

    await tester.pumpWidget(
      _wrap(
        const AvatarFallback(name: 'John Doe', semanticLabel: 'Profile photo'),
      ),
    );

    expect(find.bySemanticsLabel('Profile photo'), findsOneWidget);

    handle.dispose();
  });

  testWidgets('explicit backgroundColor overrides deterministic color', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const AvatarFallback(
          name: 'John Doe',
          backgroundColor: Color(0xFF123456),
        ),
      ),
    );

    final Container container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(AvatarFallback),
            matching: find.byType(Container),
          )
          .first,
    );
    final BoxDecoration decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, const Color(0xFF123456));
  });

  testWidgets('renders a badge when provided', (WidgetTester tester) async {
    await tester.pumpWidget(
      _wrap(
        const AvatarFallback(
          name: 'John Doe',
          badge: Icon(Icons.circle, key: Key('badge')),
        ),
      ),
    );

    expect(find.byKey(const Key('badge')), findsOneWidget);
  });

  testWidgets('reads defaults from AvatarFallbackTheme', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: const <ThemeExtension<dynamic>>[
            AvatarFallbackTheme(size: 80),
          ],
        ),
        home: const Scaffold(
          body: Center(child: AvatarFallback(name: 'John Doe')),
        ),
      ),
    );

    final Container container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(AvatarFallback),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(container.constraints?.maxWidth, 80);
  });
}
