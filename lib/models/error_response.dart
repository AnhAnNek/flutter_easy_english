import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ErrorResponse {
  final String message;
  final int statusCode;

  ErrorResponse({required this.message, required this.statusCode});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'],
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'statusCode': statusCode,
    };
  }
}