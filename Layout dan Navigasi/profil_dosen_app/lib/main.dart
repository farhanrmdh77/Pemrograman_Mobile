import 'package:flutter/material.dart';
import 'second_page.dart';
import 'Anggota_Kelas.dart';
import 'mata_kuliah.dart';
import 'kontak_bantuan.dart';
import 'Feedback.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Profil Dosen',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Daftar profil dosen
  final List<Map<String, String>> dosenList = const [
    {
      'nama': 'WAHYU ANGGORO, M.Kom',
      'nip': '1571082309960021',
      'pengampu': 'Manajemen Resiko',
      'no hp': '+62 853-6945-4210',
      'foto': 'https://cdn-icons-png.flaticon.com/512/4140/4140059.png',
    },
    {
      'nama': 'POL METRA, M.Kom',
      'nip': '19910615010122045',
      'pengampu': 'Multimedia',
      'no hp': '+62 822-8435-5804',
      'foto': 'https://cdn-icons-png.flaticon.com/512/4140/4140048.png',
    },
    {
      'nama': 'AHMAD NASUKHA, S.Hum., M.S.I',
      'nip': '1988072220171009',
      'pengampu': 'Pemrograman Mobile',
      'no hp': '+62 852-6666-2666',
      'foto': 'assets/Gambar WhatsApp 2025-10-19 pukul 14.23.04_b1822db6.jpg',
    },
    {
      'nama': 'DILA NURLAILA, M.Kom',
      'nip': '1571015201960020',
      'pengampu': 'Rekayasa Perangkat Lunak',
      'no hp': '+62 895-3668-48906',
      'foto': 'assets/Gambar WhatsApp 2025-10-19 pukul 14.25.51_48c482a3.jpg',
    },
    {
      'nama': 'M. YUSUF, S.Kom., M.S.I',
      'nip': '1988021420191007',
      'pengampu': 'Technopreneurship',
      'no hp': '+62 813-6776-8297',
      'foto': 'assets/Gambar WhatsApp 2025-10-19 pukul 14.27.48_00e38c98.jpg',
    },
    {
      'nama': 'FATIMA FELAWATI, S.Kom., M.Kom',
      'nip': '199305112025052004',
      'pengampu': 'Testing dan Implementasi Sistem',
      'no hp': '+62 822-6979-4485',
      'foto': 'https://cdn-icons-png.flaticon.com/512/4140/4140051.png',
    },
    {
      'nama': 'Drs. H. SAWANG M. Pd',
      'nip': '123456789123456789',
      'pengampu': 'Akidah Akhlak',
      'no hp': '+62 852-6833-2123',
      'foto': 'assets/Gambar WhatsApp 2025-10-19 pukul 14.08.08_14765bdc.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan tombol garis tiga otomatis muncul (drawer)
      appBar: AppBar(
        title: const Text("Daftar Profil Dosen 5B Sistem Informasi"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      extendBodyBehindAppBar: true,

      // Drawer di sisi kanan
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                ),
              ),
              child: const Text(
                'Menu Navigasi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold, // 🔥 ini bikin teks jadi tebal
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Dosen Pembimbing'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Anggota Kelas'),
              subtitle: const Text('Lihat daftar anggota kelas.'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnggotaKelasPage(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Mata Kuliah'),
              subtitle: const Text('Lihat daftar mata kuliah.'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MataKuliahPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Kontak / Bantuan'),
              subtitle: const Text('Klik kontak / bantuan.'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const KontakBantuanPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.campaign),
              title: const Text('Berita / Pengumuman'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.feedback_rounded),
              title: const Text('Feedback'),
              subtitle: const Text('Berikan feedback anda.'),
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeedbackPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Tentang Aplikasi'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {},
            ),
            const Divider(),
          ],
        ),
      ),

      // Background gradasi
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: dosenList.length,
            itemBuilder: (context, index) {
              final dosen = dosenList[index];
              return Card(
                color: Colors.white.withOpacity(0.9),
                elevation: 6,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(dosen['foto']!),
                    radius: 28,
                  ),
                  title: Text(
                    dosen['nama']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    dosen['pengampu']!,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecondPage(
                          nama: dosen['nama']!,
                          nip: dosen['nip']!,
                          pengampu: dosen['pengampu']!,
                          no_hp: dosen['no hp']!,
                          foto: dosen['foto']!,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
