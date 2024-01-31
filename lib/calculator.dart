import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController luasLahanController = TextEditingController();
  final TextEditingController luasPanenController = TextEditingController();
  final TextEditingController bibitController = TextEditingController();
  String _hasilHitung = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediksi Hasil Panen'),
        backgroundColor: const Color(0xFFBBE7C0),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFBBE7C0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    width: 320,
                    height: 390,
                    color: const Color(0xFF3FBC4B),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo.png', // Gantilah dengan path logo aplikasi Anda
                          height: 80, // Sesuaikan tinggi logo jika diperlukan
                        ),
                        const SizedBox(height: 10),
                        buildInputField("Luas Lahan (ha)", luasLahanController),
                        buildInputField("Luas Panen (ha)", luasPanenController),
                        buildInputField("Jumlah Bibit", bibitController),
                        ElevatedButton(
                          onPressed: () {
                            calculateResult(
                              double.parse(luasLahanController.text),
                              double.parse(luasPanenController.text),
                              int.parse(bibitController.text),
                            );
                          },
                          child: const Text('Hitung'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    width: 320,
                    height: 165,
                    color: const Color(0xFF3FBC4B),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _hasilHitung.isNotEmpty
                              ? ' Hasil: $_hasilHitung'
                              : '',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> calculateResult(
      double luasLahan, double luasPanen, int bibit) async {
    try {
      final response = await http.post(
        Uri.parse('https://6e50-112-215-145-74.ngrok-free.app/prediksi_mobile'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'luas_lahan': luasLahan,
          'luas_panen': luasPanen,
          'jumlah_bibit': bibit,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final hasilPrediksi = data['prediction_text'];

        if (hasilPrediksi != null) {
          setState(() {
            _hasilHitung = '$hasilPrediksi';
          });

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Hasil:'),
                content: Text('$hasilPrediksi'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Handle null or unexpected response
          print('Error: Null or unexpected response');
        }
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
    }
  }
}
