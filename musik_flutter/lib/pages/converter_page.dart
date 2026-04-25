import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});
  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final _ctrl = TextEditingController();
  String from = "USD", to = "IDR";
  double res = 0.0;

  final Map<String, double> rates = {
    "USD_IDR": 15500.0,
    "IDR_USD": 1 / 15500.0,
    "USD_EUR": 0.92,
    "EUR_USD": 1 / 0.92,
    "IDR_EUR": 1 / 17000.0,
    "EUR_IDR": 17000.0,
  };

  void _convert() {
    double amt = double.tryParse(_ctrl.text.replaceAll(',', '')) ?? 0;
    if (from == to) {
      setState(() => res = amt);
      return;
    }
    setState(() => res = amt * (rates["${from}_$to"] ?? 1.0));
  }

  void _switch() {
    setState(() {
      var tmp = from;
      from = to;
      to = tmp;
      _convert(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        title: const Text("Currency Converter",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF7DA7D9),
        centerTitle: true,
        automaticallyImplyLeading: false, // FIX: Biar gak layar hitam
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Amount",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _ctrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                          hintText: "Enter amount",
                          prefixIcon: Icon(Icons.account_balance_wallet,
                              color: Color(0xFF7DA7D9))),
                      onChanged: (_) => _convert(),
                    ),
                    const SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _drop(
                              from,
                              (v) => setState(() {
                                    from = v!;
                                    _convert();
                                  })),
                          GestureDetector(
                            onTap: _switch,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color:
                                      Colors.pinkAccent.withValues(alpha: 0.1),
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.swap_horiz,
                                  color: Colors.pinkAccent, size: 30),
                            ),
                          ),
                          _drop(
                              to,
                              (v) => setState(() {
                                    to = v!;
                                    _convert();
                                  })),
                        ]),
                  ]),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _convert,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent.shade100,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            child: const Text("Convert Now",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 40),
          const Text("Result",
              style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10)
                ]),
            child: Text(
              "${NumberFormat("#,###.##").format(res)} $to",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4E342E)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _drop(String val, ValueChanged<String?> cb) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
      child: DropdownButton<String>(
        value: val,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down),
        items: ["USD", "IDR", "EUR"]
            .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e,
                    style: const TextStyle(fontWeight: FontWeight.bold))))
            .toList(),
        onChanged: cb,
      ),
    );
  }
}
