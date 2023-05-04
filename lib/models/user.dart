class User {
  int? id;
  String? username;
  String? password;
  String? name;
  String? surname;
  String? dni;
  bool? enabled;
  String? role;
  String? token;
  int? idDepartment;

  User(
      {this.id,
      this.username,
      this.password,
      this.name,
      this.surname,
      this.dni,
      this.enabled,
      this.role,
      this.token,
      this.idDepartment});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    name = json['name'];
    surname = json['surname'];
    dni = json['dni'];
    enabled = json['enabled'];
    role = json['role'];
    token = json['token'];
    idDepartment = json['idDepartment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['password'] = this.password;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['dni'] = this.dni;
    data['enabled'] = this.enabled;
    data['role'] = this.role;
    data['token'] = this.token;
    data['idDepartment'] = this.idDepartment;
    return data;
  }
}
