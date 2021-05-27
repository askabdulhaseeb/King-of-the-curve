class InstituteModel {
  String created;
  String createdAt;
  String id;
  String institutionName;

  InstituteModel({this.created, this.createdAt, this.id, this.institutionName});

  InstituteModel.fromJson(Map<String, dynamic> json) {
    created = json['created'].toString();
    createdAt = json['createdAt'].toString();
    id = json['id'].toString();
    institutionName = json['institution_name'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created'] = this.created;
    data['createdAt'] = this.createdAt;
    data['id'] = this.id;
    data['institution_name'] = this.institutionName;
    return data;
  }
}