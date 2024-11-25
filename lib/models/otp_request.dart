import 'package:json_annotation/json_annotation.dart';

part 'otp_request.g.dart';

@JsonSerializable()
class OtpRequest {
  final String username;
  final String otp;

  OtpRequest({
    required this.username,
    required this.otp,
  });

  // From JSON
  factory OtpRequest.fromJson(Map<String, dynamic> json) => _$OtpRequestFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$OtpRequestToJson(this);
}