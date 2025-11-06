import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<bool> register(String name, String phone, String email, String passwd) async {
    final prefs = await SharedPreferences.getInstance();
    final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");

    if (name.isEmpty || phone.isEmpty || email.isEmpty || passwd.isEmpty) return false;

    if (!emailRegex.hasMatch(email)) return false;

    prefs.setString('name', name);
    prefs.setString('phone', phone);
    prefs.setString('email', email);
    prefs.setString('passwd', passwd);

    return true;
  }

  Future<bool> login(String emailOrPhone, String passwd) async {
    final prefs = await SharedPreferences.getInstance();

    if (emailOrPhone.isEmpty || passwd.isEmpty) return false;

    final savedEmail = prefs.getString('email');
    final savedPhone = prefs.getString('phone');
    final savedPasswd = prefs.getString('passwd');
    
    return (
      (emailOrPhone == savedEmail || emailOrPhone == savedPhone)
      && passwd == savedPasswd
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> requestPasswdReset(String email) async {
    return true;
  }
}