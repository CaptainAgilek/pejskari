class City {
  String? name;
  int? id;
  int? districtId;

  City({this.name, this.id, this.districtId});

  City.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    districtId = json['district_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['district_id'] = this.districtId;
    return data;
  }
}