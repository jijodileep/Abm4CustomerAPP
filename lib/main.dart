import 'package:abm4_customerapp/features/Splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'features/auth/Bloc/auth_bloc.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup dependency injection
  await setupDependencyInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => getIt<AuthBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ABM4',
        theme: AppTheme.lightTheme.copyWith(
          extensions: [
            NetworkStatusTheme.light,
            QuickAccessTileTheme.light,
            DashboardTheme.light,
          ],
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
