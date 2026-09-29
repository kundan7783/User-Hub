import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {'x-api-key': ApiConstants.apiKey},
    ),
  );

  Future<Response> getUsers({required int page, required int perPage}) async {
    try {
      final response = await _dio.get(
        ApiConstants.users,
        queryParameters: {'page': page, 'per_page': perPage},
      );
      return response;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['error'] ?? e.message ?? 'Something went wrong',
      );
    }
  }
}
