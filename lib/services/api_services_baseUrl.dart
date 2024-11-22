import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final Dio dio;
  final String serverUrl = dotenv.env['SERVER_URL'] ?? "http://your_base_url/";
  ApiService(this.dio) {
    dio.options.baseUrl = serverUrl;
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  void addInterceptors() {
    dio.interceptors.add(LogInterceptor(responseBody: true));
  }
}
