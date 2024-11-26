import 'package:json_annotation/json_annotation.dart';

import 'user_dto.dart';

part 'active_account_response.g.dart';

@JsonSerializable()
class ActiveAccountResponse {
  final String message;
  final UserDTO user;

  ActiveAccountResponse({
    required this.message,
    required this.user,
  });

  // Factory constructor to create an instance from a JSON map
  factory ActiveAccountResponse.fromJson(Map<String, dynamic> json) => _$ActiveAccountResponseFromJson(json);

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() => _$ActiveAccountResponseToJson(this);
}
