import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/lyrics_service.dart';

class DetailPage extends StatefulWidget {
  final dynamic song;
  const DetailPage({super.key, required this.song});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String lyrics = "Loading...";
  final player = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    loadLyrics();
  }

  void loadLyrics() async {
    final l = await getLyrics(
      widget.song['title'],
      widget.song['artist']['name'],
    );

    setState(() {
      if (l.toLowerCase().contains("tidak") ||
          l.toLowerCase().contains("gagal")) {
        lyrics = "Lirik belum tersedia untuk lagu ini 😢\n\nCoba lagu lain ya!";
      } else {
        lyrics = l;
      }
    });
  }

  void play() async {
    final url = widget.song['preview'];

    if (url == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Preview tidak tersedia")));
      return;
    }

    if (isPlaying) {
      await player.pause();
    } else {
      await player.play(UrlSource(url));
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.song;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7), 

      appBar: AppBar(
        backgroundColor: const Color(0xFF8FAADC), 
        elevation: 0,
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(s['album']['cover'], height: 220),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            s['title'],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          Text(
            s['artist']['name'],
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),

          const SizedBox(height: 25),

          ElevatedButton.icon(
            onPressed: play,
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            label: Text(isPlaying ? "Pause" : "Play Preview"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8FAADC),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFFDFDFD),
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: SingleChildScrollView(
                child: Text(
                  lyrics,
                  style: const TextStyle(
                    height: 1.6,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
