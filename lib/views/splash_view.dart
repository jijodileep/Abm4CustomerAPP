import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/splash/splash_bloc.dart';
import '../blocs/splash/splash_event.dart' as splash_event;
import '../blocs/splash/splash_state.dart' as splash_state;
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import 'auth_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    
    // Start splash process
    context.read<SplashBloc>().add(const splash_event.SplashStarted());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, splash_state.SplashState>(
      listener: (context, state) {
        if (state is splash_state.SplashCompleted) {
          if (state.isAuthenticated) {
            // Navigate to home screen (to be implemented)
            // For now, we'll navigate to auth screen
            _navigateToAuth();
          } else {
            _navigateToAuth();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top spacing
              const Spacer(flex: 2),

              // ABM4 Logo (centered)
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo
                      Center(child: Image.asset('assets/logo.png')),
                      const SizedBox(height: 24),

                      // Tagline placeholder
                      const Text(
                        'TBD',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Middle spacing
              const Spacer(flex: 3),

              // Loader animation at bottom
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToAuth() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => context.read<AuthBloc>()..add(const AuthInitialized()),
          child: const AuthView(),
        ),
      ),
    );
  }
}