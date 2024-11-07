import 'package:flutter_easy_english/models/reset_pass_with_otp_req.dart';
import 'package:flutter_easy_english/models/user_dto.dart';
import 'package:flutter_easy_english/models/login_response.dart';
import 'package:flutter_easy_english/models/active_account_response.dart';
import 'package:flutter_easy_english/models/register_request.dart';
import 'package:flutter_easy_english/models/login_request.dart';
import 'package:flutter_easy_english/models/otp_request.dart';
import 'package:flutter_easy_english/models/update_password_request.dart';

abstract class IAuthService {
  Future<String> register(RegisterRequest registerRequest);
  Future<String> generateOtpToLogin(LoginRequest loginRequest);
  Future<LoginResponse> loginWithOtp(OtpRequest otpRequest);
  Future<LoginResponse> login(LoginRequest loginRequest);
  Future<String> logout();
  Future<UserDTO> getUserByToken(String token);
  Future<UserDTO> updateOwnPassword(UpdatePasswordRequest updatePasswordRequest);
  Future<UserDTO> resendOtpToActiveAccount(String username);
  Future<ActiveAccountResponse> activateAccount(OtpRequest otpRequest);
  Future<String> generateOtpToUpdateProfile(String username);
  Future<String> generateOtpToResetPassword(String email);
  Future<String> resetPasswordWithOtp(ResetPassWithOtpReq req);
}
