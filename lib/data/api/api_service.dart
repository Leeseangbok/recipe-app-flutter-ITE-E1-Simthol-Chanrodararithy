import 'package:http/http.dart' as http;
import '../../util/constants.dart';

class ApiService {
  final String baseUrl;
  final Map<String,String> defaultHeaders;

  ApiService({this.baseUrl = API_BASE})
      : defaultHeaders = {
        'Content-Type': 'application/json',
        'X-DB-NAME': X_DB_NAME,
      };

  Uri _uri(String path, [Map<String,String>? params]) {
    final uri = Uri.parse('$baseUrl$path');
    if (params == null) return uri;
    return uri.replace(queryParameters: params);
  }

  Future<http.Response> get(String path, {Map<String,String>? params}) async {
    final uri = _uri(path, params);
    final resp = await http.get(uri, headers: defaultHeaders);
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return resp;
    } else {
      throw Exception('GET $uri failed with code ${resp.statusCode}');
    }
  }
}
