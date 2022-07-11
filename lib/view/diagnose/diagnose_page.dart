import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medibot_app/bloc/diagnose/diagnose_bloc.dart';
import 'package:medibot_app/model/patient/patient_profile.dart';
import 'package:medibot_app/model/diagnose/diagnose_message.dart';
import 'package:medibot_app/model/error.dart';

class DiagnosePage extends StatelessWidget {
  final PatientProfile target;

  const DiagnosePage({Key? key, required this.target}) : super(key: key);

  static Route route(PatientProfile target) {
    return MaterialPageRoute<void>(
        builder: (context) => DiagnosePage(
              target: target,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(target.displayId),
        centerTitle: true,
      ),
      body: BlocBuilder<DiagnoseBloc, DiagnoseState>(
        buildWhen: (previousState, currentState) =>
            previousState.selectedPatient != currentState.selectedPatient,
        builder: (context, state) {
          final currentDisplayId = target.displayId;
          if (state.selectedPatient == null) {
            return _StartSessionWidget(
                hintText:
                    'Start conversation with patient "$currentDisplayId"?',
                onPressed: () {
                  context.read<DiagnoseBloc>().selectPatient(patient: target);
                });
          }
          if (state.selectedPatient!.id != target.id) {
            final activeDisplayId = state.selectedPatient!.displayId;
            return _StartSessionWidget(
                hintText:
                    'You are now talking with "$activeDisplayId".\nEnd up this session and start diagnose "$currentDisplayId"?',
                onPressed: () {
                  context.read<DiagnoseBloc>().selectPatient(patient: target);
                });
          }
          return Column(
            children: const [
              Expanded(child: _ConversationPresenter()),
              _ConversationInputBox()
            ],
          );
        },
      ),
    );
  }
}

class _StartSessionWidget extends StatelessWidget {
  final void Function()? onPressed;
  final String hintText;

  const _StartSessionWidget(
      {Key? key, required this.hintText, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            child: Text(
              hintText,
              textAlign: TextAlign.center,
            )),
        ElevatedButton(
          onPressed: onPressed,
          child: const Text('New session'),
        )
      ],
    );
  }
}

class _ConversationPresenter extends StatelessWidget {
  const _ConversationPresenter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiagnoseBloc, DiagnoseState>(
      builder: (context, state) => ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        reverse: true,
        itemCount: state.messages.length,
        itemBuilder: (context, index) {
          index = state.messages.length - index - 1;
          return Container(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: Align(
              alignment:
                  state.messages[index].sender == DiagnoseMessageSender.patient
                      ? Alignment.topLeft
                      : Alignment.topRight,
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.85),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: state.messages[index].sender ==
                            DiagnoseMessageSender.patient
                        ? Colors.grey.shade200
                        : Colors.blue.shade200),
                padding: const EdgeInsets.all(16),
                child: Text(
                  state.messages[index].content,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ConversationInputBox extends StatefulWidget {
  const _ConversationInputBox({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConversationInputBoxState();
}

class _ConversationInputBoxState extends State<_ConversationInputBox> {
  final TextEditingController _inputController = TextEditingController();
  String _inputMessage = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 60,
      width: double.infinity,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'ask the patient something...',
                hintStyle: TextStyle(color: Colors.black54),
                border: InputBorder.none,
              ),
              controller: _inputController,
              onChanged: (msg) => setState(() => _inputMessage = msg),
            ),
          ),
          ElevatedButton(
            onPressed: _inputMessage != ''
                ? () async {
                    try {
                      Future<void> result = context
                          .read<DiagnoseBloc>()
                          .sendMessage(inputMessage: _inputController.text);
                      _inputController.clear();
                      setState(() => _inputMessage='');
                      FocusManager.instance.primaryFocus?.unfocus();
                      await result;
                    } on MedibotError catch (e) {
                      if (e.code == 400) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text('Session expired'),
                                  content: const Text(
                                      'Dialog session expired, restart it?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          await context
                                              .read<DiagnoseBloc>()
                                              .refreshSession();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK')),
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('Cancel'))
                                  ],
                                ));
                      } else {
                        rethrow;
                      }
                    }
                  }
                : null,
            child: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
