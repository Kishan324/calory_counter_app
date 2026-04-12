import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';

/// NOTE: This file is purely for demonstration purposes and contains the remaining deliverables.
/// It does not interact with the existing core navigation logic unless you hook it up.

class AuthExampleUI extends StatefulWidget {
  const AuthExampleUI({Key? key}) : super(key: key);

  @override
  _AuthExampleUIState createState() => _AuthExampleUIState();
}

class _AuthExampleUIState extends State<AuthExampleUI> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  enabled: !authProvider.isLoading,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  enabled: !authProvider.isLoading,
                ),
                const SizedBox(height: 24),
                
                // --- Example UI Button using Consumer and mapping state ---
                // Requirements: Show loading state, disable button while loading, show loader inside button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading
                        ? null // Disable button while loading
                        : () async {
                            final success = await authProvider.login(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            
                            if (success && mounted) {
                              // Example of navigating on success
                              // Navigator.pushReplacementNamed(context, '/home');
                            }
                          },
                    child: authProvider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("LOGIN"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Optional: Example of Auto-login check setup in SplashScreen
/// You can place this logic in your existing splash_screen.dart
class SplashExampleUI extends StatefulWidget {
  const SplashExampleUI({Key? key}) : super(key: key);

  @override
  State<SplashExampleUI> createState() => _SplashExampleUIState();
}

class _SplashExampleUIState extends State<SplashExampleUI> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Wait for splash animations or minimum time
    await Future.delayed(const Duration(seconds: 2));
    
    // AuthProvider auto-loads state upon initialization (which happens in main.dart)
    if (!mounted) return;
    final isAuth = context.read<AuthProvider>().isLoggedIn;
    
    if (isAuth) {
      // Navigate to Home
      // Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Navigate to Auth Entry
      // Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Splash Screen Logo"),
      ),
    );
  }
}
