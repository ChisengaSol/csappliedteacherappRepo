import 'package:csappliedteacherapp/src/screens/home/subject_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestTableWidget({Widget child}) {
    return MaterialApp(
              home: child,
            );
  }

  testWidgets("", (WidgetTester tester) async {
    //await tester.pumpWidget();
    SubjectsList subjectScreen = SubjectsList();
    await tester.pumpWidget(makeTestTableWidget(child: subjectScreen));
  });
}