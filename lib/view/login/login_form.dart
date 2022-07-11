import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:medibot_app/bloc/login/login_bloc.dart';
import 'package:medibot_app/view/register/register_page.dart';
import 'package:medibot_app/widget/line_input.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.error?.message ?? "unknown error")),
            );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("MediBot", style: TextStyle(fontSize: 52)),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (previous, current) =>
                  previous.username != current.username,
              builder: (context, state) {
                return SingleLineTextInput(
                    textInputType: TextInputType.text,
                    labelText: "Username",
                    errorText:
                        state.username.invalid ? 'invalid username' : null,
                    obscureText: false,
                    onChange: (username) => {
                          context
                              .read<LoginBloc>()
                              .add(LoginUsernameChanged(username))
                        });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (previous, current) =>
                  previous.password != current.password,
              builder: (context, state) {
                return SingleLineTextInput(
                    textInputType: TextInputType.text,
                    labelText: "Password",
                    errorText:
                        state.password.invalid ? 'invalid password' : null,
                    obscureText: true,
                    onChange: (password) => {
                          context
                              .read<LoginBloc>()
                              .add(LoginPasswordChanged(password))
                        });
              },
            ),
          ),
          const _SubmitButton(),
          _SignupButton(onPressed: () {
            Navigator.of(context).push(RegisterPage.route());
          })
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Container(
            height: 40,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: state.status.isSubmissionInProgress
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: state.status.isValidated
                        ? () {
                            context
                                .read<LoginBloc>()
                                .add(const LoginSubmission());
                          }
                        : null,
                    child: const Text("Sign In")));
      },
    );
  }
}

class _SignupButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SignupButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child:
            OutlinedButton(onPressed: onPressed, child: const Text("Sign Up")));
  }
}
