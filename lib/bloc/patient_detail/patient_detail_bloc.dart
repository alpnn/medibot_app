import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medibot_app/model/patient/patient_detail.dart';
import 'package:medibot_app/data/api/patient_client.dart';

class PatientDetailBloc extends Cubit<PatientDetailState> {
  final PatientClient patientClient;

  PatientDetailBloc(this.patientClient)
      : super(PatientDetailState(patientId: '', detailList: null));

  Future<void> updateDetailList() async {
    List<PatientDetail> detailList =
        await patientClient.fetchPatientDetailList(state.patientId);
    emit(
        PatientDetailState(patientId: state.patientId, detailList: detailList));
  }

  void changePatient(String patientId) async {
    emit(PatientDetailState(patientId: patientId, detailList: null));
    await updateDetailList();
  }
}

class PatientDetailState {
  String patientId;
  List<PatientDetail>? detailList;

  PatientDetailState({required this.patientId, required this.detailList});
}
