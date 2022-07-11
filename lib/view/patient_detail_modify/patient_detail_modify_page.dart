import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medibot_app/model/patient/patient_detail.dart';
import 'package:medibot_app/bloc/patient_detail_modify/patient_detail_modify_bloc.dart';
import 'patient_detail_modify_form.dart';

class PatientDetailModifyPage extends StatelessWidget {
  final PatientDetail? patientDetail;
  final String patientId;

  const PatientDetailModifyPage(
      {Key? key, required this.patientDetail, required this.patientId})
      : super(key: key);

  static Route route({PatientDetail? patientDetail, required String patientId}) {
    return MaterialPageRoute<void>(
        builder: (_) => PatientDetailModifyPage(
              patientDetail: patientDetail,
              patientId: patientId,
            ));
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<PatientDetailModifyBloc>()
        .createNewModification(patientDetail, patientId);
    return Scaffold(
        appBar: AppBar(
          title: Text(patientDetail != null
              ? 'Modify patient detail'
              : 'Add patient detail'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: const PatientDetailModifyForm(),
        ));
  }
}
