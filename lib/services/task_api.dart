import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:karya_flutter/data/database/utility/table_utility.dart';
import 'package:karya_flutter/data/manager/karya_db.dart';
import 'dart:convert';

import 'package:karya_flutter/services/api_services_baseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MicroTaskAssignmentService {
  final ApiService _apiService;
  late String idToken;
  bool _isInitialized = false;

  MicroTaskAssignmentService(this._apiService) {
    _initializeIdToken();
  }

  Future<void> _initializeIdToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    idToken = prefs.getString('id_token') ?? '';
    _isInitialized = true;
  }

  Future<Response> submitCompletedAssignments(
    List<MicroTaskAssignmentRecord> updates,
  ) async {
    if (!_isInitialized) {
      await _initializeIdToken();
    }
    List<Map<String, dynamic>> jsonList = updates
        .map((record) => UtilityClass().mTaskAssignmentRecordToJson1(record))
        .toList();
    // log("submitting json: ${jsonEncode(jsonList)}");
    final response = await _apiService.dio.put(
      '/assignments',
      data: json.encode(jsonList),
      options: Options(
        headers: {
          'karya-id-token': idToken,
          'version': '97',
        },
      ),
    );
    return response;
  }

  Future<Response<List<String>>> submitSkippedAssignments(
    List<MicroTaskAssignmentRecord> ids,
  ) async {
    if (!_isInitialized) {
      await _initializeIdToken();
    }
    final response = await _apiService.dio.put<List<String>>(
      '/skipped_expired_assignments',
      data: json.encode(ids.map((e) => e.toJson()).toList()),
      options: Options(
        headers: {
          'karya-id-token': idToken,
        },
      ),
    );
    return response;
  }

  Future<Map<String, dynamic>> getNewAssignments(
    String from, {
    String type = 'new',
  }) async {
    if (!_isInitialized) {
      await _initializeIdToken();
    }
    final response = await _apiService.dio.get(
      '/assignments',
      queryParameters: {
        'from': from,
        'type': type,
      },
      options: Options(
        headers: {
          'karya-id-token': idToken,
          'version': '97', // Update to your version
        },
      ),
    );
    if (response.statusCode == 200) {
      final jsonData = response.data;
      log('Received JSON Data: $jsonData');
      return jsonData;
    } else {
      return {};
    }
  }

  Future<Response<List<MicroTaskAssignmentRecord>>> getVerifiedAssignments(
    String from, {
    String type = 'verified',
  }) async {
    if (!_isInitialized) {
      await _initializeIdToken();
    }
    final response = await _apiService.dio.get<List<MicroTaskAssignmentRecord>>(
      '/assignments',
      queryParameters: {
        'from': from,
        'type': type,
      },
      options: Options(
        headers: {
          'karya-id-token': idToken,
          'version': '1.0.0',
        },
      ),
    );
    return response;
  }

  Future<Response> submitAssignmentOutputFile(
    String id,
    String jsonData,
    String filePath,
  ) async {
    if (!_isInitialized) {
      await _initializeIdToken();
    }
    var data = FormData.fromMap({
      'file': [await MultipartFile.fromFile(filePath, filename: filePath)],
      'data': jsonData,
    });

    final response = await _apiService.dio.request(
      '/assignment/$id/output_file',
      options: Options(
        method: 'POST',
        headers: {
          'karya-id-token': idToken,
        },
      ),
      data: data,
    );
    return response;
  }

  Future<Uint8List> getInputFile(
    String assignmentId,
  ) async {
    try {
      if (!_isInitialized) {
        await _initializeIdToken();
      }
      Response response = await _apiService.dio.request(
        '/assignment/$assignmentId/input_file',
        options: Options(
            method: 'GET',
            headers: {
              'karya-id-token': idToken,
            },
            responseType: ResponseType.bytes),
      );
      // if (response.statusCode == 200) {
      //   log("response data:${response.data}");
      // } else {
      //   log(response.statusMessage);
      // }
      return response.data;
    } catch (e) {
      log("Error fetching the file $e");
      return Uint8List(0);
    }
  }
}
