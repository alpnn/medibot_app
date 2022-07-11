import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medibot_app/bloc/register/register_bloc.dart';
import 'package:medibot_app/data/repository/authentication_repository.dart';
import 'package:medibot_app/view/register/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const RegisterPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: ((context) => RegisterBloc(
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context))),
        child: const RegisterForm(),
      ),
    );
  }
}
