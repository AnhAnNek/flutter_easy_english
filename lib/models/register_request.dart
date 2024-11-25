import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  final String username;
  final String password;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String gender; // Assuming EGender is a string, such as 'MALE', 'FEMALE', etc.
  final DateTime dob;

  RegisterRequest({
    required this.username,
    required this.password,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.dob,
  });

  // From JSON
  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}