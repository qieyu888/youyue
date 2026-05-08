import 'package:flutter_test/flutter_test.dart';
import 'package:yoru/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const YoruApp());
    expect(find.byType(YoruApp), findsOneWidget);
  });
}
