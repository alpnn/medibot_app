part of 'patient_bloc.dart';

abstract class PatientEvent {}

class PatientListUpdateEvent extends PatientEvent {
  final bool listAll;

  PatientListUpdateEvent({required this.listAll});
}
