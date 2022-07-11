import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:medibot_app/data/repository/authentication_repository.dart';
import 'package:medibot_app/model/error.dart';
import 'package:medibot_app/model/form/confirm_password.dart';
import 'package:medibot_app/model/form/email.dart';
import 'package:medibot_app/model/form/password.dart';
import 'package:medibot_app/model/form/username.dart';
import 'package:medibot_app/model/form/confirm_password.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthenticationRepository _authenticationRepository;

  RegisterBloc({required authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const RegisterState()) {
    on<RegisterUsernameChanged>(_onUsernameChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterConfirmedPasswordChanged>(_onConfirmedPasswordChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterSubmission>(_onRegister);
  }

  void _onEmailChanged(
      RegisterEmailChanged event, Emitter<RegisterState> emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
        email: email,
        status: Formz.validate(
            [email, state.username, state.password, state.confirmedPassword])));
  }

  void _onUsernameChanged(
      RegisterUsernameChanged event, Emitter<RegisterState> emit) {
    final username = Username.dirty(event.username);
    emit(state.copyWith(
        username: username,
        status: Formz.validate(
            [state.email, username, state.password, state.confirmedPassword])));
  }

  void _onPasswordChanged(
      RegisterPasswordChanged event, Emitter<RegisterState> emit) {
    final password = Password.dirty(event.password);
    final confirmedPassword = ConfirmedPassword.dirty(
        state.confirmedPassword.value,
        password: password.value);
    emit(state.copyWith(
        password: password,
        confirmedPassword: confirmedPassword,
        status: Formz.validate(
            [state.email, state.username, password, confirmedPassword])));
  }

  void _onConfirmedPasswordChanged(
      RegisterConfirmedPasswordChanged event, Emitter<RegisterState> emit) {
    final confirmedPassword = ConfirmedPassword.dirty(event.confirmedPassword,
        password: state.password.value);
    emit(state.copyWith(
        confirmedPassword: confirmedPassword,
        status: Formz.validate(
            [state.email, state.username, state.password, confirmedPassword])));
  }

  void _onRegister(
      RegisterSubmission event, Emitter<RegisterState> emit) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        await _authenticationRepository.register(
            email: state.email.value,
            username: state.username.value,
            password: state.password.value);
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } on MedibotError catch (e) {
        emit(state.copyWith(status: FormzStatus.submissionFailure, error: e));
      }
    }
  }
}
