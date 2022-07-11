import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medibot_app/bloc/patient/patient_bloc.dart';
import 'package:medibot_app/bloc/patient_detail/patient_detail_bloc.dart';
import 'package:medibot_app/bloc/patient_profile_modify/patient_profile_modify_bloc.dart';
import 'package:medibot_app/bloc/patient_detail_modify/patient_detail_modify_bloc.dart';
import 'package:medibot_app/view/patient_management/patient_modify_picker.dart';
import 'package:medibot_app/view/patient_profile_modify/patient_profile_modify_page.dart';

class PatientManagementPage extends StatelessWidget {
  const PatientManagementPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => const PatientManagementPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Patient Management'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => Navigator.of(context)
                  .push(PatientProfileModifyPage.route(patientProfile: null)),
            )
          ],
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              context
                  .read<PatientBloc>()
                  .add(PatientListUpdateEvent(listAll: true));
            },
            child: _PatientList()));
  }
}

class _PatientList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientBloc, PatientState>(builder: (context, state) {
      return state.patientList == null
          ? Stack(
              children: [
                ListView(),
                const Center(
                  child: Text('No data'),
                )
              ],
            )
          : ListView.builder(
              itemCount: state.patientList!.length,
              itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    context
                        .read<PatientProfileModifyBloc>()
                        .createNewModification(state.patientList![index]);
                    Navigator.of(context).push(PatientModifyPickerPage.route(
                        patientProfile: state.patientList![index]));
                  },
                  child: ListTile(
                    title: Text(state.patientList![index].displayId),
                    subtitle: Text(state.patientList![index].id),
                  )),
            );
    });
  }
}
