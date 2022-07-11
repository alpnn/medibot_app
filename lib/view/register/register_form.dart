import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:medibot_app/bloc/register/register_bloc.dart';
import 'package:medibot_app/widget/line_input.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.error?.message ?? "unknown error")),
            );
        }
        if (state.status.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Signup succeeded')),
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
            child: BlocBuilder<RegisterBloc, RegisterState>(
              buildWhen: (previous, current) => previous.email != current.email,
              builder: (context, state) {
                return SingleLineTextInput(
                    textInputType: TextInputType.text,
                    labelText: "Email address",
                    errorText: state.email.invalid ? 'invalid email' : null,
                    obscureText: false,
                    onChange: (email) => {
                          context
                              .read<RegisterBloc>()
                              .add(RegisterEmailChanged(email))
                        });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: BlocBuilder<RegisterBloc, RegisterState>(
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
                              .read<RegisterBloc>()
                              .add(RegisterUsernameChanged(username))
                        });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: BlocBuilder<RegisterBloc, RegisterState>(
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
                              .read<RegisterBloc>()
                              .add(RegisterPasswordChanged(password))
                        });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: BlocBuilder<RegisterBloc, RegisterState>(
              buildWhen: (previous, current) =>
                  previous.confirmedPassword != current.confirmedPassword,
              builder: (context, state) {
                return SingleLineTextInput(
                    textInputType: TextInputType.text,
                    labelText: "Confirm password",
                    errorText: state.confirmedPassword.invalid
                        ? 'invalid confirmed password'
                        : null,
                    obscureText: true,
                    onChange: (confirmedPassword) => {
                          context.read<RegisterBloc>().add(
                              RegisterConfirmedPasswordChanged(
                                  confirmedPassword))
                        });
              },
            ),
          ),
          const _SubmitButton(),
          _SigninButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
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
                                .read<RegisterBloc>()
                                .add(const RegisterSubmission());
                          }
                        : null,
                    child: const Text("Sign Up")));
      },
    );
  }
}

class _SigninButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SigninButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child:
            OutlinedButton(onPressed: onPressed, child: const Text("Sign In")));
  }
}
