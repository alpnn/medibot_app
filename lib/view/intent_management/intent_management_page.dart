import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntentManagementPage extends StatelessWidget {
  const IntentManagementPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => const IntentManagementPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Intent Management'),),
      body: Text('Hi'),
    );
  }
}