import 'package:flutter/material.dart';
import 'dart:async';
import 'shake_game_page.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _currentGameMode = 0;

  int _questionIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool? _isCorrect;
  bool _isFinished = false;
  List<Map<String, dynamic>> _shuffledQuestions = [];

  final List<Map<String, dynamic>> _allQuestions = [
    {
      "lyrics": "Mungkin suatu saat nanti kau kan mengerti...",
      "options": ["Tetap Bukan Aku", "Dan", "Sephia"],
      "correct": "Tetap Bukan Aku"
    },
    {
      "lyrics": "Jangan cintai aku, apa adanya...",
      "options": ["Gajah", "Sepatu", "Jangan Cintai Aku Apa Adanya"],
      "correct": "Jangan Cintai Aku Apa Adanya"
    },
    {
      "lyrics": "You're all I want, so much it hurts...",
      "options": ["happier", "traitor", "drivers license"],
      "correct": "happier"
    },
    {
      "lyrics": "You don't know you're beautiful...",
      "options": [
        "Story of My Life",
        "What Makes You Beautiful",
        "Night Changes"
      ],
      "correct": "What Makes You Beautiful"
    },
    {
      "lyrics": "Lantas mengapa ku masih menaruh hati...",
      "options": ["Lantas", "Tampar", "Mawar Jingga"],
      "correct": "Lantas"
    },
    {
      "lyrics": "In my dreams you're with me...",
      "options": ["Imagination", "Stitches", "Treat You Better"],
      "correct": "Imagination"
    },
    {
      "lyrics": "Takkan menyerah esok hari...",
      "options": ["Manusia Kuat", "Rehat", "Lagu Baru"],
      "correct": "Manusia Kuat"
    },
    {
      "lyrics": "Mungkin suatu saat nanti...",
      "options": ["Monokrom", "Diri", "Hati-Hati di Jalan"],
      "correct": "Monokrom"
    },
    {
      "lyrics": "I might never be your knight in shining armor...",
      "options": ["Perfect", "Drag Me Down", "Steal My Girl"],
      "correct": "Perfect"
    },
    {
      "lyrics": "I'm at a payphone trying to call home...",
      "options": ["Payphone", "Sugar", "Maps"],
      "correct": "Payphone"
    },
  ];

  int _tapCount = 0;
  int _timeLeft = 10;
  bool _isGameRunning = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _spinLagu();
  }

  void _spinLagu() {
    setState(() {
      _shuffledQuestions = List.from(_allQuestions)..shuffle();
      _shuffledQuestions = _shuffledQuestions.take(10).toList();
      _questionIndex = 0;
      _score = 0;
      _selectedAnswer = null;
      _isCorrect = null;
      _isFinished = false;
    });
  }

  void _startTapGame() {
    setState(() {
      _tapCount = 0;
      _timeLeft = 10;
      _isGameRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        setState(() => _isGameRunning = false);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: _currentGameMode != 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => setState(() => _currentGameMode = 0),
              )
            : null,
        title: Text(
            _currentGameMode == 0
                ? "MINI GAMES"
                : (_currentGameMode == 1 ? "TEBAK LAGU" : "TAP-TAP FAST"),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7DA7D9), Color(0xFFF8FAFF)],
          ),
        ),
        child: _buildCurrentGame(),
      ),
    );
  }

  Widget _buildCurrentGame() {
    if (_currentGameMode == 0) return _buildMenu();
    if (_currentGameMode == 1) return _buildTebakLaguContent();
    return _buildTapTapContent();
  }

  Widget _buildMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _menuButton("🎵 TEBAK LAGU", Icons.music_note,
            () => setState(() => _currentGameMode = 1)),
        const SizedBox(height: 20),
        _menuButton("⚡ TAP-TAP FAST", Icons.touch_app,
            () => setState(() => _currentGameMode = 2)),
      ],
    );
  }

  Widget _menuButton(String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10)
              ]),
          child: Row(children: [
            Icon(icon, color: const Color(0xFF7DA7D9), size: 30),
            const SizedBox(width: 20),
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ]),
        ),
      ),
    );
  }

  Widget _buildTebakLaguContent() {
    if (_shuffledQuestions.isEmpty)
      return const Center(child: CircularProgressIndicator());
    if (_isFinished) return _buildScoreBoard();
    final q = _shuffledQuestions[_questionIndex];
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("Soal: ${_questionIndex + 1}/10 | Skor: $_score",
          style: const TextStyle(color: Colors.white)),
      const SizedBox(height: 20),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(25)),
        child: Text("\"${q['lyrics']}\"",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
      ),
      const SizedBox(height: 20),
      if (_isCorrect != null)
        Text(
          _isCorrect! ? "BENAR! ✅" : "SALAH! ❌",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _isCorrect! ? Colors.green : Colors.red),
        ),
      const SizedBox(height: 10),
      ...q['options'].map<Widget>((opt) {
        bool isSel = _selectedAnswer == opt;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: isSel
                    ? (_isCorrect! ? Colors.green : Colors.red)
                    : Colors.white),
            onPressed: () {
              if (_isCorrect != null) return;
              setState(() {
                _selectedAnswer = opt;
                _isCorrect = opt == q['correct'];
                if (_isCorrect!) _score += 10;
              });
            },
            child: Text(opt,
                style: TextStyle(color: isSel ? Colors.white : Colors.black)),
          ),
        );
      }).toList(),
      if (_isCorrect != null)
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ElevatedButton(
            onPressed: () => setState(() {
              if (_questionIndex < 9) {
                _questionIndex++;
                _selectedAnswer = null;
                _isCorrect = null;
              } else {
                _isFinished = true;
              }
            }),
            child: const Text("Next Question ➡️"),
          ),
        ),
    ]);
  }

  Widget _buildTapTapContent() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("Waktu: $_timeLeft | Skor: $_tapCount",
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
      const SizedBox(height: 50),
      GestureDetector(
        onTap: _isGameRunning ? () => setState(() => _tapCount++) : null,
        child: Container(
          width: 180,
          height: 180,
          decoration:
              const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Center(
              child: Text(_isGameRunning ? "TAP!!" : "READY?",
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7DA7D9)))),
        ),
      ),
      const SizedBox(height: 50),
      if (!_isGameRunning)
        ElevatedButton(
            onPressed: _startTapGame, child: const Text("START GAME")),
    ]);
  }

  Widget _buildScoreBoard() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text("HASIL AKHIR",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text("$_score",
              style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7DA7D9))),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ShakeGamePage()),
              );
            },
            child: const Text("Shake Game"),
          ),
          ElevatedButton(onPressed: _spinLagu, child: const Text("MAIN LAGI")),
          TextButton(
              onPressed: () => setState(() => _currentGameMode = 0),
              child: const Text("BALIK KE MENU")),
        ]),
      ),
    );
  }
}
