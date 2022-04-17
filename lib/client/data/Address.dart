import 'package:pejskari/client/data/City.dart';

class Address {
  String? street;
  String? zip;
  List<double>? latLng;
  int? cityId;
  City? city;

  Address({this.street, this.zip, this.latLng, this.cityId, this.city});

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    zip = json['zip'];
    latLng = json['latLng'].cast<double>();
    cityId = json['city_id'];
    city = json['city'] != null ? City.fromJson(json['city']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['street'] = this.street;
    data['zip'] = this.zip;
    data['latLng'] = this.latLng;
    data['city_id'] = this.cityId;
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    return data;
  }
}