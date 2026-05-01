import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

final class ApiService {
  ApiService._();

  static Future<String> getGzippedData(String dataset) async {
    final uri = Uri.parse("https://telematics.oasa.gr/api/?act=$dataset");
    final res = await http.get(uri).timeout(const Duration(seconds: 5));
    return utf8.decode(GZipCodec().decode(res.bodyBytes));
  }
}
