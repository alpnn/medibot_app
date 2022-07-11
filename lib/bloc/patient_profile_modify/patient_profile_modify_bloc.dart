import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medibot_app/model/form/username.dart';
import 'package:medibot_app/model/patient/patient_profile.dart';
import 'package:medibot_app/data/api/patient_client.dart';

class PatientProfileModifyBloc extends Cubit<PatientProfileModifyState> {
  final PatientClient patientClient;

  PatientProfileModifyBloc({required this.patientClient})
      : super(PatientProfileModifyState(id: null));

  void createNewModification(PatientProfile? patientProfile) {
    if (patientProfile == null) {
      emit(PatientProfileModifyState(id: null));
    } else {
      emit(PatientProfileModifyState(
          id: patientProfile.id,
          displayId: patientProfile.displayId,
          sex: patientProfile.sex));
    }
  }

  Future<void> submitUpdate() async {
    await patientClient.updatePatient(
        id: state.id,
        displayId: state.displayId,
        sex: state.sex,
        active: state.active);
  }

  Future<void> submitDelete() async {
    await patientClient.deletePatient(state.id!);
  }

  void updateDisplayId(String displayId) {
    emit(state.copyWith(displayId: displayId));
  }

  void updateSex(String sex) {
    emit(state.copyWith(sex: sex));
  }

  void updateActive(bool active) {
    emit(state.copyWith(active: active));
  }
}

class PatientProfileModifyState {
  String? id;
  String displayId;
  String sex;
  bool active;

  PatientProfileModifyState(
      {required this.id,
      this.displayId = '',
      this.sex = 'M',
      this.active = false});

  PatientProfileModifyState copyWith(
      {String? displayId, String? sex, bool? active}) {
    return PatientProfileModifyState(
        id: id,
        displayId: displayId ?? this.displayId,
        sex: sex ?? this.sex,
        active: active ?? this.active);
  }
}
