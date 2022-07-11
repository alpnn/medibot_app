part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState(
      {this.status = FormzStatus.pure,
      this.username = const Username.pure(),
      this.password = const Password.pure(),
      this.error});

  final FormzStatus status;
  final Username username;
  final Password password;
  final MedibotError? error;

  LoginState copyWith(
      {FormzStatus? status,
      Username? username,
      Password? password,
      MedibotError? error}) {
    return LoginState(
        status: status ?? this.status,
        username: username ?? this.username,
        password: password ?? this.password,
        error: error ?? this.error);
  }

  @override
  List<Object?> get props => [status, username, password, error];
}
