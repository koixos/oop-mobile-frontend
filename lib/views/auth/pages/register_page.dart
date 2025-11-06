import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sptm/services/auth_service.dart';
import 'package:sptm/views/auth/pages/login_page.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({ super.key });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwdCtrl = TextEditingController();
  final authService = AuthService();

  void _register() async {
    final success = await authService.register(
      nameCtrl.text,
      phoneCtrl.text,
      emailCtrl.text,
      passwdCtrl.text
    );

    if (success) {
      Fluttertoast.showToast(msg: "Registration successful!");
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: "Registration failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Create an Account",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            CustomTextfield(hint: "Full Name", controller: nameCtrl),
            CustomTextfield(hint: "E-Mail", controller: emailCtrl),
            CustomTextfield(hint: "Phone", controller: phoneCtrl),
            CustomTextfield(hint: "Password", controller: passwdCtrl, obscure: true),
            const SizedBox(height: 16),
            CustomButton(text: "Register", onTap: _register),
            TextButton(
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const LoginPage())
              ), 
              child: const Text("Already have an account?"),
            ),
          ],
        ),
      ),
    );
  }
}