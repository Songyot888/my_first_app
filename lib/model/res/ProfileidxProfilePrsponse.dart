// To parse this JSON data, do
//
//     final profileGetIdRes = profileGetIdResFromJson(jsonString);

import 'dart:convert';

ProfileGetIdRes profileGetIdResFromJson(String str) => ProfileGetIdRes.fromJson(json.decode(str));

String profileGetIdResToJson(ProfileGetIdRes data) => json.encode(data.toJson());

class ProfileGetIdRes {
    int idx;
    String fullname;
    String phone;
    String email;
    String image;

    ProfileGetIdRes({
        required this.idx,
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
    });

    factory ProfileGetIdRes.fromJson(Map<String, dynamic> json) => ProfileGetIdRes(
        idx: json["idx"],
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
    };
}
