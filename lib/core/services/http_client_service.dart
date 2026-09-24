import 'dart:convert';

import 'package:appshop/core/errors/http_exception.dart';
import 'package:appshop/core/services/http_response.dart';
import 'package:appshop/core/services/i_http_client.dart';
import 'package:http/http.dart' as http;

class HttpClientService implements IHttpClient {
  final String baseUrl;
  final String? Function() getToken;

  HttpClientService({
    required this.baseUrl,
    required this.getToken,
  });

  Map<String, String> _defaultHeaders() {
    return {
      'Content-Type': 'application/json',
    };
  }

  Uri _buildUri(String path, [Map<String, dynamic>? query]) {
    final token = getToken();

    final queryParams = {
      if (query != null) ...query.map((k, v) => MapEntry(k, v.toString())),
      if (token != null) 'auth': token,
    };

    return Uri.parse('$baseUrl/$path').replace(
      queryParameters: queryParams,
    );
  }

  HttpResponse _handleResponse(http.Response response) {
    final httpResponse = _parseResponse(response);

    if (!httpResponse.isSuccess) {
      throw AppHttpException(
        message: _extractErrorMessage(httpResponse),
        statusCode: httpResponse.statusCode,
        data: httpResponse.data,
      );
    }

    return httpResponse;
  }

  dynamic _tryDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  HttpResponse _parseResponse(http.Response response) {
    final data = response.body.isNotEmpty ? _tryDecode(response.body) : null;
    return HttpResponse(
      data: data,
      statusCode: response.statusCode,
      headers: response.headers,
      statusMessage: response.reasonPhrase,
    );
  }

  String _extractErrorMessage(HttpResponse response) {
    final data = response.data;

    if (data is Map) {
      final message = data['message'] ?? data['error'];

      if (message is String && message.isNotEmpty) {
        return message;
      }

      if (message is List && message.isNotEmpty) {
        return message.join('\n');
      }
    }

    return response.statusMessage ?? 'Erro HTTP: ${response.statusCode}';
  }

  @override
  Future<HttpResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool validateStatus = true,
  }) async {
    final response = await http.get(
      _buildUri(path, queryParameters),
      headers: _defaultHeaders(),
    );

    return validateStatus ? _handleResponse(response) : _parseResponse(response);
  }

  @override
  Future<HttpResponse> post(String path,
      {dynamic body, Map<String, dynamic>? queryParameters}) async {
    final response = await http.post(
      _buildUri(path, queryParameters),
      headers: _defaultHeaders(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  @override
  Future<HttpResponse> put(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    bool validateStatus = true,
  }) async {
    final response = await http.put(
      _buildUri(path, queryParameters),
      headers: _defaultHeaders(),
      body: jsonEncode(body),
    );

    return validateStatus ? _handleResponse(response) : _parseResponse(response);
  }

  @override
  Future<HttpResponse> postAbsolute(
    String url, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse(url);
    final Object? encodedBody = body is Map<String, String>
        ? body
        : (body is String ? body : jsonEncode(body));
    final response = await http.post(
      uri,
      headers: headers,
      body: encodedBody,
    );
    return _parseResponse(response);
  }

  @override
  Future<HttpResponse> patch(String path, {dynamic body}) async {
    final response = await http.patch(
      _buildUri(path),
      headers: _defaultHeaders(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  @override
  Future<HttpResponse> delete(String path, {dynamic body}) async {
    if (!path.contains('/')) {
      throw Exception('DELETE precisa de um ID no path');
    }

    final response = await http.delete(
      _buildUri(path),
      headers: _defaultHeaders(),
      body: body != null ? jsonEncode(body) : null,
    );

    return _handleResponse(response);
  }
}
