import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Navigasi Flutter',
      theme: ThemeData(
        useMaterial3: true, // ✅ Mengaktifkan Material 3
        colorSchemeSeed: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Daftar halaman untuk BottomNavigationBar
  final List<Widget> _pages = [
    const HomePage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Flutter Demo'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 🏠 HALAMAN 1: HOME PAGE
// ------------------------------------------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Masukkan nama kamu:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Contoh: Farhan',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              String nama = controller.text.trim();
              if (nama.isNotEmpty) {
                // ✅ Kirim data ke halaman Detail
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(nama: nama),
                  ),
                );
              }
            },
            child: const Text('Kirim ke Halaman Detail'),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 📄 HALAMAN 2: DETAIL PAGE (menerima data)
// ------------------------------------------------------------
class DetailPage extends StatelessWidget {
  final String nama;

  const DetailPage({super.key, required this.nama});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Halo, $nama!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ini adalah halaman detail yang menerima data dari halaman sebelumnya.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // ✅ Kembali ke halaman sebelumnya
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// 👤 HALAMAN 3: PROFILE PAGE (diakses dari BottomNavigationBar)
// ------------------------------------------------------------
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Ini halaman profil',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
      ),
    );
  }
}
