import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

/// Login (Module 2): authenticates against the registered account in
/// local storage, with clear error feedback on failure.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _error;
  bool _checking = false;

  Future<void> _login() async {
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;
    setState(() => _checking = true);

    final user = await StorageService.loadUser();
    setState(() => _checking = false);

    if (user['email'] == null) {
      setState(() => _error = 'No account found. Please sign up first.');
      return;
    }
    if (_email.text.trim() != user['email'] ||
        _password.text != user['password']) {
      setState(() => _error = 'Incorrect email or password.');
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.event_note,
                    size: 64, color: Color(0xFF3B6EA5)),
                const SizedBox(height: 12),
                Text('PlanU',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Text('Your whole life in one place',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                  validator: (v) => v == null || !v.contains('@')
                      ? 'Enter a valid email'
                      : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder()),
                  validator: (v) => v == null || v.isEmpty
                      ? 'Enter your password'
                      : null,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _checking ? null : _login,
                  style: FilledButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 14)),
                  child: Text(_checking ? 'Checking...' : 'Log In'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const SignUpScreen())),
                  child: const Text('New here? Sign up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
