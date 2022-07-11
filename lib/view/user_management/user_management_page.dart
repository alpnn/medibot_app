import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medibot_app/bloc/user_management/user_management_bloc.dart';

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const UserManagementPage());
  }

  @override
  Widget build(BuildContext context) {
    context.read<UserManagementBloc>().add(UserManagementFetchListEvent());
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Management'),
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              context
                  .read<UserManagementBloc>()
                  .add(UserManagementFetchListEvent());
            },
            child: _UserList()));
  }
}

class _UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserManagementBloc, UserManagementState>(
        builder: (context, state) {
      return state.userList == null
          ? Stack(
              children: [
                ListView(),
                const Center(
                  child: Text('No data'),
                )
              ],
            )
          : ListView.builder(
              itemCount: state.userList!.length,
              itemBuilder: (context, index) => ListTile(
                    title: Text(state.userList![index].username),
                    subtitle: Text(state.userList![index].roles.join(', ')),
                  ));
    });
  }
}
