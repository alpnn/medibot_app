import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medibot_app/bloc/patient_detail/patient_detail_bloc.dart';
import 'package:medibot_app/bloc/patient_detail_modify/patient_detail_modify_bloc.dart';
import 'package:medibot_app/view/patient_detail_modify/patient_detail_modify_page.dart';

class PatientDetailListPage extends StatelessWidget {
  const PatientDetailListPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => const PatientDetailListPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Patient Detail Management'),
          actions: [
            BlocBuilder<PatientDetailBloc, PatientDetailState>(
                builder: (context, state) => IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => Navigator.of(context).push(
                          PatientDetailModifyPage.route(
                              patientDetail: null, patientId: state.patientId)),
                    ))
          ],
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              context.read<PatientDetailBloc>().updateDetailList();
            },
            child: const _DetailList()));
  }
}

class _DetailList extends StatelessWidget {
  const _DetailList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientDetailBloc, PatientDetailState>(
        builder: (context, state) {
      return state.detailList == null
          ? Stack(
              children: [
                ListView(),
                const Center(
                  child: Text('No data'),
                )
              ],
            )
          : ListView.builder(
              itemCount: state.detailList!.length,
              itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    context
                        .read<PatientDetailModifyBloc>()
                        .createNewModification(
                            state.detailList![index], state.patientId);
                    Navigator.of(context).push(PatientDetailModifyPage.route(
                        patientDetail: state.detailList![index],
                        patientId: state.patientId));
                  },
                  child: ListTile(
                    title: Text(state.detailList![index].intent.join('|')),
                    subtitle: Text(state.detailList![index].id),
                  )),
            );
    });
  }
}
