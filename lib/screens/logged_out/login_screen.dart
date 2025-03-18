import 'package:easy_debounce/easy_debounce.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../logged_in/dashboard_screen.dart';
import '../../util/notifications_helper.dart';
import '../../providers/auth_provider.dart';
import '../../providers/analytics_provider.dart';
import '../../gen/assets.gen.dart';

class LoginScreen extends StatefulWidget {
  final bool skipAnimation;

  const LoginScreen({super.key, this.skipAnimation = false});

  static Route<dynamic> route({bool skipAnimation = false}) =>
      MaterialPageRoute(builder: (_) => LoginScreen(skipAnimation: skipAnimation));

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final ValueNotifier<bool> _isLoading;
  late final ValueNotifier<bool> _isRegistering;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _isLoading = ValueNotifier(false);
    _isRegistering = ValueNotifier(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        _navigateIfLoggedIn(auth);
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LoginLogo(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: _isRegistering,
                        builder: (context, isRegistering, _) {
                          return Text(
                            isRegistering ? 'Create Account' : 'Welcome Back',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        enabled: !_isLoading.value,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        enabled: !_isLoading.value,
                      ),
                      const SizedBox(height: 24),
                      ValueListenableBuilder(
                        valueListenable: _isLoading,
                        builder: (context, isLoading, _) {
                          return SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _handleAuthentication,
                              child: isLoading
                                  ? const CircularProgressIndicator()
                                  : ValueListenableBuilder(
                                      valueListenable: _isRegistering,
                                      builder: (context, isRegistering, _) {
                                        return Text(isRegistering ? 'Register' : 'Login');
                                      },
                                    ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _isLoading.value
                            ? null
                            : () {
                                _isRegistering.value = !_isRegistering.value;
                              },
                        child: ValueListenableBuilder(
                          valueListenable: _isRegistering,
                          builder: (context, isRegistering, _) {
                            return Text(
                              isRegistering
                                  ? 'Already have an account? Login'
                                  : 'Don\'t have an account? Register',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleAuthentication() async {
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    if (!_isEmailValid(email)) {
      NotificationsHelper().showError('Please enter a valid email address.', context: context);
      return;
    }

    if (password.isEmpty) {
      NotificationsHelper().showError('Please enter your password.', context: context);
      return;
    }

    _isLoading.value = true;

    try {
      if (_isRegistering.value) {
        await Provider.of<AuthProvider>(context, listen: false)
            .createUserWithEmailAndPassword(email, password);
        AnalyticsProvider.logLogin('Email registration');
      } else {
        await Provider.of<AuthProvider>(context, listen: false)
            .signInWithEmailAndPassword(email, password);
        AnalyticsProvider.logLogin('Email login');
      }
    } catch (e) {
      NotificationsHelper().showError(e.toString(), context: context);
    } finally {
      _isLoading.value = false;
    }
  }

  void _navigateIfLoggedIn(AuthProvider auth) {
    if (auth.isLoggedIn) {
      EasyDebounce.debounce('navigate', const Duration(milliseconds: 300), () {
        if (mounted) Navigator.pushReplacement(context, Dashboard.route());
      });
    }
  }

  bool _isEmailValid(String email) => email.contains('@') && email.contains('.');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _isLoading.dispose();
    _isRegistering.dispose();
    super.dispose();
  }
}

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 100, left: 30, right: 30),
        child: Align(
          alignment: Alignment.topCenter,
          child: Assets.logo.svg(
            width: 240,
          ),
        ),
      ),
    );
  }
}
