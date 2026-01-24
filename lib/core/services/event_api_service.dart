import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:salon_der_gedanken/core/models/event.dart';
import 'package:salon_der_gedanken/core/models/provider_config.dart';

class EventApiService {
  final Dio _dio;
  
  // Base URL handling for Android Emulator vs. other platforms
  static String get _baseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    }
    return 'http://localhost:8000';
  }

  EventApiService([Dio? dio]) : _dio = dio ?? Dio(BaseOptions(baseUrl: _baseUrl));

  Future<List<ProviderConfig>> getProviders() async {
    try {
      final response = await _dio.get('/providers');
      final List<dynamic> data = response.data;
      return data.map((json) => ProviderConfig.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load providers: $e');
    }
  }

  Future<List<Event>> getEvents({String? providerId}) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (providerId != null) {
        queryParams['provider_id'] = providerId;
      }

      final response = await _dio.get(
        '/events',
        queryParameters: queryParams,
      );
      
      final List<dynamic> data = response.data;
      return data.map((json) => Event.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load events: $e');
    }
  }

  Future<Map<String, dynamic>> getStatus() async {
    try {
      final response = await _dio.get('/status');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get status: $e');
    }
  }
}
