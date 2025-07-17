import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/perpustakaan.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.18.241:8000/api/perpustakaan';

  static Future<List<Perpustakaan>> fetchPerpustakaan() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Perpustakaan.fromJson(e)).toList();
    } else {
      throw Exception('Gagal load data');
    }
  }

  static Future<Perpustakaan> createPerpustakaan(Perpustakaan perpustakaan) async {
    final response = await http.post(Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(perpustakaan.toJson()));
    if (response.statusCode == 201) {
      return Perpustakaan.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal tambah data');
    }
  }

  static Future<void> deletePerpustakaan(int no) async {
    final response = await http.delete(Uri.parse('$baseUrl/$no'));
    if (response.statusCode != 200) throw Exception('Gagal hapus data');
  }

  static Future<Perpustakaan> updatePerpustakaan(int no, Perpustakaan perpustakaan) async {
    final response = await http.put(Uri.parse('$baseUrl/$no'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(perpustakaan.toJson()));
    if (response.statusCode == 200) {
      return Perpustakaan.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal update data');
    }
  }
}
