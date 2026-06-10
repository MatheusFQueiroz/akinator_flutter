import 'package:flutter_test/flutter_test.dart';
import 'package:akinator_mobile/main.dart';

void main() {
  testWidgets('Akinator app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AkinatorApp());
    expect(find.text('Quem é o Professor?'), findsOneWidget);
    expect(find.text('Começar'), findsOneWidget);
  });
}
