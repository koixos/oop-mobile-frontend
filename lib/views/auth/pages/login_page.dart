import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sptm/app/main_shell.dart';
import 'package:sptm/core/validators.dart';
import 'package:sptm/services/auth_service.dart';
import 'package:sptm/views/auth/dialogs/forgot_passwd_dialog.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final authService = AuthService();
  final emailOrPhoneCtrl = TextEditingController();
  final passwdCtrl = TextEditingController();
  bool loading = false;
  bool obscure = true;

  void _showForgotPasswdDialog() {
    showDialog(
      context: context,
      builder: (_) => ForgotPasswdDialog(authService: authService),
    );
  }

  Future<void> _login() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      final success = await authService.login(
        emailOrPhoneCtrl.text.trim(),
        passwdCtrl.text,
      );

      if (success) {
        await saveLoginState(success);
        Fluttertoast.showToast(msg: "Login successful!");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainShell()),
          (route) => false,
        );
      } else {
        Fluttertoast.showToast(msg: "Invalid credentials");
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> saveLoginState(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("loggedIn", val);
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0C1F15),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
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
      decoration: BoxDecoration(
        color: const Color(0xFF0C1F15),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
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

  Widget _buildSocialButton(String text, IconData? icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1F15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 8),
          ],
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 15)),
        ],
      ),
    );
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
      backgroundColor: Color(0xFF04150C),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IconButton(
                //   onPressed: () => Navigator.pop(context),
                //   icon: const Icon(Icons.arrow_back, color: Colors.white),
                // ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B3B26),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        size: 50,
                        color: Color(0xFF06D66E),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        maxLines: 2,
                        "Focus on what matters",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "Align your day with your mission.\nLog in to access your personal task manager.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 34),
                const Text(
                  "Email",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(height: 8),
                _buildInputField(
                  controller: emailOrPhoneCtrl,
                  hint: "Enter your email",
                  icon: Icons.email_outlined,
                  validator: Validators.validateEmailOrPhone,
                ),
                const SizedBox(height: 22),
                const Text(
                  "Password",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(height: 8),
                _buildPasswordField(),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _showForgotPasswdDialog,
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Color(0xFF06D66E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: loading ? null : _login,
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
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              "Log In",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
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
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    ),
                    child: const Text(
                      "I don't have an account.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                Row(
                  children: const [
                    Expanded(child: Divider(color: Colors.white24)),
                    SizedBox(width: 10),
                    Text(
                      "OR CONTINUE WITH",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    SizedBox(width: 10),
                    Expanded(child: Divider(color: Colors.white24)),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSocialButton("Google", Icons.g_mobiledata),
                    _buildSocialButton("Apple", Icons.apple),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
