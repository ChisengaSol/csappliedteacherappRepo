import 'package:csappliedteacherapp/src/screens/authenticate/login.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("", () {});

  test("empty email returns error string", () {
    var result = EmailFieldValidator.validate('');
    expect(result, "Email can\'t be empty");
  });

  test("non-empty email returns null", (){
    var result = EmailFieldValidator.validate('email');
    expect(result, null);
  });

  test("empty password returns error string", () {
    var result = PasswordFieldValidator.validate('');
    expect(result, "Password should have more than 8 characters");
  });

  test("non-empty password returns null", (){
    var result = PasswordFieldValidator.validate('password');
    expect(result, null);
  });
}
