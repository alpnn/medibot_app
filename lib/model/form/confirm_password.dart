import 'package:formz/formz.dart';

enum ConfirmedPasswordValidationError { empty, mismatch }

class ConfirmedPassword extends FormzInput<String, ConfirmedPasswordValidationError> {
  final String password;
  
  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');

  const ConfirmedPassword.dirty(String value, {required this.password}) : super.dirty(value);

  @override
  ConfirmedPasswordValidationError? validator(String value) {
    if(value.isEmpty){
      return ConfirmedPasswordValidationError.empty;
    }
    if(value != password){
      return ConfirmedPasswordValidationError.mismatch;
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is ConfirmedPassword &&
        other.value == value &&
        other.pure == pure &&
        other.password == password
    ;
  }
}
