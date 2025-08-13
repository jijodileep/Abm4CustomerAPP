import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HttpClient {
  static const Duration _timeout = Duration(seconds: 30);
  
  static Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?headers,
        },
      ).timeout(_timeout);
      
      return response;
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}. Please check your internet connection.');
    } on HttpException catch (e) {
      throw NetworkException('HTTP error: ${e.message}');
    } on FormatException catch (e) {
      throw NetworkException('Data format error: ${e.message}');
    } on TimeoutException catch (e) {
      throw NetworkException('Request timeout: ${e.message}. Please try again.');
    } catch (e) {
      throw NetworkException('Unexpected error: $e');
    }
  }
  
  static Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?headers,
        },
        body: body != null ? json.encode(body) : null,
      ).timeout(_timeout);
      
      return response;
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}. Please check your internet connection.');
    } on HttpException catch (e) {
      throw NetworkException('HTTP error: ${e.message}');
    } on FormatException catch (e) {
      throw NetworkException('Data format error: ${e.message}');
    } on TimeoutException catch (e) {
      throw NetworkException('Request timeout: ${e.message}. Please try again.');
    } catch (e) {
      throw NetworkException('Unexpected error: $e');
    }
  }
  
  static Future<http.Response> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?headers,
        },
        body: body != null ? json.encode(body) : null,
      ).timeout(_timeout);
      
      return response;
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}. Please check your internet connection.');
    } on HttpException catch (e) {
      throw NetworkException('HTTP error: ${e.message}');
    } on FormatException catch (e) {
      throw NetworkException('Data format error: ${e.message}');
    } on TimeoutException catch (e) {
      throw NetworkException('Request timeout: ${e.message}. Please try again.');
    } catch (e) {
      throw NetworkException('Unexpected error: $e');
    }
  }
  
  static Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?headers,
        },
        body: body != null ? json.encode(body) : null,
      ).timeout(_timeout);
      
      return response;
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}. Please check your internet connection.');
    } on HttpException catch (e) {
      throw NetworkException('HTTP error: ${e.message}');
    } on FormatException catch (e) {
      throw NetworkException('Data format error: ${e.message}');
    } on TimeoutException catch (e) {
      throw NetworkException('Request timeout: ${e.message}. Please try again.');
    } catch (e) {
      throw NetworkException('Unexpected error: $e');
    }
  }
}

class NetworkException implements Exception {
  final String message;
  
  NetworkException(this.message);
  
  @override
  String toString() => 'NetworkException: $message';
}