import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/api_config.dart';

class ConvertPage extends StatefulWidget {
  const ConvertPage({super.key});

  @override
  State<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  final TextEditingController _ctrl = TextEditingController();

  double res = 0;
  String from = "USD";
  String to = "IDR";
  bool loading = false;

  Future<void> _convert() async {
    if (_ctrl.text.trim().isEmpty) return;

    setState(() => loading = true);

    try {
      String fromLower = from.toLowerCase();
      String toLower = to.toLowerCase();

      final url = Uri.parse(
        "https://latest.currency-api.pages.dev/v1/currencies/$fromLower.json",
      );

      print("CALL API: $url");

      final response = await http.get(url);

      print("STATUS: ${response.statusCode}");


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Contoh: data['usd']['idr']
        final rate = data[fromLower][toLower];

        // 4. Ubah inputan user menjadi angka (double)
        final amount = double.parse(_ctrl.text);

        setState(() {
          res = (amount * rate).toDouble();
        });
      } else {
        throw Exception("API error dengan status ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mengambil data kurs ❌")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        title: const Text("Currency Converter"),
        backgroundColor: const Color(0xFF6C63FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _ctrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Masukkan jumlah",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    value: from,
                    items: ["USD", "IDR", "EUR"]
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => from = v.toString()),
                    decoration: const InputDecoration(labelText: "From"),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.swap_horiz, 
                        size: 28, 
                        color: Color(0xFF6C63FF)
                      ),
                      onPressed: () {
                        setState(() {
                          String temp = from;
                          from = to;
                          to = temp;

                          res = 0; 
                        });
                      },
                    ),
                  ),
                ),

                Expanded(
                  child: DropdownButtonFormField(
                    value: to,
                    items: ["USD", "IDR", "EUR"]
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => to = v.toString()),
                    decoration: const InputDecoration(labelText: "To"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF6C63FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: loading ? null : _convert,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Convert",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
                children: [
                  const Text("Hasil",
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 10),
                  Text(
                    res == 0
                        ? "-"
                        : "${NumberFormat("#,###.##").format(res)} $to",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
