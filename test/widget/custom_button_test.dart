import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dlms_app/core/widgets/custom_button.dart';

void main() {
  testWidgets('CustomButton renders text and triggers callback', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Submit Quiz',
            onPressed: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Submit Quiz'), findsOneWidget);
    await tester.tap(find.text('Submit Quiz'));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('CustomButton displays loading spinner when isLoading is true', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Loading Action',
            isLoading: true,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading Action'), findsNothing);
  });
}
