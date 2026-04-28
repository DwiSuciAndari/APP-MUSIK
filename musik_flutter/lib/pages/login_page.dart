import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';
import 'register_page.dart';
import '../services/notif_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    final user = await DBHelper.login(
      usernameController.text.trim(),
      passwordController.text.trim(),
    );

    if (!mounted) return;

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool('isLogin', true);
      await prefs.setString('name', user['username'] ?? '');
      await prefs.setString('email', user['email'] ?? '');
      await prefs.setString('phone', user['phone'] ?? '');
      await prefs.setString('bio', user['bio'] ?? '');

      NotifService.show(
        "Login Berhasil",
        "Selamat datang ${user['username']} 👋",
      );

      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username atau password salah")),
      );
    }
  }

  void handleBiometric() async {
    final auth = LocalAuthentication();

    bool canCheck = await auth.canCheckBiometrics;
    bool isSupported = await auth.isDeviceSupported();

    if (canCheck && isSupported) {
      bool success = await auth.authenticate(
        localizedReason: 'Scan sidik jari untuk login',
      );

      if (!mounted) return;

      if (success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLogin', true);

        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.05),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: login,
                    child: const Text("Login"),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text("Belum punya akun? Register"),
                ),
                const SizedBox(height: 10),
                IconButton(
                  icon: const Icon(Icons.fingerprint, size: 32),
                  onPressed: handleBiometric,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
