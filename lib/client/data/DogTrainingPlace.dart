import 'package:pejskari/client/data/Address.dart';

class DogTrainingPlace {
  String? name;
  int? type;
  int? id;
  String? slug;
  int? addressId;
  Address? address;

  DogTrainingPlace({
    this.name,
    this.type,
    this.id,
    this.slug,
    this.addressId,
    this.address,
  });

  DogTrainingPlace.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    id = json['id'];
    slug = json['slug'];
    addressId = json['address_id'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['address_id'] = this.addressId;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    return data;
  }
}
