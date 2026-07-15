import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// Sign-up (Module 2): registration with username, email, and password,
/// a sign-up button, and a link back to Login. Account persists via
/// StorageService so the user can log in afterwards.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _saving = false;
  String? _error;

  Future<void> _signUp() async {
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) {
      setState(() => _error = 'Unable to register — please fix the errors above.');
      return;
    }
    setState(() => _saving = true);
    final existing = await StorageService.loadUser();
    if (existing['email'] == _email.text.trim()) {
      setState(() {
        _saving = false;
        _error = 'An account with this email already exists.';
      });
      return;
    }
    await StorageService.saveUser(
        _username.text.trim(), _email.text.trim(), _password.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created! Please log in.')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.event_note,
                    size: 56, color: Color(0xFF3B6EA5)),
                const SizedBox(height: 10),
                Text('Create your PlanU account',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _username,
                  decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder()),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Enter a username'
                      : null,
                ),
                const SizedBox(height: 14),
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
                      labelText: 'Password (min 6 characters)',
                      border: OutlineInputBorder()),
                  validator: (v) => v == null || v.length < 6
                      ? 'Password must be at least 6 characters'
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
                  onPressed: _saving ? null : _signUp,
                  style: FilledButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 14)),
                  child: Text(_saving ? 'Saving...' : 'Sign Up'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child:
                      const Text('Already have an account? Log in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
