import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'search_page.dart';
import 'converter_page.dart';
import 'chat_page.dart';
import 'game_page.dart';
import 'profile_page.dart';

const primary = Color(0xFF7DA7D9);
const bg = Color(0xFFF4F5F7);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  final List<Widget> pages = [
    const SearchPage(),
    const ConverterPage(),
    const ChatPage(),
    const GamePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: bg,
        body: IndexedStack(index: index, children: pages),
        floatingActionButton: FloatingActionButton(
          onPressed: logout,
          backgroundColor: Colors.redAccent,
          child: const Icon(Icons.logout),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          selectedItemColor: primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: (i) => setState(() => index = i),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.music_note), label: "Music"),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate),
              label: "Convert",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile",),
            BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: "AI"),
            BottomNavigationBarItem(icon: Icon(Icons.games), label: "Game"),
          ],
        ),
      ),
    );
  }
}
