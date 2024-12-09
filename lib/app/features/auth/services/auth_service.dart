import 'package:dio/dio.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/models/auth_user.dart';
import 'package:talkie/app/features/auth/models/login_response.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:talkie/app/features/auth/models/phone_request.dart';
import 'package:talkie/app/features/auth/models/send_verification_code_response.dart';
import 'package:talkie/app/features/auth/models/verify_account_response.dart';

enum AuthMethod { email, phone }

class AuthService {
  static Future<LoginResponse> login({
    required String? email,
    required PhoneRequest? phone,
    required String password,
    required AuthMethod type,
  }) async {
    try {
      Map<String, dynamic> form = {
        "phone": phone?.toJson(),
        "email": email,
        "password": password,
        "type": type.toString().split('.').last,
      };

      final response = await Api.post('/auth/login', data: form);

      return LoginResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while trying to log in.', e);
    }
  }

  static Future<LoginResponse> register({
    required String name,
    required String surname,
    required String? email,
    required PhoneRequest? phone,
    required String password,
    required AuthMethod type,
    required String verificationCode,
  }) async {
    try {
      Map<String, dynamic> form = {
        "name": name,
        "surname": surname,
        "email": email,
        "phone": phone?.toJson(),
        "password": password,
        "type": type.toString().split('.').last,
        "verificationCode": verificationCode,
      };

      final response = await Api.post('/auth/register', data: form);

      return LoginResponse.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        print(e.response);
      }
      throw ServiceException('An error occurred while trying to register.', e);
    }
  }

  static Future<AuthUser> getProfile() async {
    try {
      final response = await Api.get('/user/profile');

      return AuthUser.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while loading the user.', e);
    }
  }

  static Future<VerifyAccountResponse> verifyAccount({
    required String? email,
    required PhoneRequest? phone,
    required AuthMethod type,
  }) async {
    try {
      Map<String, dynamic> form = {
        "phone": phone?.toJson(),
        "email": email,
        "type": type.toString().split('.').last,
      };

      final response = await Api.post('/auth/verify-account', data: form);

      return VerifyAccountResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while verify the phone.', e);
    }
  }

  static Future<SendVerificationCodeResponse> sendVerificationCode({
    required String? email,
    required PhoneRequest? phone,
    required AuthMethod type,
  }) async {
    try {
      Map<String, dynamic> form = {
        "phone": phone?.toJson(),
        "email": email,
        "type": type.toString().split('.').last,
      };

      final response =
          await Api.post('/auth/send-verification-code', data: form);

      return SendVerificationCodeResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(
          'An error occurred while sending the verification code.', e);
    }
  }

  static Future<AuthUser> updateProfile({
    required String name,
    required String surname,
    required String email,
    required String phone,
  }) async {
    try {
      Map<String, dynamic> form = {
        "name": name,
        "surname": surname,
        "email": email,
        "phone": phone,
      };
      final response = await Api.put('/user/profile', data: form);

      return AuthUser.fromJson(response.data);
    } catch (e) {
      throw ServiceException(
          'An error occurred while changing the personal data.', e);
    }
  }

  static Future<(bool, int)> verifyToken() async {
    final token = await StorageService.get<String>(StorageKeys.token);
    if (token == null) return (false, 0);

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    // Obtiene la marca de tiempo de expiración del token
    int expirationTimestamp = decodedToken['exp'];

    // Obtiene la marca de tiempo actual
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    //si el token es invalido

    // Calcula el tiempo restante hasta la expiración en segundos
    int timeRemainingInSeconds = expirationTimestamp - currentTimestamp;

    if (timeRemainingInSeconds <= 0) {
      return (false, 0);
    }
    return (true, timeRemainingInSeconds);
  }
}
