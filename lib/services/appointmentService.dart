import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:townhall/models/appointment.dart';
import 'services.dart';

class AppointmentService extends ChangeNotifier {
  final String _baseUrl = '192.168.1.42:8080';
  bool isLoading = true;
  List<Appointment> appointments = [];
  String appointment = "";
  Appointment a = Appointment();
  final storage = const FlutterSecureStorage();

// GET APPOINTMENTS
  Future<List> getListAppointments() async {
    appointments.clear();
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/api/all/appointments');
    String? token = await AuthService().readToken();

    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    final List<dynamic> decodedResp = json.decode(resp.body);
    List<Appointment> appointmentList = decodedResp
        .map((e) => Appointment(
              id: e['id'],
              date: e['date'],
              hour: e['hour'],
              idDepartment: e['idDepartment'],
              idManager: e['idManager'],
              idUser: e['idUser'],
            ))
        .toList();
    appointments = appointmentList;

    isLoading = false;
    notifyListeners();

    return appointmentList;
  }

  //GET APPOINTMEN USER
  getAppointmentsUser(String id) async {
    appointments.clear();
    String? token = await AuthService().readToken();

    final url = Uri.http(_baseUrl, 'api/user/appointments/$id');

    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    final List<dynamic> decodedResp = json.decode(resp.body);

    List<Appointment> appointmentList = decodedResp
        .map((e) => Appointment(
              id: e['id'],
              date: e['date'],
              hour: e['hour'],
              idDepartment: e['idDepartment'],
              idManager: e['idManager'],
              idUser: e['idUser'],
            ))
        .toList();

    appointments = appointmentList;
    isLoading = false;
    notifyListeners();

    return appointmentList;
  }

//GET APPOINTMENT MANAGER
  getAppointmentsManager(String id) async {
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

    List<Appointment> appointmentList = decodedResp
        .map((e) => Appointment(
              id: e['id'],
              date: e['date'],
              hour: e['hour'],
              idDepartment: e['idDepartment'],
              idManager: e['idManager'],
              idUser: e['idUser'],
            ))
        .toList();

    appointments = appointmentList;
    isLoading = false;
    notifyListeners();

    return appointmentList;
  }

//GET APPOINTMENT
  Future<Appointment> getAppointment(String id) async {
    String? token = await AuthService().readToken();

    final url = Uri.http(_baseUrl, '/api/all/products/$id');

    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    Appointment appointment = Appointment(
      id: decodedResp['id'],
      date: decodedResp['date'],
      hour: decodedResp['hour'],
      idDepartment: decodedResp['idDepartment'],
      idManager: decodedResp['idManager'],
      idUser: decodedResp['idUser'],
    );

    a = appointment;

    isLoading = false;
    notifyListeners();
    return appointment;
  }

//CREATE APPOINTMENT
  Future create(
    String date,
    String hour,
    String idDepartment,
    int idManager,
    int idUser,
  ) async {
    String? token = await AuthService().readToken();
    isLoading = false;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'date': date,
      'hour': hour,
      'idDepartment': idDepartment,
      'idManager': idManager,
      'idUser': idUser,
    };

    final url = Uri.http(_baseUrl, '/api/user/appointment');

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
  deleteProduct(String id) async {
    String? token = await AuthService().readToken();

    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, '/api/all/appointment/$id');

    final resp = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    isLoading = false;
    notifyListeners();
    if (resp.statusCode == 200) {}
  }
}
