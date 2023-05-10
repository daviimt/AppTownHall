// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:townhall/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:townhall/Models/models.dart';

class UserService extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';
  bool isLoading = true;
  String usuario = "";
  final storage = const FlutterSecureStorage();

  getUser() async {
    String? token = await AuthService().readToken();
    String? id = await AuthService().readId();

    final url = Uri.http(_baseUrl, '/public/api/user/$id');
    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
    );
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    await storage.write(key: 'id', value: decodedResp['data']['id'].toString());
    isLoading = false;
    notifyListeners();
    //Crear user
    return decodedResp['data']['id'].toString();
  }

  getUserId() async {
    String? token = await AuthService().readToken();
    String? id = await AuthService().readId();

    final url = Uri.http(_baseUrl, '/public/api/user/$id');
    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
    );
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    await storage.write(key: 'id', value: decodedResp['data']['id'].toString());
    isLoading = false;
    notifyListeners();
    return decodedResp['data']['id'].toString();
  }

  // ignore: non_constant_identifier_names
  readCompany_id() async {
    return await storage.read(key: 'company_id') ?? '';
  }

  Future postActivate(String id) async {
    final url = Uri.http(_baseUrl, '/public/api/activate', {'user_id': id});
    String? token = await AuthService().readToken();
    isLoading = true;
    notifyListeners();
    // ignore: unused_local_variable
    final resp = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
    );
  }

  Future postDeactivate(String id) async {
    final url = Uri.http(_baseUrl, '/public/api/deactivate', {'user_id': id});
    String? token = await AuthService().readToken();
    isLoading = true;
    notifyListeners();
    // ignore: unused_local_variable
    final resp = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
    );
  }

  Future postDelete(String id) async {
    final url = Uri.http(_baseUrl, '/public/api/delete', {'user_id': id});
    String? token = await AuthService().readToken();
    isLoading = true;
    notifyListeners();
    // ignore: unused_local_variable
    final resp = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
    );
  }
}
