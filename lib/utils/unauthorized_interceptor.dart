import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TokenInterceptor extends Interceptor {
  final GlobalKey<NavigatorState> navigatorKey;

  TokenInterceptor(this.navigatorKey);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      final context = navigatorKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Session expired. Please login again.")),
        );
        // Optionally: Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
      }
    }
    super.onError(err, handler);
  }
}
