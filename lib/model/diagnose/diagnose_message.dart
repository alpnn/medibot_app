enum DiagnoseMessageSender{
  patient,
  student
}

class DiagnoseMessage {
  DiagnoseMessageSender sender;
  String content;

  DiagnoseMessage({required this.sender, required this.content});
}