import 'package:csappliedteacherapp/src/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("", (WidgetTester tester) async {
    await tester.pumpWidget(new App());
  });
}
