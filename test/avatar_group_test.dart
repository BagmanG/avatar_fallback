import 'package:avatar_fallback/avatar_fallback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );
}

List<Widget> _avatars(int count) {
  return <Widget>[
    for (int i = 0; i < count; i++) AvatarFallback(name: 'User $i'),
  ];
}

void main() {
  testWidgets('shows all avatars when under maxVisible', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(AvatarGroup(avatars: _avatars(3), maxVisible: 5)),
    );

    expect(find.byType(AvatarFallback), findsNWidgets(3));
    expect(find.textContaining('+'), findsNothing);
  });

  testWidgets('collapses overflow into a "+N" indicator', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(AvatarGroup(avatars: _avatars(5), maxVisible: 3)),
    );

    // 3 visible avatars + one overflow slot.
    expect(find.byType(AvatarFallback), findsNWidgets(3));
    expect(find.text('+2'), findsOneWidget);
  });

  testWidgets('uses a custom overflowBuilder', (WidgetTester tester) async {
    await tester.pumpWidget(
      _wrap(
        AvatarGroup(
          avatars: _avatars(6),
          maxVisible: 2,
          overflowBuilder: (int count) => Text('and $count more'),
        ),
      ),
    );

    expect(find.text('and 4 more'), findsOneWidget);
  });

  testWidgets('no overflow indicator when maxVisible is null', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_wrap(AvatarGroup(avatars: _avatars(4))));

    expect(find.byType(AvatarFallback), findsNWidgets(4));
    expect(find.textContaining('+'), findsNothing);
  });
}
