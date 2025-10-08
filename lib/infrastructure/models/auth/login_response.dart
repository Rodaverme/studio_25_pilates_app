import 'dart:convert';
import 'client_api.dart';



LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) =>
    json.encode(data.toJson());

class LoginResponse {
  String token;
  Client client;

  LoginResponse({
    required this.token,
    required this.client,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json["token"],
        client: Client.fromJson(json["client"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "client": client.toJson(),
      };
}
