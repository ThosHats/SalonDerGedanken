import 'package:dio/dio.dart';
import 'package:salon_der_gedanken/core/models/event.dart';
import 'package:salon_der_gedanken/core/models/provider_config.dart';

class EventApiService {
  final Dio _dio;
  
  static String get _baseUrl {
    return 'https://salondergedanken.bw-papenburg-archiv.de';
  }

  EventApiService([Dio? dio]) : _dio = dio ?? Dio(BaseOptions(baseUrl: _baseUrl));

  Future<List<ProviderConfig>> getProviders() async {
    try {
      final response = await _dio.get('/providers');
      final Map<String, dynamic> data = response.data;
      final List<dynamic> providers = data['providers'];
      return providers.map((json) => ProviderConfig.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load providers: $e');
    }
  }

  Future<List<Event>> getEvents({
    String? providerId,
    String? date,
    String? from,
    String? to,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (providerId != null) queryParams['provider_id'] = providerId;
      if (date != null) queryParams['date'] = date;
      if (from != null) queryParams['from'] = from;
      if (to != null) queryParams['to'] = to;

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
