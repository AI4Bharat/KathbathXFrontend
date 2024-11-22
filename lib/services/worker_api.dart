import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:karya_flutter/services/api_services_baseUrl.dart';

class WorkerApiService {
  final ApiService _apiService;

  WorkerApiService(this._apiService);

  Future<Response> generateOTP(String accessCode, String phoneNumber) {
    return _apiService.dio.put(
      '/worker/otp/generate',
      options: Options(headers: {
        'access-code': accessCode,
        'phone-number': phoneNumber,
      }),
    );
  }

  Future<Response> resendOTP(String accessCode, String phoneNumber) {
    return _apiService.dio.put(
      '/worker/otp/resend',
      options: Options(headers: {
        'access-code': accessCode,
        'phone-number': phoneNumber,
      }),
    );
  }

  Future<Response<String>> verifyOTP(
      String accessCode, String phoneNumber, String otp) {
    return _apiService.dio.put<String>(
      '/worker/otp/verify',
      options: Options(headers: {
        'access-code': accessCode,
        'phone-number': phoneNumber,
        'otp': otp,
      }),
    );
  }

  Future<Response> userRegistration(Map<String, dynamic> userData) {
    print("Send data: ${jsonEncode(userData)}");
    return _apiService.dio.post(
      '/worker/create',
      options: Options(method: 'POST', headers: {
        'Content-Type': 'application/json',
      }),
      data: jsonEncode(userData),
    );
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
