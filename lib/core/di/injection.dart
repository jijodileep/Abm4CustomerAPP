import 'package:get_it/get_it.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import '../../services/cache_service.dart';
import '../../services/network_service.dart';
import '../../repositories/auth_repository.dart';
import '../../features/auth/Bloc/auth_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Core Services
  final storageService = StorageService();
  await storageService.init();
  getIt.registerSingleton<StorageService>(storageService);

  final cacheService = CacheService();
  await cacheService.init();
  getIt.registerSingleton<CacheService>(cacheService);

  final networkService = NetworkService();
  networkService.initialize();
  getIt.registerSingleton<NetworkService>(networkService);

  // API Service with dependencies
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(getIt<CacheService>(), getIt<NetworkService>()),
  );

  getIt.registerLazySingleton<AuthService>(
    () => AuthService(getIt<ApiService>()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<AuthService>()),
  );

  // BLoCs
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthService>()));
}

// Helper methods for easy access
ApiService get apiService => getIt<ApiService>();
AuthService get authService => getIt<AuthService>();
StorageService get storageService => getIt<StorageService>();
AuthRepository get authRepository => getIt<AuthRepository>();
