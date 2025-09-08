// To parse this JSON data, do
//
//     final customerRegisterPostRequest = customerRegisterPostRequestFromJson(jsonString);

import 'dart:convert';

CustomerRegisterPostRequest customerRegisterPostRequestFromJson(String str) => CustomerRegisterPostRequest.fromJson(json.decode(str));

String customerRegisterPostRequestToJson(CustomerRegisterPostRequest data) => json.encode(data.toJson());

class CustomerRegisterPostRequest {
    String message;
    Customer customer;

    CustomerRegisterPostRequest({
        required this.message,
        required this.customer,
    });

    factory CustomerRegisterPostRequest.fromJson(Map<String, dynamic> json) => CustomerRegisterPostRequest(
        message: json["message"],
        customer: Customer.fromJson(json["customer"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "customer": customer.toJson(),
    };
}

class Customer {
    int idx;
    String fullname;
    String phone;
    String email;
    String image;

    Customer({
        required this.idx,
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
    });

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
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
