import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medibot_app/data/repository/authentication_repository.dart';
import 'package:medibot_app/model/user/user_profile.dart';
import 'package:medibot_app/data/api/user_client.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;
  final UserClient userClient;

  AuthenticationBloc(
      {required this.authenticationRepository, required this.userClient})
      : super(const AuthenticationState.unknown()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    authenticationRepository.status
        .listen((status) => add(AuthenticationStatusChanged(status)));
  }

  void _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        final user = await _tryGetUser();
        return emit(user != null
            ? AuthenticationState.authenticated(user)
            : const AuthenticationState.unauthenticated());
      default:
        return emit(const AuthenticationState.unknown());
    }
  }

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    authenticationRepository.logout();
  }

  Future<UserProfile?> _tryGetUser() async {
    try {
      return await userClient.getUserProfile();
    } catch (e) {
      return null;
    }
  }
}
