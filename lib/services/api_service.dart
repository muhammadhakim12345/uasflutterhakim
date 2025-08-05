import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usashakim.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Get all Usashakim data
  static Future<List<Usashakim>> getUsashakimList() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/usashakim'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          List<dynamic> usashakimList = data['data'];
          return usashakimList.map((json) => Usashakim.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load Usashakim data');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Create new Usashakim
  static Future<Usashakim> createUsashakim(String nama, String nobp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/usashakim'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'nama': nama,
          'nobp': nobp,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return Usashakim.fromJson(data['data']);
        }
      }
      throw Exception('Failed to create Usashakim');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update Usashakim
  static Future<Usashakim> updateUsashakim(int id, String nama, String nobp) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/usashakim/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'nama': nama,
          'nobp': nobp,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return Usashakim.fromJson(data['data']);
        }
      }
      throw Exception('Failed to update Usashakim');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Delete Usashakim
  static Future<bool> deleteUsashakim(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/usashakim/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['success'] == true;
      }
      throw Exception('Failed to delete Usashakim');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get single Usashakim
  static Future<Usashakim> getUsashakim(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/usashakim/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return Usashakim.fromJson(data['data']);
        }
      }
      throw Exception('Failed to load Usashakim data');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
} 