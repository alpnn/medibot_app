part of 'patient_bloc.dart';

class PatientState extends Equatable {
  const PatientState({this.patientList});

  final List<PatientProfile>? patientList;

  @override
  List<Object?> get props => [patientList];
}
