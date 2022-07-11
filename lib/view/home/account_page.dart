import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medibot_app/bloc/authentication/authentication_bloc.dart';
import 'package:medibot_app/view/intent_management/intent_management_page.dart';
import 'package:medibot_app/view/patient_management/patient_management_page.dart';
import 'package:medibot_app/view/setting/setting.dart';
import 'package:medibot_app/view/user_management/user_management_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return ListView(
          children: [
            if (state.isAdmin)
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).push(PatientManagementPage.route()),
                child: const ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Patient management'),
                ),
              ),
            if (state.isAdmin)
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).push(UserManagementPage.route()),
                child: const ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('User management'),
                ),
              ),
            if (state.isAdmin)
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).push(IntentManagementPage.route()),
                child: const ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Intent management'),
                ),
              ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(SettingPage.route()),
              child: const ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
            ),
          ],
        );
      },
    );
  }
}
