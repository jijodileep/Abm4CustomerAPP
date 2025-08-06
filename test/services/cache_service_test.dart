import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:abm4_customerapp/services/cache_service.dart';

void main() {
  late CacheService cacheService;

  setUp(() {
    cacheService = CacheService();
  });

  group('CacheService Tests', () {
    group('cacheResponse', () {
      test('should cache response with expiration', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        await cacheService.init();

        final testData = {'key': 'value', 'number': 123};
        const testKey = 'test_key';

        // Act
        await cacheService.cacheResponse(testKey, testData);

        // Assert
        final cachedData = await cacheService.getCachedResponse(testKey);
        expect(cachedData, isNotNull);
        expect(cachedData!['key'], 'value');
        expect(cachedData['number'], 123);
      });

      test('should cache response with custom duration', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        await cacheService.init();

        final testData = {'key': 'value'};
        const testKey = 'test_key';
        const customDuration = Duration(minutes: 30);

        // Act
        await cacheService.cacheResponse(
          testKey,
          testData,
          duration: customDuration,
        );

        // Assert
        final cachedData = await cacheService.getCachedResponse(testKey);
        expect(cachedData, isNotNull);
      });
    });

    group('getCachedResponse', () {
      test('should return null for non-existent cache', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        await cacheService.init();

        // Act
        final result = await cacheService.getCachedResponse('non_existent');

        // Assert
        expect(result, isNull);
      });

      test('should return null for expired cache', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        await cacheService.init();

        final testData = {'key': 'value'};
        const testKey = 'test_key';
        const shortDuration = Duration(milliseconds: 1);

        // Act
        await cacheService.cacheResponse(
          testKey,
          testData,
          duration: shortDuration,
        );

        // Wait for cache to expire
        await Future.delayed(const Duration(milliseconds: 10));

        final result = await cacheService.getCachedResponse(testKey);

        // Assert
        expect(result, isNull);
      });
    });

    group('clearCache', () {
      test('should clear specific cache entry', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        await cacheService.init();

        final testData = {'key': 'value'};
        const testKey = 'test_key';

        await cacheService.cacheResponse(testKey, testData);

        // Act
        await cacheService.clearCache(testKey);

        // Assert
        final result = await cacheService.getCachedResponse(testKey);
        expect(result, isNull);
      });
    });

    group('clearAllCache', () {
      test('should clear all cache entries', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        await cacheService.init();

        final testData1 = {'key1': 'value1'};
        final testData2 = {'key2': 'value2'};

        await cacheService.cacheResponse('test_key1', testData1);
        await cacheService.cacheResponse('test_key2', testData2);

        // Act
        await cacheService.clearAllCache();

        // Assert
        final result1 = await cacheService.getCachedResponse('test_key1');
        final result2 = await cacheService.getCachedResponse('test_key2');
        expect(result1, isNull);
        expect(result2, isNull);
      });
    });

    group('isCacheValid', () {
      test('should return true for valid cache', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        await cacheService.init();

        final testData = {'key': 'value'};
        const testKey = 'test_key';

        await cacheService.cacheResponse(testKey, testData);

        // Act
        final result = await cacheService.isCacheValid(testKey);

        // Assert
        expect(result, true);
      });

      test('should return false for invalid cache', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        await cacheService.init();

        // Act
        final result = await cacheService.isCacheValid('non_existent');

        // Assert
        expect(result, false);
      });
    });
  });
}
