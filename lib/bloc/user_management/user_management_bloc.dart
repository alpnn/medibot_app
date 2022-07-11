import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medibot_app/model/user/user_profile.dart';
import 'package:medibot_app/data/api/user_client.dart';

class UserManagementBloc
    extends Bloc<UserManagementEvent, UserManagementState> {
  final UserClient userClient;

  UserManagementBloc({required this.userClient})
      : super(UserManagementState()) {
    on<UserManagementFetchListEvent>(_onUserManagementFetchListEvent);
  }

  void _onUserManagementFetchListEvent(UserManagementFetchListEvent event,
      Emitter<UserManagementState> emit) async {
    emit(UserManagementState(userList: await userClient.listUser()));
  }
}

abstract class UserManagementEvent {}

class UserManagementFetchListEvent extends UserManagementEvent {}

class UserManagementState {
  final List<UserProfile>? userList;

  UserManagementState({this.userList});
}
