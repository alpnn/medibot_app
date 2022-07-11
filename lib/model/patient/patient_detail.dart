class PatientDetail {
  String id;
  String patientId;
  List<String> intent;
  List<String> response;
  Map<String, List<String>>? params;
  bool active;

  PatientDetail(
      {required this.id,
      required this.patientId,
      required this.intent,
      required this.response,
      required this.params,
      required this.active});
}
