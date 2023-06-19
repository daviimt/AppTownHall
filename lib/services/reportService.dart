import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:townhall/Models/models.dart';
import 'package:townhall/models/appointment.dart';
import 'services.dart';

class ReportService extends ChangeNotifier {
  final String _baseUrl = '192.168.1.43:8080';
  bool isLoading = true;
  List<Report> appointments = [];
  String appointment = "";
  Report report = Report();
  final storage = const FlutterSecureStorage();

// GET REPORTS
  Future<List> getListReports() async {
    appointments.clear();
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/api/all/reports');
    String? token = await AuthService().readToken();

    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    final List<dynamic> decodedResp = json.decode(resp.body);
    List<Report> appointmentList = decodedResp
        .map((e) => Report(
              id: e['id'],
              data: e['data'],
              resolution: e['resolution'],
              idAppointment: e['idAppointment'],
            ))
        .toList();
    appointments = appointmentList;

    isLoading = false;
    notifyListeners();

    return appointmentList;
  }

//GET REPORTS MANAGER
  getReportsManager(String id) async {
    appointments.clear();
    String? token = await AuthService().readToken();

    final url = Uri.http(_baseUrl, '/api/manager/appointments/$id');

    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    final List<dynamic> decodedResp = json.decode(resp.body);

    List<Report> appointmentList = decodedResp
        .map((e) => Report(
              id: e['id'],
              data: e['data'],
              resolution: e['resolution'],
              idAppointment: e['idAppointment'],
            ))
        .toList();

    appointments = appointmentList;
    isLoading = false;
    notifyListeners();

    return appointmentList;
  }

//GET APPOINTMENT
  Future<Report> getReport(int id) async {
    String? token = await AuthService().readToken();

    final url = Uri.http(_baseUrl, '/api/manager/report/$id');

    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    Report r = Report(
      id: decodedResp['id'],
      data: decodedResp['data'],
      resolution: decodedResp['resolution'],
    );

    report = r;

    isLoading = false;
    notifyListeners();
    return r;
  }

//CREATE REPORT
  Future create(
    String data,
    bool resolution,
    int idAppointment,
  ) async {
    String? token = await AuthService().readToken();
    isLoading = false;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'data': data,
      'resolution': resolution,
      'idAppointment': idAppointment,
    };

    final url = Uri.http(_baseUrl, '/api/manager/report');

    final resp = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(productData),
    );
    isLoading = false;
    notifyListeners();

    if (resp.statusCode == 200) {}
    return resp.statusCode.toString();
  }

  //  DELETE APPOINTMENT
  deleteReport(String id) async {
    String? token = await AuthService().readToken();

    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, '/api/manager/report/$id');

    final resp = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    isLoading = false;
    notifyListeners();
    if (resp.statusCode == 200) {}
  }
}
