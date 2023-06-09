// ignore_for_file: avoid_

import 'dart:convert';

import 'package:townhall/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:townhall/Models/models.dart';

class UserService extends ChangeNotifier {
  final String _baseUrl = '192.168.1.43:8080';
  bool isLoading = true;
  String usuario = "";
  List<User> managers = [];
  final storage = const FlutterSecureStorage();

  getUser() async {
    String? token = await AuthService().readToken();
    String? id = await AuthService().readId();

    print(token);
    print(id);
    final url = Uri.http(_baseUrl, '/all/$id');
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

    await storage.write(key: 'id', value: decodedResp['id'].toString());
    isLoading = false;
    notifyListeners();
    //Crear user
    String idUser = decodedResp['id'].toString();
    String usernameUser = decodedResp['username'].toString();
    String passwordUser = decodedResp['password'].toString();
    String nameUser = decodedResp['name'].toString();
    String surnameUser = decodedResp['surname'].toString();
    String dniUser = decodedResp['dni'].toString();
    String enabledUser = decodedResp['surname'].toString();
    String roleUser = decodedResp['surname'].toString();
    String tokenUser = decodedResp['surname'].toString();
    String idDepartmentUser = decodedResp['surname'].toString();

    User us = User(
        id: int.parse(idUser),
        username: usernameUser,
        password: passwordUser,
        name: nameUser,
        surname: surnameUser,
        dni: dniUser,
        enabled: bool.hasEnvironment(enabledUser),
        role: roleUser,
        token: tokenUser);

    return us;
  }

  Future<List> getManagers() async {
    managers.clear();
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/manager/managers');
    String? token = await AuthService().readToken();

    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    final List<dynamic> decodedResp = json.decode(resp.body);
    List<User> managersList = decodedResp
        .map((e) => User(
              id: e['id'],
              dni: e['dni'],
              name: e['name'],
              surname: e['surname'],
              username: e['username'],
              password: e['password'],
              role: e['role'],
              enabled: e['enabled'],
              idDepartment: e['idDepartment'],
              token: e['token'],
            ))
        .toList();
    managers = managersList;

    isLoading = false;
    notifyListeners();

    return managersList;
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

//UPDATE USER
  Future<String?> update(
    String username,
    String password,
    String dni,
    String name,
    String surname,
  ) async {
    String id = await AuthService().readId();
    final Map<String, dynamic> authData = {
      'id': id,
      'username': username,
      'dni': dni,
      'name': name,
      'surname': surname,
      'password': password,
    };

    final encodedFormData = utf8.encode(json.encode(authData));
    final url = Uri.http(_baseUrl, '/all/update');

    final resp = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: encodedFormData);

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (resp.statusCode == 200) {
      await storage.write(key: 'token', value: decodedResp['token']);
      await storage.write(key: 'id', value: decodedResp['id'].toString());

      return (resp.statusCode.toString());
    } else {
      return (resp.statusCode.toString());
    }
  }
}
