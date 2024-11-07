import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'user_dto.g.dart';

enum EGender { MALE, FEMALE, OTHER }

enum ERole { STUDENT, TEACHER, ADMIN }

@JsonSerializable(explicitToJson: true)
class UserDTO {
  final String username;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String bio;
  final EGender gender;
  final DateTime dob; // DateTime for LocalDate
  final ERole? role;
  final DateTime createdAt;
  final String? avatarPath;

  UserDTO({
    required this.username,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.bio,
    required this.gender,
    required this.dob,
    this.role,
    required this.createdAt,
    this.avatarPath,
  });

  // Factory constructor to create an instance from a JSON map
  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson(json);

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() => _$UserDTOToJson(this);

  // Custom date format for dateOfBirth and createdAt
  String getFormattedDob() => DateFormat('yyyy-MM-dd').format(dob);
  String getFormattedCreatedAt() => DateFormat('yyyy-MM-ddTHH:mm:ss').format(createdAt);
}
