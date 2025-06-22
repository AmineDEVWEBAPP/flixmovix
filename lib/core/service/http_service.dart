import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static Future<Response> getRequest(String url,
      {Map<String, String>? headers}) async {
    headers ??= {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.5735.199 Safari/537.36 Edg/114.0.1823.79',
    };
    Response response = await http.get(Uri.parse(url), headers: headers);
    return response;
  }
}
