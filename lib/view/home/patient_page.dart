import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medibot_app/bloc/patient/patient_bloc.dart';
import 'package:medibot_app/bloc/authentication/authentication_bloc.dart';
import 'package:medibot_app/view/diagnose/diagnose_page.dart';

class PatientPage extends StatelessWidget {
  const PatientPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        context
            .read<PatientBloc>()
            .add(PatientListUpdateEvent(listAll: state.isAdmin));
        return RefreshIndicator(
            child: const _PatientListWidget(),
            onRefresh: () async {
              context
                  .read<PatientBloc>()
                  .add(PatientListUpdateEvent(listAll: state.isAdmin));
            });
      },
    );
  }
}

class _PatientListWidget extends StatelessWidget {
  const _PatientListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientBloc, PatientState>(builder: (context, state) {
      final patientList = state.patientList;
      return patientList == null
          ? Stack(children: [
              ListView(),
              const Center(
                child: Text('No data'),
              )
            ])
          : ListView.builder(
              itemCount: patientList.length,
              itemBuilder: (context, index) {
                // final id = patientList[index].id;
                final displayId = patientList[index].displayId;
                final String? sex;
                switch (patientList[index].sex) {
                  case 'M':
                    sex = 'Male';
                    break;
                  case 'F':
                    sex = 'Female ';
                    break;
                  default:
                    sex = 'unknown';
                }
                return GestureDetector(
                  onTap: () => Navigator.of(context)
                      .push(DiagnosePage.route(patientList[index])),
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [Icon(Icons.account_circle)],
                    ),
                    title: Text(displayId),
                    subtitle: Text('sex: $sex'),
                  ),
                );
              });
    });
  }
}
