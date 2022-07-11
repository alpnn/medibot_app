import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medibot_app/bloc/authentication/authentication_bloc.dart';
import 'package:medibot_app/bloc/diagnose/diagnose_bloc.dart';
import 'package:medibot_app/bloc/patient/patient_bloc.dart';
import 'package:medibot_app/bloc/patient_detail/patient_detail_bloc.dart';
import 'package:medibot_app/bloc/patient_detail_modify/patient_detail_modify_bloc.dart';
import 'package:medibot_app/bloc/patient_profile_modify/patient_profile_modify_bloc.dart';
import 'package:medibot_app/bloc/user_management/user_management_bloc.dart';
import 'package:medibot_app/data/api/user_client.dart';
import 'package:medibot_app/data/api/patient_client.dart';
import 'package:medibot_app/data/repository/authentication_repository.dart';
import 'package:medibot_app/view/home/home_page.dart';
import 'package:medibot_app/view/login/login_page.dart';
import 'package:medibot_app/view/splash/splash_page.dart';

class App extends StatelessWidget {
  App(
      {Key? key,
      required this.authenticationRepository,
      required this.userClient,
      required this.patientClient})
      : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserClient userClient;
  final PatientClient patientClient;

  final theme = ThemeData.light().copyWith(
      bottomAppBarColor: Colors.indigo.shade300,
      colorScheme: ColorScheme.light(
          primary: Colors.indigo.shade300,
          onPrimary: Colors.indigo.shade50,
          secondary: Colors.orange.shade300,
          onSecondary: Colors.black,
          error: Colors.red.shade500,
          onError: Colors.black,
          background: Colors.indigo.shade50,
          onBackground: Colors.black,
          surface: Colors.indigo.shade50,
          onSurface: Colors.black));

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: authenticationRepository),
          RepositoryProvider.value(value: userClient),
          RepositoryProvider.value(
            value: patientClient,
          )
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (_) => AuthenticationBloc(
                    authenticationRepository: authenticationRepository,
                    userClient: userClient)),
            BlocProvider(
              create: (_) => PatientBloc(patientClient: patientClient),
            ),
            BlocProvider(
                create: (_) => DiagnoseBloc(patientClient: patientClient)),
            BlocProvider(
              create: (_) => UserManagementBloc(userClient: userClient),
            ),
            BlocProvider(
                create: (_) =>
                    PatientProfileModifyBloc(patientClient: patientClient)),
            BlocProvider(
                create: (_) =>
                    PatientDetailModifyBloc(patientClient: patientClient)),
            BlocProvider(create: (_) => PatientDetailBloc(patientClient))
          ],
          child: const AppView(),
        ));
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                  (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                context.read<DiagnoseBloc>().unselectPatient();
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
