// ignore_for_file: file_names

import '../../utils/strings.dart';

class UserModel {
  String? uid, email, name, phoneNumber, address, zipCode, age, country, ethnicity;

  UserModel({this.uid, this.email, this.name, this.phoneNumber, this.address, this.zipCode, this.age, this.country, this.ethnicity});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(uid: json[ID], email: json[EMAIL], phoneNumber: json[PHONENUMBER], address: json[ADDRESS], zipCode: json[ZIPCODE], age: json[AGE], country: json[COUNTRY], ethnicity: json[ETHNICITY], name: json[NAME]);
  }

  Map<String, dynamic> toMap() => {
    "uid": uid,
    "email": email,
    "phoneNumber": phoneNumber,
    "address": address,
    "zipCode": zipCode,
    "age": age,
    "country": country,
    "ethnicity": ethnicity,
    "name": name
  };

  factory UserModel.fromMapObject(Map<Object?, Object?> json) => UserModel(
    uid: json["uid"] == null ? "" : json["uid"].toString(),
    email: json["email"] == null ? "" : json["email"].toString(),
    phoneNumber: json["phoneNumber"] == null ? "" : json["phoneNumber"].toString(),
    address: json["address"] == null ? "" : json["address"].toString(),
    zipCode: json["zipCode"] == null ? "" : json["zipCode"].toString(),
    age: json["age"] == null ? "" : json["age"].toString(),
    country: json["country"] == null ? "" : json["country"].toString(),
    ethnicity: json["ethnicity"] == null ? "" : json["ethnicity"].toString(),
    name: json["name"] == null ? "" : json["name"].toString()
  );
}
