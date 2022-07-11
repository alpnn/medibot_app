part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState(
      {this.status = FormzStatus.pure,
      this.email = const Email.pure(),
      this.username = const Username.pure(),
      this.password = const Password.pure(),
      this.confirmedPassword = const ConfirmedPassword.pure(),
      this.error});

  final FormzStatus status;
  final Email email;
  final Username username;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final MedibotError? error;

  RegisterState copyWith(
      {FormzStatus? status,
      Username? username,
      Password? password,
      ConfirmedPassword? confirmedPassword,
      Email? email,
      MedibotError? error}) {
    return RegisterState(
        status: status ?? this.status,
        username: username ?? this.username,
        password: password ?? this.password,
        confirmedPassword: confirmedPassword ?? this.confirmedPassword,
        email: email ?? this.email,
        error: error ?? this.error);
  }

  @override
  List<Object?> get props => [status, username, password, confirmedPassword, email, error];
}
