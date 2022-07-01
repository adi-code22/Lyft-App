// To parse this JSON data, do
//
//     final bids = bidsFromJson(jsonString);

import 'dart:convert';

List<Bids> bidsFromJson(String str) =>
    List<Bids>.from(json.decode(str).map((x) => Bids.fromJson(x)));

String bidsToJson(List<Bids> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bids {
  Bids({
    required this.name,
    required this.vehicleNo,
    required this.amount,
  });

  String name;
  String vehicleNo;
  String amount;

  factory Bids.fromJson(Map<String, dynamic> json) => Bids(
        name: json["name"],
        vehicleNo: json["vehicle_no"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "vehicle_no": vehicleNo,
        "amount": amount,
      };
}
