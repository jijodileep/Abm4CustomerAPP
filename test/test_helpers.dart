import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'package:abm4_customerapp/services/api_service.dart';
import 'package:abm4_customerapp/services/cache_service.dart';
import 'package:abm4_customerapp/services/network_service.dart';
import 'package:abm4_customerapp/features/auth/models/user.dart';

// Mock classes for testing
class MockApiService extends Mock implements ApiService {
  @override
  Future<Response<T>> postCustomerLogin<T>(
    String fullUrl, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      super.noSuchMethod(
        Invocation.method(#postCustomerLogin, [fullUrl], {
          #data: data,
          #queryParameters: queryParameters,
          #options: options,
        }),
        returnValue: Future.value(Response<T>(
          data: {} as T,
          requestOptions: RequestOptions(path: fullUrl),
          statusCode: 200,
        )),
      );

  @override
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      super.noSuchMethod(
        Invocation.method(#post, [path], {
          #data: data,
          #queryParameters: queryParameters,
          #options: options,
        }),
        returnValue: Future.value(Response<T>(
          data: {} as T,
          requestOptions: RequestOptions(path: path),
          statusCode: 200,
        )),
      );

  @override
  void setAuthToken(String token) => super.noSuchMethod(
        Invocation.method(#setAuthToken, [token]),
        returnValueForMissingStub: null,
      );

  @override
  void removeAuthToken() => super.noSuchMethod(
        Invocation.method(#removeAuthToken, []),
        returnValueForMissingStub: null,
      );
}


class MockCacheService extends Mock implements CacheService {
  @override
  Future<void> init() => super.noSuchMethod(
        Invocation.method(#init, []),
        returnValue: Future<void>.value(),
      );

  @override
  Future<void> cacheResponse(
    String key,
    Map<String, dynamic> data, {
    Duration? duration,
  }) =>
      super.noSuchMethod(
        Invocation.method(#cacheResponse, [key, data], {#duration: duration}),
        returnValue: Future<void>.value(),
      );

  @override
  Future<Map<String, dynamic>?> getCachedResponse(String key) =>
      super.noSuchMethod(
        Invocation.method(#getCachedResponse, [key]),
        returnValue: Future<Map<String, dynamic>?>.value(null),
      );

  @override
  Future<void> clearCache(String key) => super.noSuchMethod(
        Invocation.method(#clearCache, [key]),
        returnValue: Future<void>.value(),
      );

  @override
  Future<void> clearAllCache() => super.noSuchMethod(
        Invocation.method(#clearAllCache, []),
        returnValue: Future<void>.value(),
      );

  @override
  Future<bool> isCacheValid(String key) => super.noSuchMethod(
        Invocation.method(#isCacheValid, [key]),
        returnValue: Future<bool>.value(false),
      );
}

class MockNetworkService extends Mock implements NetworkService {
  @override
  Future<bool> isConnected() => super.noSuchMethod(
        Invocation.method(#isConnected, []),
        returnValue: Future<bool>.value(true),
      );

  @override
  Future<bool> hasInternetConnection({String host = 'google.com'}) =>
      super.noSuchMethod(
        Invocation.method(#hasInternetConnection, [], {#host: host}),
        returnValue: Future<bool>.value(true),
      );

  @override
  NetworkStatus get currentStatus => super.noSuchMethod(
        Invocation.getter(#currentStatus),
        returnValue: NetworkStatus.connected,
      );

  @override
  Stream<NetworkStatus> get networkStatusStream => super.noSuchMethod(
        Invocation.getter(#networkStatusStream),
        returnValue: Stream<NetworkStatus>.value(NetworkStatus.connected),
      );

  @override
  void initialize() => super.noSuchMethod(
        Invocation.method(#initialize, []),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(#dispose, []),
        returnValueForMissingStub: null,
      );
}