class Appointment {
  int? id;
  int? idUser;
  int? idManager;
  int? idDepartment;
  String? hour;
  String? date;

  Appointment(
      {this.id,
      this.idUser,
      this.idManager,
      this.idDepartment,
      this.hour,
      this.date});

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUser = json['idUser'];
    idManager = json['idManager'];
    idDepartment = json['idDepartment'];
    hour = json['hour'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idUser'] = this.idUser;
    data['idManager'] = this.idManager;
    data['idDepartment'] = this.idDepartment;
    data['hour'] = this.hour;
    data['date'] = this.date;
    return data;
  }
}
