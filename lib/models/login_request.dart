import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  final String usernameOrEmail;
  final String password;

  LoginRequest({
    required this.usernameOrEmail,
    required this.password,
  });

  // From JSON
  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}