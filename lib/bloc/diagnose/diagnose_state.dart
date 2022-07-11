part of 'diagnose_bloc.dart';

class DiagnoseState extends Equatable {
  final PatientProfile? selectedPatient;
  final List<DiagnoseMessage> messages;

  const DiagnoseState({
    required this.selectedPatient,
    this.messages = const [],
  });

  DiagnoseState copyWith(
      {PatientProfile? selectedPatient,
      List<DiagnoseMessage>? messages,
      String? inputMessage}) {
    return DiagnoseState(
        selectedPatient: selectedPatient ?? this.selectedPatient,
        messages: messages ?? this.messages);
  }

  @override
  List<Object?> get props => [selectedPatient, messages];
}
