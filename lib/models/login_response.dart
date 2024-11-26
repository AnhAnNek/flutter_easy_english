import 'package:json_annotation/json_annotation.dart';

import 'user_dto.dart';

part 'login_response.g.dart';  // Link to the generated file

@JsonSerializable()
class LoginResponse {
  final String message;
  final String tokenType;
  final String tokenStr;
  final UserDTO user;

  LoginResponse({
    required this.message,
    required this.tokenType,
    required this.tokenStr,
    required this.user,
  });

  // Factory method for creating an instance from JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

  // Method for converting the instance back to JSON
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
