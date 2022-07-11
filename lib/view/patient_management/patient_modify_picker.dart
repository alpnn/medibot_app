import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medibot_app/bloc/patient_detail/patient_detail_bloc.dart';
import 'package:medibot_app/model/patient/patient_profile.dart';
import 'package:medibot_app/view/patient_profile_modify/patient_profile_modify_page.dart';
import 'package:medibot_app/view/patient_detail_list/patient_detail_list.dart';

class PatientModifyPickerPage extends StatelessWidget {
  final PatientProfile patientProfile;

  static Route route({required PatientProfile patientProfile}) {
    return MaterialPageRoute<void>(
        builder: (_) => PatientModifyPickerPage(
              patientProfile: patientProfile,
            ));
  }

  const PatientModifyPickerPage({Key? key, required this.patientProfile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select operation'),
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () =>
                Navigator.of(context).push(PatientProfileModifyPage.route(
              patientProfile: patientProfile,
            )),
            child: const ListTile(
              title: Text('Modify profile'),
            ),
          ),
          GestureDetector(
            onTap: () {
              context
                  .read<PatientDetailBloc>()
                  .changePatient(patientProfile.id);
              Navigator.of(context).push(PatientDetailListPage.route());
            },
            child: const ListTile(
              title: Text('Modify details (including intent and responses)'),
            ),
          )
        ],
      ),
    );
  }
}
