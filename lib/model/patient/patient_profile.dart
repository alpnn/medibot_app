class PatientProfile {
  String id;
  String displayId;
  String sex;
  DateTime createdAt;
  DateTime updatedAt;

  PatientProfile(
      {required this.id,
      required this.displayId,
      required this.sex,
      required this.createdAt,
      required this.updatedAt});
}
