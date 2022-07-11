import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medibot_app/model/patient/patient_profile.dart';
import 'package:medibot_app/model/diagnose/diagnose_message.dart';
import 'package:equatable/equatable.dart';
import 'package:medibot_app/data/api/patient_client.dart';

part 'diagnose_event.dart';
part 'diagnose_state.dart';

class DiagnoseBloc extends Cubit<DiagnoseState> {
  final PatientClient patientClient;

  DiagnoseBloc({required this.patientClient})
      : super(const DiagnoseState(selectedPatient: null)) {
    // on<DiagnoseSelectPatient>(_selectPatient);
    // on<DiagnoseSendMessage>(_sendMessage);
  }

  Future<void> unselectPatient() async{
    emit(const DiagnoseState(selectedPatient: null));
  }

  Future<void> selectPatient({required PatientProfile patient}) async {
    await patientClient.createSession(patient.id);
    emit(DiagnoseState(selectedPatient: patient));
  }

  Future<void> refreshSession() async {
    await patientClient.createSession(state.selectedPatient!.id);
  }

  Future<void> sendMessage({required String inputMessage}) async {
    if(inputMessage == ''){
      return;
    }
    emit(state.copyWith(
        messages: List.of(state.messages)
          ..add(DiagnoseMessage(
              sender: DiagnoseMessageSender.student,
              content: inputMessage))));
    String reply = await patientClient.queryPatient(
        state.selectedPatient!.id, inputMessage);
    emit(state.copyWith(
        messages: List.of(state.messages)
          ..add(DiagnoseMessage(
              sender: DiagnoseMessageSender.patient, content: reply))));
  }
}
