import 'package:flutter/material.dart';

// Fungsi utama untuk menjalankan aplikasi
void main() {
  runApp(const BiodataApp());
}

// Widget utama yang merupakan StatelessWidget
class BiodataApp extends StatelessWidget {
  const BiodataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Judul aplikasi
      title: 'Biodata Diri',
      // Menonaktifkan banner debug di pojok kanan atas
      debugShowCheckedModeBanner: false,
      // Tema aplikasi (ganti warna utama)
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // Menggunakan warna ungu yang menarik
        fontFamily: 'Roboto', // Menggunakan font default yang bersih
      ),
      home: const BiodataScreen(),
    );
  }
}

// Screen utama untuk menampilkan biodata
class BiodataScreen extends StatelessWidget {
  const BiodataScreen({super.key});

  // Data Biodata
  final String nama = "M. Farhan Ramadhan";
  final String nim = "701230049";
  final String hobi = "Bermain Layangan";
  final String email = "ramadhanfarhan446@gmail.com"; // Contoh data tambahan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan judul dan warna yang sesuai tema
      appBar: AppBar(
        title: const Text(
          'Biodata Diri',
          style: TextStyle(
            color: Colors.white, // Warna teks putih
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple, // Warna AppBar ungu
        elevation: 4.0, // Menambahkan sedikit bayangan
      ),

      // Background body yang lebih cerah
      backgroundColor: Colors.grey[100],

      // Body utama
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 1. Profil Card (Bisa untuk foto, tapi kita pakai Icon saja dulu)
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.deepPurple,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            
            // 2. Card Biodata Utama
            Card(
              elevation: 8.0, // Bayangan yang lebih jelas
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), // Sudut yang membulat
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Judul Nama
                    _buildDetailRow(
                      icon: Icons.badge,
                      label: 'NAMA',
                      value: nama,
                      valueStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                    const Divider(height: 25, color: Colors.grey),
                    
                    // Detail NIM
                    _buildDetailRow(
                      icon: Icons.fingerprint,
                      label: 'NIM',
                      value: nim,
                    ),
                    const Divider(height: 25, color: Colors.grey),
                    
                    // Detail Hobi
                    _buildDetailRow(
                      icon: Icons.sports_volleyball,
                      label: 'HOBI',
                      value: hobi,
                    ),
                    const Divider(height: 25, color: Colors.grey),

                    // Detail Email (Contoh data tambahan)
                    _buildDetailRow(
                      icon: Icons.email,
                      label: 'EMAIL',
                      value: email,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi pembantu untuk membuat baris detail (Nama, NIM, Hobi, dll)
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, color: Colors.deepPurple, size: 24),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: valueStyle ?? const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}