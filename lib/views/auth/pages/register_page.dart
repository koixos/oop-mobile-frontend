import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sptm/core/validators.dart';
import 'package:sptm/services/auth_service.dart';
import 'package:sptm/views/auth/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({ super.key });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final authService = AuthService();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwdCtrl = TextEditingController();
  bool loading = false;
  bool obscure = true;

  Future<void> _register() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      final success = await authService.register(
          nameCtrl.text,
          phoneCtrl.text.trim(),
          emailCtrl.text.trim(),
          passwdCtrl.text
      );

      if (success) {
        Fluttertoast.showToast(msg: "Registration successful!");
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: "Registration failed");
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 15),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1F15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.white70),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1F15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: passwdCtrl,
        obscureText: obscure,
        validator: Validators.validatePasswd,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: const Icon(Icons.lock_outline, color: Colors.white70),
          hintText: "Enter your password",
          hintStyle: const TextStyle(color: Colors.white38),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.white54,
            ),
            onPressed: () => setState(() => obscure = !obscure),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    passwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF04150C),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B3B26),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.person_add,
                      color: Color(0xFF06D66E), size: 48),
                ),
                const SizedBox(height: 28),
                const Text(
                  "Create your account",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Start organizing your goals and tasks with a personalized account.",
                  style: TextStyle(
                    color: Colors.white70,
                    height: 1.5,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 34),
                _buildLabel("Full Name"),
                _buildInputField(
                  controller: nameCtrl,
                  hint: "Enter your full name",
                  icon: Icons.person_outline,
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 20),
                _buildLabel("Email"),
                _buildInputField(
                  controller: emailCtrl,
                  hint: "Enter your email",
                  icon: Icons.email_outlined,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 20),
                _buildLabel("Phone Number"),
                _buildInputField(
                  controller: phoneCtrl,
                  hint: "Enter your phone number",
                  icon: Icons.phone_android,
                  validator: Validators.validatePhone,
                ),
                const SizedBox(height: 20),
                _buildLabel("Password"),
                _buildPasswordField(),
                const SizedBox(height: 28),
                GestureDetector(
                  onTap: loading ? null : _register,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF06D66E),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF06D66E).withOpacity(0.4),
                          blurRadius: 14,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: loading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                          : const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    ),
                    child: const Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}