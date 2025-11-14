import 'package:dio/dio.dart';
import '../../config/constants.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchMeals() async {
    final response = await _dio.get(
      '${ApiConfig.baseUrl}/meals',
      options: Options(headers: {'X-DB-NAME': ApiConfig.dbGuid}),
    );
    return response.data;
  }

  Future<List<dynamic>> fetchCategories() async {
    final response = await _dio.get(
      '${ApiConfig.baseUrl}/categories',
      options: Options(headers: {'X-DB-NAME': ApiConfig.dbGuid}),
    );
    return response.data;
  }
}
