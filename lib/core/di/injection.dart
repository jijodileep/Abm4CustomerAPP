import 'package:get_it/get_it.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import '../../repositories/auth_repository.dart';
import '../../features/auth/Bloc/auth_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Services
  getIt.registerLazySingleton<ApiService>(() => ApiService());

  final storageService = StorageService();
  await storageService.init();
  getIt.registerSingleton<StorageService>(storageService);

  getIt.registerLazySingleton<AuthService>(
    () => AuthService(getIt<ApiService>(), getIt<StorageService>()),
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
