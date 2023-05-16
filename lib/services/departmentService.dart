import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:townhall/models/department.dart';
import 'package:townhall/models/models.dart';
import 'services.dart';

class DepartmentService extends ChangeNotifier {
  final String _baseUrl = '192.168.1.42:8080';
  bool isLoading = true;
  List<Department> departments = [];
  String departmentName = "";
  Department department = Department();
  Department a = Department();
  final storage = const FlutterSecureStorage();

// GET DepartmentS
  Future<List> getListDepartments() async {
    departments.clear();
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/api/all/departments');
    String? token = await AuthService().readToken();

    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    final List<dynamic> decodedResp = json.decode(resp.body);
    List<Department> departmentList = decodedResp
        .map((e) => Department(
              id: e['id'],
              name: e['name'],
              description: e['description'],
            ))
        .toList();
    departments = departmentList;

    isLoading = false;
    notifyListeners();

    return departmentList;
  }

  //GET APPOINTMEN USER
  getDepartmentsUser(String id) async {
    departments.clear();
    String? token = await AuthService().readToken();

    final url = Uri.http(_baseUrl, 'api/user/departments/$id');

    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    final List<dynamic> decodedResp = json.decode(resp.body);

    List<Department> departmentList = decodedResp
        .map((e) => Department(
              id: e['id'],
              name: e['name'],
              description: e['description'],
            ))
        .toList();

    departments = departmentList;
    isLoading = false;
    notifyListeners();

    return departmentList;
  }

//GET Department
  Future<Department> getDepartment(int id) async {
    String? token = await AuthService().readToken();
    print("COSAS");
    final url = Uri.http(_baseUrl, '/api/all/department/$id');
    print(url);
    print(id);
    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    Department departmentDTO = Department(
      id: decodedResp['id'],
      name: decodedResp['name'],
      description: decodedResp['description'],
    );

    department = departmentDTO;
    print(department.name);
    isLoading = false;
    notifyListeners();
    return department;
  }

//CREATE Department
  Future create(
    String name,
    String description,
    String price,
    int idCategory,
  ) async {
    String? token = await AuthService().readToken();
    isLoading = false;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'name': name,
      'description': description,
      'price': price,
      'idCategory': idCategory,
    };

    final url = Uri.http(_baseUrl, '/api/admin/categories/$idCategory/product');

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
  }

  //  DELETE Department
  deleteProduct(String id) async {
    String? token = await AuthService().readToken();

    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, '/api/all/Department/$id');

    final resp = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    isLoading = false;
    notifyListeners();
    if (resp.statusCode == 200) {}
  }
}
