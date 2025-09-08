// To parse this JSON data, do
//
//     final tripGetResponseFromJson = tripGetResponseFromJsonFromJson(jsonString);

import 'dart:convert';

List<TripGetResponseFromJson> tripGetResponseFromJsonFromJson(String str) =>
    List<TripGetResponseFromJson>.from(
      json.decode(str).map((x) => TripGetResponseFromJson.fromJson(x)),
    );

String tripGetResponseFromJsonToJson(List<TripGetResponseFromJson> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripGetResponseFromJson {
  int idx;
  String name;
  String country;
  String coverimage;
  String detail;
  int price;
  int duration;
  String destinationZone;

  TripGetResponseFromJson({
    required this.idx,
    required this.name,
    required this.country,
    required this.coverimage,
    required this.detail,
    required this.price,
    required this.duration,
    required this.destinationZone,
  });

  factory TripGetResponseFromJson.fromJson(Map<String, dynamic> json) =>
      TripGetResponseFromJson(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        coverimage: json["coverimage"],
        detail: json["detail"],
        price: json["price"],
        duration: json["duration"],
        destinationZone: json["destination_zone"],
      );

  Map<String, dynamic> toJson() => {
    "idx": idx,
    "name": name,
    "country": country,
    "coverimage": coverimage,
    "detail": detail,
    "price": price,
    "duration": duration,
    "destination_zone": destinationZone,
  };
}
