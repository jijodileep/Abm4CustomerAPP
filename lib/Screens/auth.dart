import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with logo/title
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Logo placeholder
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.business,
                      size: 50,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to your account',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
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
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.blue.shade600,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'Dealer'),
                  Tab(text: 'Transporter'),
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

            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              child: TextButton(
                onPressed: () {
                  // Handle contact support
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
          ],
        ),
      ),
    );
  }

  Widget _buildDealerLogin() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30),

          // Mobile Number / Dealer ID Field
          TextFormField(
            controller: _dealerMobileController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Mobile Number / Dealer ID',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Password Field
          TextFormField(
            controller: _dealerPasswordController,
            obscureText: !_isDealerPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _isDealerPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isDealerPasswordVisible = !_isDealerPasswordVisible;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                _showForgotPassword(context, 'Dealer');
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
            onPressed: () {
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
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransporterLogin() {
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
            decoration: InputDecoration(
              labelText: 'Mobile Number / Transporter ID',
              prefixIcon: const Icon(Icons.local_shipping),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Password Field
          TextFormField(
            controller: _transporterPasswordController,
            obscureText: !_isTransporterPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _isTransporterPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
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
                borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                _showForgotPassword(context, 'Transporter');
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
            onPressed: () {
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
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _handleDealerLogin() {
    String mobileOrId = _dealerMobileController.text.trim();
    String password = _dealerPasswordController.text.trim();

    if (mobileOrId.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }

    // TODO: Implement dealer login logic
    _showSnackBar('Dealer login functionality to be implemented');
  }

  void _handleTransporterLogin() {
    String mobileOrId = _transporterMobileController.text.trim();
    String password = _transporterPasswordController.text.trim();

    if (mobileOrId.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }

    // TODO: Implement transporter login logic
    _showSnackBar('Transporter login functionality to be implemented');
  }

  void _showForgotPassword(BuildContext context, String userType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot Password - $userType'),
          content: const Text(
            'Password reset functionality will be implemented here.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
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
              Text('💬 Chat: Available 24/7'),
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.blue.shade600),
    );
  }
}
