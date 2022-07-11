part of 'register_bloc.dart';

abstract class RegisterEvent {
  const RegisterEvent();
}

class RegisterUsernameChanged extends RegisterEvent {
  const RegisterUsernameChanged(this.username);

  final String username;
}

class RegisterPasswordChanged extends RegisterEvent {
  const RegisterPasswordChanged(this.password);

  final String password;
}

class RegisterConfirmedPasswordChanged extends RegisterEvent {
  const RegisterConfirmedPasswordChanged(this.confirmedPassword);

  final String confirmedPassword;
}

class RegisterEmailChanged extends RegisterEvent {
  const RegisterEmailChanged(this.email);

  final String email;
}

class RegisterSubmission extends RegisterEvent {
  const RegisterSubmission();
}
