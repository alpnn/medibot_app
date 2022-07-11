import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medibot_app/bloc/patient_profile_modify/patient_profile_modify_bloc.dart';
import 'package:medibot_app/model/patient/patient_profile.dart';
import 'package:medibot_app/view/patient_profile_modify/patient_profile_modify_form.dart';

class PatientProfileModifyPage extends StatelessWidget {
  final PatientProfile? patientProfile;

  const PatientProfileModifyPage({Key? key, required this.patientProfile})
      : super(key: key);

  static Route route({PatientProfile? patientProfile}) {
    return MaterialPageRoute<void>(
        builder: (_) => PatientProfileModifyPage(patientProfile: patientProfile));
  }

  @override
  Widget build(BuildContext context) {
    context.read<PatientProfileModifyBloc>().createNewModification(patientProfile);
    return Scaffold(
        appBar: AppBar(
          title: Text(patientProfile != null ? 'Modify patient' : 'Add patient'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: const PatientProfileModifyForm(),
        ));
  }
}
