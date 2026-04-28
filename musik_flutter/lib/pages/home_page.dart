import 'package:flutter/material.dart';
import 'search_page.dart';
import 'converter_page.dart';
import 'chat_page.dart';
import 'profile_page.dart';
import 'time_converter_page.dart';
import 'game_page.dart';
import 'voice_game_page.dart';
import 'network_sensor_page.dart';

const primary = Color(0xFF7DA7D9);
const softPink = Color(0xFFF7A6B8);
const bg = Color(0xFFF4F5F7);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Musik App",
            style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 24, right: 24, bottom: 30, top: 10),
            decoration: const BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Halo! 👋",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 5),
                Text("Mau buka fitur apa hari ini?",
                    style: TextStyle(fontSize: 16, color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              physics: const BouncingScrollPhysics(), // Efek scroll memantul
              children: [
                _menu(context, "Music", Icons.music_note, const SearchPage()),
                _menu(context, "Converter", Icons.attach_money,
                    const ConvertPage()),
                _menu(context, "AI Chat", Icons.smart_toy, const ChatPage()),
                _menu(context, "Time", Icons.access_time,
                    const TimeConverterPage()),
                _menu(context, "Game", Icons.sports_esports, const GamePage()),
                _menu(context, "Profile", Icons.person, const ProfilePage()),
                _menu(context, "Voice Game", Icons.mic, const VoiceGamePage()),
                _menu(
                    context, "Network Sensor", Icons.wifi, const NetworkPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menu(BuildContext context, String title, IconData icon, Widget page) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => page),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: bg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: primary),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
