import 'package:flutter/material.dart';
import 'package:medibot_app/app.dart';
import 'package:medibot_app/data/api/auth_client.dart';
import 'package:medibot_app/data/api/patient_client.dart';
import 'package:medibot_app/data/api/user_client.dart';
import 'package:medibot_app/data/http/auth_http.dart';
import 'package:medibot_app/data/http/base_http.dart';
import 'package:medibot_app/data/repository/authentication_repository.dart';

void main() {
  BaseHttp baseHttp = BaseHttp();
  AuthClient authClient = AuthClient(baseHttp: baseHttp);
  AuthenticationRepository authenticationRepository =
      AuthenticationRepository(authClient: authClient);
  AuthHttp authHttp =
      AuthHttp(authenticationRepository: authenticationRepository);
  UserClient userClient = UserClient(authHttp: authHttp);
  PatientClient patientClient = PatientClient(authHttp: authHttp);
  runApp(App(
    authenticationRepository: authenticationRepository,
    patientClient: patientClient,
    userClient: userClient,
  ));
}
