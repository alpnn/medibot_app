import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medibot_app/model/patient/patient_profile.dart';
import 'package:medibot_app/data/api/patient_client.dart';

part 'patient_event.dart';
part 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientClient patientClient;

  PatientBloc({required this.patientClient}) : super(const PatientState()) {
    on<PatientListUpdateEvent>(_onUpdatePatientList);
  }

  void _onUpdatePatientList(
      PatientListUpdateEvent event, Emitter<PatientState> emit) async {
    List<PatientProfile> patientList =
        await patientClient.getPatientList(event.listAll);
    emit(PatientState(patientList: patientList));
  }
}
