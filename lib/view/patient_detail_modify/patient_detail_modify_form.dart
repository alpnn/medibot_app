import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medibot_app/bloc/patient/patient_bloc.dart';
import 'package:medibot_app/bloc/patient_detail_modify/patient_detail_modify_bloc.dart';
import 'package:medibot_app/bloc/patient_profile_modify/patient_profile_modify_bloc.dart';
import 'package:medibot_app/model/patient/patient_profile.dart';

class PatientDetailModifyForm extends StatefulWidget {
  const PatientDetailModifyForm({Key? key}) : super(key: key);
  // Null means add new patient

  @override
  State<StatefulWidget> createState() => _StatePatientModifyForm();
}

class _StatePatientModifyForm extends State<PatientDetailModifyForm> {
  @override
  Widget build(BuildContext context) {
    final Color errorColor = Theme.of(context).colorScheme.error;

    return BlocBuilder<PatientDetailModifyBloc, PatientDetailModifyState>(
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
            label: Text('Patient ID'),
          ),
          initialValue: state.patientId,
          enabled: false,
        ),
        TextFormField(
          decoration: const InputDecoration(
            label: Text('Intent'),
          ),
          initialValue: state.intent.join('|'),
          enabled: false,
          maxLines: null,
        ),
        TextFormField(
          decoration: const InputDecoration(
            label: Text('Response'),
          ),
          initialValue: state.response.join('\n'),
          enabled: false,
          maxLines: null,
        ),
        DropdownButtonFormField<bool>(
            value: state.withParams,
            decoration: const InputDecoration(label: Text('Params')),
            items: const [
              DropdownMenuItem<bool>(value: true, child: Text('Yes')),
              DropdownMenuItem<bool>(value: false, child: Text('No')),
            ],
            onChanged: (params) =>
                context.read<PatientDetailModifyBloc>().toggleParams()),
        if (state.withParams)
          TextFormField(
            decoration: const InputDecoration(
              label: Text('Response'),
            ),
            initialValue: jsonEncode(state.params),
            enabled: false,
            maxLines: null,
          ),
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
