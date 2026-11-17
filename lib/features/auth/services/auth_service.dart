
import 'dart:convert';

import 'package:fit_track_pro/core/constants/api_constants.dart';
import 'package:fit_track_pro/core/storage/local_storage_service.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final LocalStorageService _storageService = LocalStorageService();

  Future<bool> login(String username, String password) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      // Mostrar información para depuración
      print('Código de respuesta: ${response.statusCode}');
      print('Respuesta de la API: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final token = data['accessToken'];

        if (token != null && token is String && token.isNotEmpty) {
          await _storageService.saveToken(token);
          return true;
        }
      }

      return false;
    } catch (e) {
      print('Error al iniciar sesión: $e');
      return false;
    }
  }
}