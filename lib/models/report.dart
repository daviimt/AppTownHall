class Report {
  int? id;
  String? data;
  bool? resolution;
  int? idAppointment;

  Report({this.id, this.data, this.resolution, this.idAppointment});

  Report.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'];
    resolution = json['resolution'];
    idAppointment = json['idAppointment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['data'] = this.data;
    data['resolution'] = this.resolution;
    data['idAppointment'] = this.idAppointment;
    return data;
  }
}
