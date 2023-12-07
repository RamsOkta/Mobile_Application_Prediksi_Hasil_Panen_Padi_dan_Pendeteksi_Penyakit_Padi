import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    CalculatorScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('P2D'),
        backgroundColor: const Color(0xFFBBE7C0),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Hitung',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFBBE7C0),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _uploadImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Ganti dengan URL server upload gambar
      String url = 'http://192.168.43.26:5000/uploads';
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        // Gambar berhasil diunggah
        print('Gambar berhasil diunggah');
      } else {
        // Gagal mengunggah gambar
        print('Gagal mengunggah gambar');
      }
    }
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150.0,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Ambil Foto'),
                onTap: () {
                  Navigator.pop(context);
                  _uploadImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _uploadImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: const Color(0xFFBBE7C0),
        centerTitle: true,
        flexibleSpace: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/logo.png', // Ganti dengan path logo aplikasi
              height: 80, // Sesuaikan tinggi logo sesuai kebutuhan
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: 305,
          height: 209,
          color: const Color(0xFF3FBC4B),
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk mengunggah foto di sini
                _showOptions(context);
              },
              child: const Text('Upload Foto'),
            ),
          ),
        ),
      ),
    );
  }
}

class CalculatorScreen extends StatelessWidget {
  final TextEditingController luasLahanController = TextEditingController();
  final TextEditingController luasPanenController = TextEditingController();
  final TextEditingController bibitController = TextEditingController();

  CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: const Color(0xFFBBE7C0),
      ),
      body: Center(
        child: Container(
          width: 320,
          height: 390,
          color: const Color(0xFF3FBC4B),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png', // Ganti dengan path logo aplikasi
                height: 80, // Sesuaikan tinggi logo sesuai kebutuhan
              ),
              SizedBox(height: 10),
              buildInputField("Luas Lahan (ha)", luasLahanController),
              buildInputField("Luas Panen (ha)", luasPanenController),
              buildInputField("Jumlah Bibit", bibitController),
              ElevatedButton(
                onPressed: () {
                  calculateResult(
                    context,
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

  void calculateResult(
      BuildContext context, double luasLahan, double luasPanen, int bibit) {
    // Tambahkan logika perhitungan di sini
    // Contoh perhitungan:
    double hasilHitung = (luasPanen / luasLahan) * bibit;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hasil Perhitungan'),
          content: Text('Hasil perhitungan: $hasilHitung'),
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
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo aplikasi di sini
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Image.asset(
                  'assets/logo.png', // Ganti dengan path gambar logo aplikasi Anda
                  height: 250, // Sesuaikan dengan ukuran yang diinginkan
                  width: 250, // Sesuaikan dengan ukuran yang diinginkan
                ),
              ),
              const Text(
                'Selamat Datang!',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Form login seperti sebelumnya
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan alamat email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Kata Sandi',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan kata sandi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Tambahkan logika untuk login dengan email dan kata sandi
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Warna tombol
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Atau login dengan:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tombol login Google dengan ikon
                  IconButton(
                    icon: Image.asset(
                        'assets/google_icon.png'), // Ganti dengan path gambar ikon Google
                    onPressed: () {
                      // Tambahkan logika untuk login dengan Google di sini
                    },
                  ),
                  const SizedBox(width: 20),
                  // Tombol login Facebook dengan ikon
                  IconButton(
                    icon: Image.asset(
                        'assets/facebook_icon.png'), // Ganti dengan path gambar ikon Facebook
                    onPressed: () {
                      // Tambahkan logika untuk login dengan Facebook di sini
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
