import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sptm/core/constants.dart';
import 'package:sptm/core/validators.dart';
import 'package:sptm/services/auth_service.dart';
import 'package:sptm/views/auth/dialogs/forgot_passwd_dialog.dart';
import '../../home/home_page.dart';
import 'register_page.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ super.key });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final authService = AuthService();
  final emailOrPhoneCtrl = TextEditingController();
  final passwdCtrl = TextEditingController();
  bool loading = false;

  void _showForgotPasswdDialog() {
    showDialog(
        context: context,
        builder: (_) => ForgotPasswdDialog(authService: authService)
    );
  }

  Future<void> _login() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => loading = true );

    try {
      final success = await authService.login(emailOrPhoneCtrl.text.trim(), passwdCtrl.text);
      if (success) {
        Fluttertoast.showToast(msg: "Login successful!");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage())
        );
      } else {
        Fluttertoast.showToast(msg: "Invalid credentials");
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    emailOrPhoneCtrl.dispose();
    passwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailOrPhoneCtrl,
                decoration: const InputDecoration(hintText: "E-Mail or Phone"),
                validator: Validators.validateEmailOrPhone,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: passwdCtrl,
                decoration: const InputDecoration(hintText: "Password"),
                obscureText: true,
                validator: Validators.validatePasswd,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loading ? null : _login,
                child: loading ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text("Login"),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                ),
                child: const Text("I don't have an account."),
              ),
              TextButton(
                onPressed: _showForgotPasswdDialog,
                child: const Text("Forgot password?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}