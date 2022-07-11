import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medibot_app/data/api/patient_client.dart';
import 'package:medibot_app/model/patient/patient_detail.dart';

class PatientDetailModifyBloc extends Cubit<PatientDetailModifyState> {
  final PatientClient patientClient;

  PatientDetailModifyBloc({required this.patientClient})
      : super(PatientDetailModifyState(id: null, patientId: ''));

  void createNewModification(PatientDetail? patientDetail, String patientId) {
    if (patientDetail == null) {
      emit(PatientDetailModifyState(id: null, patientId: patientId));
    } else {
      emit(PatientDetailModifyState(
          id: patientDetail.id,
          patientId: patientDetail.patientId,
          intent: patientDetail.intent,
          response: patientDetail.response,
          active: patientDetail.active,
          withParams: patientDetail.params != null,
          params: patientDetail.params ?? {}));
    }
  }

  void toggleParams(){
    emit(state.copyWith(withParams: !state.withParams));
  }

  Future<void> submitUpdate() async {
    //TODO
  }

  Future<void> submitDelete() async {}
}

class PatientDetailModifyState {
  String? id;
  String patientId;
  List<String> intent;
  List<String> response;
  bool withParams;
  Map<String, List<String>> params;
  bool active;

  PatientDetailModifyState(
      {required this.id,
      required this.patientId,
      this.intent = const [],
      this.response = const [],
      this.active = false,
      this.withParams = false,
      this.params = const {}});

  PatientDetailModifyState copyWith(
      {List<String>? intent,
      List<String>? response,
        bool? withParams,
      Map<String, List<String>>? params,
      bool? active}) {
    return PatientDetailModifyState(
        id: id,
        patientId: patientId,
        intent: intent ?? this.intent,
        response: response ?? this.response,
        withParams: withParams ?? this.withParams,
        params: params ?? this.params,
        active: active ?? this.active);
  }
}
