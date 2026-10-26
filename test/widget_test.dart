import 'package:flutter_test/flutter_test.dart';
import 'package:dlms_app/app/app.dart';

void main() {
  testWidgets('DLMSApp root smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DLMSApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(DLMSApp), findsOneWidget);
  });
}
