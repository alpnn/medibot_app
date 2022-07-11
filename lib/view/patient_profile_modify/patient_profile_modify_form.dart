import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medibot_app/bloc/patient/patient_bloc.dart';
import 'package:medibot_app/bloc/patient_profile_modify/patient_profile_modify_bloc.dart';
import 'package:medibot_app/model/patient/patient_profile.dart';

class PatientProfileModifyForm extends StatefulWidget {
  const PatientProfileModifyForm({Key? key}) : super(key: key);
  // Null means add new patient

  @override
  State<StatefulWidget> createState() => _StatePatientModifyForm();
}

class _StatePatientModifyForm extends State<PatientProfileModifyForm> {
  @override
  Widget build(BuildContext context) {
    final Color errorColor = Theme.of(context).colorScheme.error;

    return BlocBuilder<PatientProfileModifyBloc, PatientProfileModifyState>(
        builder: (context, state) {
      return ListView(children: [
        TextFormField(
          decoration: const InputDecoration(
            label: Text('ID'),
          ),
          initialValue: state.id ?? 'Auto generate',
          enabled: false,
        ),
        TextFormField(
          decoration: const InputDecoration(
            label: Text('Display ID'),
          ),
          initialValue: state.displayId,
          onChanged: (displayId) =>
              context.read<PatientProfileModifyBloc>().updateDisplayId(displayId),
        ),
        DropdownButtonFormField<String>(
            value: state.sex,
            decoration: const InputDecoration(label: Text('Sex')),
            items: const [
              DropdownMenuItem<String>(value: 'U', child: Text('Undefined')),
              DropdownMenuItem<String>(value: 'M', child: Text('Male')),
              DropdownMenuItem<String>(value: 'F', child: Text('Female')),
            ],
            onChanged: (sex) =>
                context.read<PatientProfileModifyBloc>().updateSex(sex!)),
        DropdownButtonFormField<bool>(
            value: state.active,
            decoration: const InputDecoration(label: Text('Active')),
            items: const [
              DropdownMenuItem<bool>(value: true, child: Text('True')),
              DropdownMenuItem<bool>(value: false, child: Text('False')),
            ],
            onChanged: (active) =>
                context.read<PatientProfileModifyBloc>().updateActive(active!)),
        TextButton(
            onPressed: () async {
              await context.read<PatientProfileModifyBloc>().submitUpdate();
              context
                  .read<PatientBloc>()
                  .add(PatientListUpdateEvent(listAll: true));
              Navigator.of(context).pop();
            },
            child: const Text('Submit')),
        if (state.id != null)
          TextButton(
              onPressed: () async {
                await context.read<PatientProfileModifyBloc>().submitDelete();
                context
                    .read<PatientBloc>()
                    .add(PatientListUpdateEvent(listAll: true));
                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: errorColor),
              )),
      ]);
    });
  }
}
