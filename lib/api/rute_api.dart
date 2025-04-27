import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> searchRute({
  required String category,
  required String start,
  required String end,
  required String tanggal,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) {
    print('Token tidak ditemukan!');
    return;
  }

  final url = Uri.parse('http://127.0.0.1:8000/api/search-rute');

  final response = await http.get(
    url.replace(queryParameters: {
      'category': category,
      'start': start,
      'end': end,
      'tanggal': tanggal,
    }),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('Hasil: $data');
  } else {
    print('Gagal: ${response.statusCode}');
    print('Respon: ${response.body}');
  }
}
