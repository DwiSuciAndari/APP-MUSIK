import 'package:flutter/material.dart';

const primaryBlue = Color(0xFF7DA7D9);
const softPink = Color(0xFFF7A6B8);
const bg = Color(0xFFF4F5F7);

class TimeConverterPage extends StatefulWidget {
  const TimeConverterPage({super.key});

  @override
  State<TimeConverterPage> createState() => _TimeConverterPageState();
}

class _TimeConverterPageState extends State<TimeConverterPage> {
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  String formatTime(DateTime dt) {
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final input = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final wib = input;
    final wita = input.add(const Duration(hours: 1));
    final wit = input.add(const Duration(hours: 2));

    final londonGMT = input.subtract(const Duration(hours: 7));

    final londonBST = input.subtract(const Duration(hours: 6));

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Time Converter",
            style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: pickTime,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.schedule, size: 50, color: softPink),
                      const SizedBox(height: 10),
                      Text(
                        selectedTime.format(context),
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Ketuk untuk mengubah waktu",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 35),
              const Padding(
                padding: EdgeInsets.only(left: 5, bottom: 15),
                child: Text(
                  "Hasil Konversi",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              _buildResultCard("WIB", "Waktu Indonesia Barat (UTC+7)",
                  formatTime(wib), Icons.location_on, true),
              _buildResultCard("WITA", "Waktu Indonesia Tengah (UTC+8)",
                  formatTime(wita), Icons.map_outlined, false),
              _buildResultCard("WIT", "Waktu Indonesia Timur (UTC+9)",
                  formatTime(wit), Icons.map, false),
              _buildResultCard("London (GMT)", "Musim Dingin Inggris (UTC+0)",
                  formatTime(londonGMT), Icons.ac_unit, false),
              _buildResultCard("London (BST)", "Musim Panas Inggris (UTC+1)",
                  formatTime(londonBST), Icons.wb_sunny_outlined, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, String subtitle, String time,
      IconData icon, bool isPrimary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isPrimary ? primaryBlue : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isPrimary ? Colors.white.withOpacity(0.2) : bg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isPrimary ? Colors.white : primaryBlue,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isPrimary ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isPrimary ? Colors.white70 : Colors.grey,
          ),
        ),
        trailing: Text(
          time,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isPrimary ? Colors.white : primaryBlue,
          ),
        ),
      ),
    );
  }
}
