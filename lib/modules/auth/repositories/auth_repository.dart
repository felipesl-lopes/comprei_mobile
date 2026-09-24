import 'dart:async';

import 'package:appshop/core/errors/auth_exception.dart';
import 'package:appshop/core/errors/http_exception.dart';
import 'package:appshop/core/services/i_http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthRepository {
  final IHttpClient client;

  AuthRepository(this.client);

  String get apiKey => dotenv.env['API_KEY'] ?? '';

  Future<Map<String, dynamic>> logar({
    required String email,
    required String password,
  }) async {
    debugPrint('[AuthRepository]: logar');

    try {
      final response = await client.post('auth/signin', body: {
        'email': email,
        'password': password,
      });

      return Map<String, dynamic>.from(response.data);
    } on AppHttpException catch (e) {
      debugPrint(e.toString());
      throw AuthException(message: e.message, code: e.statusCode.toString());
    } catch (e) {
      debugPrint(e.toString());
      throw AuthException(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> registrar({
    required String email,
    required String password,
    required String name,
  }) async {
    debugPrint('[AuthRepository]: registrar');

    try {
      final response = await client.post('auth/signup', body: {
        'email': email,
        'password': password,
        'name': name,
      });

      return Map<String, dynamic>.from(response.data);
    } on AppHttpException catch (e) {
      debugPrint(e.toString());
      throw AuthException(message: e.message, code: e.statusCode.toString());
    } catch (e) {
      debugPrint(e.toString());
      throw AuthException(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  }) async {
    debugPrint('[AuthRepository]: refreshToken');
    try {
      final response = await client.post('auth/refresh-token', body: {
        'refreshToken': refreshToken
      }).timeout(const Duration(seconds: 10));

      return Map<String, dynamic>.from(response.data);
    } on AppHttpException catch (e) {
      debugPrint(e.toString());
      throw AuthException(message: e.message, code: e.statusCode.toString());
    } catch (e) {
      debugPrint(e.toString());
      throw AuthException();
    }
  }
}
