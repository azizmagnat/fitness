import 'package:flutter_test/flutter_test.dart';

import 'package:onefit_app/main.dart';

void main() {
  testWidgets('App boots and shows splash', (WidgetTester tester) async {
    await tester.pumpWidget(const OneFitApp());
    expect(find.text('1FIT'), findsOneWidget);
  });
}
