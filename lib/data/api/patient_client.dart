import 'dart:convert';

import 'package:http/http.dart';
import 'package:medibot_app/data/api/abstract_client.dart';
import 'package:medibot_app/data/http/auth_http.dart';
import 'package:medibot_app/model/error.dart';
import 'package:medibot_app/model/patient/patient_detail.dart';
import 'package:medibot_app/model/patient/patient_profile.dart';

class PatientClient extends AbstractClient {
  final AuthHttp authHttp;

  PatientClient({required this.authHttp});

  Future<List<PatientProfile>> getPatientList(bool listAll) async {
    Response response = await authHttp.dispatchHttpGet(
        buildUri(listAll ? '/admin/patient' : '/patient'),
        const Duration(seconds: 5));
    try {
      List<dynamic> parsedJson = jsonDecode(response.body);
      return parsedJson.map((e) {
        String id = e['id'];
        String displayId = e['displayId'];
        String sex = e['sex'] ?? 'U';
        DateTime createdAt = e['createdAt'] != null
            ? DateTime.parse(e['createdAt'].toString())
            : DateTime.fromMicrosecondsSinceEpoch(0);
        DateTime updatedAt = e['updatedAt'] != null
            ? DateTime.parse(e['updatedAt'].toString())
            : DateTime.fromMicrosecondsSinceEpoch(0);
        return PatientProfile(
            id: id,
            displayId: displayId,
            sex: sex,
            createdAt: createdAt,
            updatedAt: updatedAt);
      }).toList();
    } catch (e) {
      throw MedibotError.jsonParseFailed;
    }
  }

  Future<void> createSession(String patientId) async {
    await authHttp.dispatchHttpPost(
        buildUri('/patient/$patientId/session'), const Duration(seconds: 5));
  }

  Future<String> queryPatient(String patientId, String message) async {
    Response response = await authHttp.dispatchHttpPost(
        buildUri('/patient/$patientId/query'), const Duration(seconds: 5),
        body: jsonEncode(message));
    try {
      String reply = response.body;
      return reply;
    } catch (e) {
      throw MedibotError.jsonParseFailed;
    }
  }

  Future<void> updatePatient(
      {String? id,
      required String displayId,
      required String sex,
      required bool active}) async {
    Map<String, dynamic> requestBody = <String, dynamic>{
      "displayId": displayId,
      "sex": sex,
      "active": active
    };
    if (id != null) {
      requestBody['id'] = id;
    }
    await authHttp.dispatchHttpPost(
        buildUri('/admin/patient'), const Duration(seconds: 5),
        body: jsonEncode(requestBody));
  }

  Future<void> deletePatient(String id) async {
    await authHttp.dispatchHttpPost(
        buildUri('/admin/patient/$id/delete'), const Duration(seconds: 5));
  }

  Future<List<PatientDetail>> fetchPatientDetailList(String patientId) async {
    Response response = await authHttp.dispatchHttpGet(
        buildUri('/admin/patient/$patientId/details'),
        const Duration(seconds: 5));
    try {
      List<dynamic> parsedJson = jsonDecode(response.body);
      return parsedJson.map((e) {
        String id = e['id'];
        String patientId = e['patientId'];
        bool active = e['active'];
        List<String> intent = e['intent'] != null
            ? e['intent'].map<String>((e) => e as String).toList()
            : [];
        List<String> response = e['response'] != null
            ? e['response'].map<String>((e) => e as String).toList()
            : [];
        Map<String, List<String>>? params;
        if(e['params'] != null){
          params = {};
          (e['params'] as Map<String, dynamic>).forEach((k, v) {
            params![k] = v.map<String>((p) => p as String).toList();
          });
        }
        DateTime createdAt = e['createdAt'] != null
            ? DateTime.parse(e['createdAt'].toString())
            : DateTime.fromMicrosecondsSinceEpoch(0);
        DateTime updatedAt = e['updatedAt'] != null
            ? DateTime.parse(e['updatedAt'].toString())
            : DateTime.fromMicrosecondsSinceEpoch(0);
        return PatientDetail(
            id: id,
            active: active,
            patientId: patientId,
            intent: intent,
            response: response,
            params: params);
      }).toList();
    } catch (e) {
      throw MedibotError.jsonParseFailed;
    }
  }
}
