import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart' as auth_bloc;
import '../models/auth_model.dart';
import '../models/user.dart';
import '../utils/helpers.dart';
import '../utils/validators.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers for Dealer Login
  final TextEditingController _dealerMobileController = TextEditingController();
  final TextEditingController _dealerPasswordController =
      TextEditingController();

  // Controllers for Transporter Login
  final TextEditingController _transporterMobileController =
      TextEditingController();
  final TextEditingController _transporterPasswordController =
      TextEditingController();

  bool _isDealerPasswordVisible = false;
  bool _isTransporterPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dealerMobileController.dispose();
    _dealerPasswordController.dispose();
    _transporterMobileController.dispose();
    _transporterPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, auth_bloc.AuthState>(
      listener: (context, state) {
        if (state is auth_bloc.AuthLoading) {
          // Show loading indicator if needed
        } else if (state is auth_bloc.AuthAuthenticated) {
          Helpers.showSuccessSnackBar(context, 'Login successful!');
          // Navigate to home screen (to be implemented)
        } else if (state is auth_bloc.AuthError) {
          Helpers.showErrorSnackBar(context, state.message);
        } else if (state is auth_bloc.AuthForgotPasswordSuccess) {
          Helpers.showSuccessSnackBar(context, state.message);
        } else if (state is auth_bloc.AuthForgotPasswordError) {
          Helpers.showErrorSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              // Header with logo/title
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    // Logo placeholder
                    // Container(
                    //   width: 100,
                    //   height: 100,
                    //   decoration: BoxDecoration(
                    //     color: Colors.blue.shade100,
                    //     borderRadius: BorderRadius.circular(50),
                    //   ),
                    //   child: Icon(
                    //     Icons.business,
                    //     size: 50,
                    //     color: Colors.blue.shade700,
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 60),
                    Text(
                      'Sign in to your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Tab Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: Colors.blue.shade600,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade200,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey.shade600,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  tabs: const [
                    Tab(text: 'Dealer', height: 45),
                    Tab(text: 'Transporter', height: 45),
                  ],
                ),
              ),

              // Tab Bar View
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildDealerLogin(), _buildTransporterLogin()],
                ),
              ),

              // Footer - Contact Support (only show when keyboard is not visible)
              if (MediaQuery.of(context).viewInsets.bottom == 0)
                SafeArea(
                  top: false,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: TextButton(
                      onPressed: () {
                        _showContactSupport(context);
                      },
                      child: Text(
                        'Contact Support',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDealerLogin() {
    return BlocBuilder<AuthBloc, auth_bloc.AuthState>(
      builder: (context, state) {
        final isLoading = state is auth_bloc.AuthLoading;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Mobile Number / Dealer ID Field
              TextFormField(
                controller: _dealerMobileController,
                keyboardType: TextInputType.text,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: 'Mobile Number / Dealer ID',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.blue.shade600,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Password Field
              TextFormField(
                controller: _dealerPasswordController,
                obscureText: !_isDealerPasswordVisible,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isDealerPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            setState(() {
                              _isDealerPasswordVisible =
                                  !_isDealerPasswordVisible;
                            });
                          },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.blue.shade600,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          _showForgotPassword(context, UserType.dealer);
                        },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.blue.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Login Button
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        _handleDealerLogin();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),

              // Extra space to ensure content is scrollable when keyboard appears
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 100),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransporterLogin() {
    return BlocBuilder<AuthBloc, auth_bloc.AuthState>(
      builder: (context, state) {
        final isLoading = state is auth_bloc.AuthLoading;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),

              // Mobile Number / Transporter ID Field
              TextFormField(
                controller: _transporterMobileController,
                keyboardType: TextInputType.text,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: 'Mobile Number / Transporter ID',
                  prefixIcon: const Icon(Icons.local_shipping),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.blue.shade600,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Password Field
              TextFormField(
                controller: _transporterPasswordController,
                obscureText: !_isTransporterPasswordVisible,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isTransporterPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            setState(() {
                              _isTransporterPasswordVisible =
                                  !_isTransporterPasswordVisible;
                            });
                          },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.blue.shade600,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          _showForgotPassword(context, UserType.transporter);
                        },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.blue.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Login Button
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        _handleTransporterLogin();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),

              // Extra space to ensure content is scrollable when keyboard appears
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 100),
            ],
          ),
        );
      },
    );
  }

  void _handleDealerLogin() {
    final mobileOrId = _dealerMobileController.text.trim();
    final password = _dealerPasswordController.text.trim();

    final mobileError = Validators.validateMobileOrId(mobileOrId);
    final passwordError = Validators.validatePassword(password);

    if (mobileError != null) {
      Helpers.showErrorSnackBar(context, mobileError);
      return;
    }

    if (passwordError != null) {
      Helpers.showErrorSnackBar(context, passwordError);
      return;
    }

    final loginRequest = LoginRequest(
      mobileNumberOrId: mobileOrId,
      password: password,
      userType: UserType.dealer,
    );

    context.read<AuthBloc>().add(AuthLoginRequested(loginRequest));
  }

  void _handleTransporterLogin() {
    final mobileOrId = _transporterMobileController.text.trim();
    final password = _transporterPasswordController.text.trim();

    final mobileError = Validators.validateMobileOrId(mobileOrId);
    final passwordError = Validators.validatePassword(password);

    if (mobileError != null) {
      Helpers.showErrorSnackBar(context, mobileError);
      return;
    }

    if (passwordError != null) {
      Helpers.showErrorSnackBar(context, passwordError);
      return;
    }

    final loginRequest = LoginRequest(
      mobileNumberOrId: mobileOrId,
      password: password,
      userType: UserType.transporter,
    );

    context.read<AuthBloc>().add(AuthLoginRequested(loginRequest));
  }

  void _showForgotPassword(BuildContext context, UserType userType) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Forgot Password - ${userType.name.toUpperCase()}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter your mobile number or ID to reset your password:',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText:
                      'Mobile Number / ${userType.name.toUpperCase()} ID',
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final mobileOrId = controller.text.trim();
                if (mobileOrId.isNotEmpty) {
                  final request = ForgotPasswordRequest(
                    mobileNumberOrId: mobileOrId,
                    userType: userType,
                  );
                  context.read<AuthBloc>().add(
                    AuthForgotPasswordRequested(request),
                  );
                  Navigator.of(dialogContext).pop();
                } else {
                  Helpers.showErrorSnackBar(
                    context,
                    'Please enter your mobile number or ID',
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _showContactSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Support'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Need help? Contact our support team:'),
              SizedBox(height: 10),
              Text('📞 Phone: +1-800-123-4567'),
              Text('📧 Email: support@company.com'),
              Text('��� Chat: Available 24/7'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}