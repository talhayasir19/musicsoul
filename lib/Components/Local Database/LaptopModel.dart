import 'dart:convert';

class LaptopModel {
  int? Id;
  String? Model;
  int? Price;
  LaptopModel({
    this.Id,
    this.Model,
    this.Price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Id': Id,
      'Model': Model,
      'Price': Price,
    };
  }

  factory LaptopModel.fromMap(Map<String, dynamic> map) {
    return LaptopModel(
      Id: map['Id'] != null ? map['Id'] as int : null,
      Model: map['Model'] != null ? map['Model'] as String : null,
      Price: map['Price'] != null ? map['Price'] as int : null,
    );
  }
}
