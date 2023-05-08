import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = '192.168.1.42:8080';
  final storage = const FlutterSecureStorage();
  bool isLoading = true;
  List<dynamic> Favs = [];
  String passwordGlobal = '';
  String usernameGlobal = '';

  readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  readId() async {
    return await storage.read(key: 'id') ?? '';
  }

//REGISTER
  Future<String?> register(
    String username,
    String password,
  ) async {
    final Map<String, dynamic> authData = {
      'username': username,
      'password': password,
    };

    final encodedFormData = utf8.encode(json.encode(authData));
    final url = Uri.http(_baseUrl, '/register');

    final resp = await http.post(url,
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

//LOGINS
  Future<String?> login(String user, String password) async {
    final Map<String, dynamic> authData = {'user': user, 'password': password};
    usernameGlobal = user;
    passwordGlobal = password;
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.1.42:8080/login'));

    request.fields['user'] = user;
    request.fields['password'] = password;

    var response = await request.send();

    if (response.statusCode == 200) {
      String values = "";
      await response.stream.transform(utf8.decoder).listen((value) {
        values = value;
      });

      final Map<String, dynamic> decodedResp = json.decode(values);

      await storage.write(key: 'token', value: decodedResp['token']);
      await storage.write(key: 'id', value: decodedResp['id'].toString());

      return decodedResp['role'] +
          ',' +
          response.statusCode.toString() +
          ',' +
          decodedResp['enabled'].toString();
    } else {
      return '' + ',' + response.statusCode.toString();
    }
  }

  Future logout() async {
    await storage.deleteAll();
    return;
  }
}
