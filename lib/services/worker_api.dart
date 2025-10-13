import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kathbath_lite/models/registration_items.dart';
import 'package:kathbath_lite/services/api_services_baseUrl.dart';

class WorkerApiService {
  final ApiService _apiService;

  WorkerApiService(this._apiService);

  Future<RegistrationResponse> generateOTP(
      String accessCode, String phoneNumber) async {
    try {
      await _apiService.dio.put(
        '/worker/otp/generate',
        options: Options(headers: {
          'access-code': accessCode,
          'phone-number': phoneNumber,
        }),
      );
      return const RegistrationResponse.success(null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        return const RegistrationResponse(
            responseCode: 408,
            message: "Please check you internet.",
            details: {});
      }
      if (e.response == null) {
        return const RegistrationResponse.tryAgain();
      }
      if (e.response!.statusCode == 400 || e.response!.statusCode == 401) {
        return RegistrationResponse.badRequst(
            e.response!.data ?? "OTP generation failed");
      }

      return const RegistrationResponse.tryAgain();
    }
  }

  Future<RegistrationResponse> resendOTP(String accessCode) async {
    try {
      await _apiService.dio.put(
        '/worker/otp/resend',
        options: Options(headers: {
          'access-code': accessCode,
        }),
      );
      return const RegistrationResponse.success(null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        return const RegistrationResponse(
            responseCode: 408,
            message: "Please check you internet.",
            details: {});
      }
      if (e.response == null) {
        return const RegistrationResponse.tryAgain();
      }
      if (e.response!.statusCode == 400 || e.response!.statusCode == 401) {
        return RegistrationResponse.badRequst(
            e.response!.data ?? "Resending OTP/Passcode failed");
      }
      print("Resent otp is called ${e.response}");
      return const RegistrationResponse.tryAgain();
    }
  }

  Future<RegistrationResponse> verifyOTP(String accessCode, String otp) async {
    try {
      final response = await _apiService.dio.put<String>(
        '/worker/otp/verify',
        options: Options(headers: {
          'access-code': accessCode,
          'otp': otp,
        }),
      );
      if (response.data == null) {
        return const RegistrationResponse(
            responseCode: 500,
            message: "Server issue please contact the admins",
            details: {});
      }

      final Map<String, dynamic> responseData = jsonDecode(response.data!);
      if (!responseData.containsKey("id_token") ||
          responseData["id_token"] == "") {
        return const RegistrationResponse(
            responseCode: 500,
            message: "Server issue please contact the admins",
            details: {});
      }
      return RegistrationResponse.success(responseData);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        return const RegistrationResponse(
            responseCode: 408,
            message: "Please check you internet.",
            details: {});
      }
      if (e.response == null) {
        return const RegistrationResponse.tryAgain();
      }
      if (e.response!.statusCode == 400 || e.response!.statusCode == 401) {
        return RegistrationResponse.badRequst(
            e.response!.data ?? "OTP/Passcode verification failed");
      }
      return const RegistrationResponse.tryAgain();
    }
  }

  Future<RegistrationResponse> userRegistration(FormData formData) async {
    try {
      var resp = await _apiService.dio.post(
        '/worker',
        options: Options(method: 'POST', headers: {
          'Content-Type': 'multipart/form-data',
        }),
        data: formData,
      );
      return const RegistrationResponse.success(null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        return const RegistrationResponse(
            responseCode: 408,
            message: "Please check you internet.",
            details: {});
      }
      if (e.response == null) {
        return const RegistrationResponse.tryAgain();
      }
      if (e.response!.statusCode == 400) {
        return RegistrationResponse.badRequst(
            e.response!.data ?? "Registration failed");
      } else if (e.response!.statusCode == 422) {
        Map<String, dynamic> validationErrors = jsonDecode(e.response!.data);
        return RegistrationResponse(
            responseCode: 422,
            message: "Please check the inputs",
            details: validationErrors);
      }
      return const RegistrationResponse.tryAgain();
    }
  }

  Future<Response> getWorkerDetails(String accessCode) {
    return _apiService.dio.get(
      '/worker',
      options: Options(
          method: 'POST',
          headers: {'access-code': accessCode, 'version': '97'}),
    );
  }

  Future<Response> sendReferrerLink(String refLink) {
    return _apiService.dio.post(
      '/referral/submit_info',
      queryParameters: {'refLink': refLink},
      options: Options(
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
      ),
      data: json.encode({'referralUrl': refLink}),
    );
  }
}
