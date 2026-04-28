import 'package:flutter/material.dart';
import 'home_page.dart';
import 'converter_page.dart';
import 'chat_page.dart';
import 'game_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
    const ConvertPage(),
    const ChatPage(),
    const GamePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: "Convert"),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: "AI"),
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_esports), label: "Game"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
