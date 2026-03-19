import 'package:flutter_test/flutter_test.dart';
import 'package:uzii_shop/main.dart';

void main() {
  testWidgets('UziiShop smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const UziiShopApp());
    expect(find.text('UziiShop'), findsOneWidget);
  });
}
