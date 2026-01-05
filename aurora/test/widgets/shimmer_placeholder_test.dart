import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurora/views/widgets/shimmer_placeholder.dart';

void main() {
  group('ShimmerPlaceholder Widget Tests', () {
    testWidgets('Renders with correct size', (WidgetTester tester) async {
      const testSize = 300.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerPlaceholder(size: testSize),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(ShimmerPlaceholder),
          matching: find.byType(Container),
        ).first,
      );

      expect(container.constraints?.maxWidth, testSize);
      expect(container.constraints?.maxHeight, testSize);
    });

    testWidgets('Contains Shimmer widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerPlaceholder(size: 300),
          ),
        ),
      );

      expect(find.byType(ShimmerPlaceholder), findsOneWidget);
    });
  });
}

