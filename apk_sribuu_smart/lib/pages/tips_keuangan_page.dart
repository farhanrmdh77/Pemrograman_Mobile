// File: tips_keuangan_page.dart

import 'package:flutter/material.dart';
import 'home_page.dart';
import 'grafik_page.dart';
import 'goal_page.dart';
import 'laporan_keuangan_page.dart';
import 'leaderboard_page.dart'; // ⬅️ IMPORT BARU

class TipsKeuanganPage extends StatelessWidget {
  // parameter agar data tetap terhubung
  final List<Map<String, dynamic>> transaksi;
  final int saldo;

  const TipsKeuanganPage({
    Key? key,
    this.transaksi = const <Map<String, dynamic>>[],
    this.saldo = 0,
  }) : super(key: key);

  final List<String> motivasi = const [
    "Jangan menabung apa yang tersisa setelah membelanjakan, tapi belanjakan apa yang tersisa setelah menabung. — Warren Buffett",
    "Investasi dalam ilmu pengetahuan memberikan keuntungan terbaik. — Benjamin Franklin",
    "Bukan seberapa banyak uang yang kamu hasilkan, tapi seberapa banyak yang kamu simpan, seberapa keras uang itu bekerja untukmu, dan berapa generasi yang bisa menikmatinya. — Robert Kiyosaki",
    "Sebagian besar kebebasan finansial adalah memiliki hati dan pikiran bebas dari kekhawatiran 'bagaimana jika' dalam hidup. — Suze Orman",
    "Kamu harus mengendalikan uangmu, atau kekurangannya akan selalu mengendalikanmu. — Dave Ramsey",
    "Bukan tentang gajimu, tapi tentang gaya hidupmu. — Tony Robbins",
  ];

  final List<String> tips = const [
    "Catat semua pengeluaran: Dengan mencatat, kamu tahu kemana uangmu pergi.",
    "Buat anggaran bulanan: Pisahkan kebutuhan pokok, tabungan, dan hiburan.",
    "Hidup sesuai kemampuan: Hindari gaya hidup yang membuat utang menumpuk.",
    "Siapkan dana darurat: Minimal 3–6 bulan pengeluaran untuk berjaga-jaga.",
    "Investasi sejak dini: Bahkan sedikit investasi rutin akan berkembang signifikan.",
    "Hindari hutang konsumtif: Utamakan utang produktif yang bisa menambah nilai.",
    "Review keuangan secara berkala: Setiap bulan cek apakah pengeluaran sesuai rencana.",
  ];

  void _logout(BuildContext context) {
    // Jika ingin menambahkan fungsi logout sebenarnya, tambahkan di sini
    Navigator.pop(context);
  }

  // Helper untuk navigasi drawer menggunakan pushReplacement
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tips & Motivasi Keuangan"),
        centerTitle: true,
        elevation: 4,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      // === Drawer Navigasi ===
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://dl.dropboxusercontent.com/scl/fi/rn1qoh2bqexg4dredkeip/1760011347848.png?rlkey=p0aeb4z9xkwni1wm7z6dx04pm&st=ds0h5uva',
                    height: 126,
                    width: 126,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            // === Navigasi ke halaman lain ===
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Beranda"),
              onTap: () {
                _navigateToPage(
                    context, HomePage(transaksi: transaksi, saldo: saldo));
              },
            ),
            ListTile(
              leading: const Icon(Icons.show_chart, color: Colors.blue),
              title: const Text("Grafik Keuangan"),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey),
              onTap: () {
                _navigateToPage(
                    context, GrafikPage(transaksi: transaksi, saldo: saldo));
              },
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb, color: Colors.orange),
              title: const Text("Tips Keuangan"),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey),
              onTap: () {
                Navigator.pop(context); // Tetap di halaman ini
              },
            ),
            ListTile(
              leading: const Icon(Icons.savings, color: Colors.green),
              title: const Text("Goal Saving"),
              onTap: () {
                _navigateToPage(
                  context,
                  GoalPage(
                    totalSaldo: saldo,
                    transaksi: transaksi,
                  ),
                );
              },
            ),
            // 🏆 PAPAN PERINGKAT ⬅️ BARU
            ListTile(
              leading: const Icon(Icons.leaderboard, color: Colors.red),
              title: const Text("Papan Peringkat"),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey),
              onTap: () {
                _navigateToPage(
                  context,
                  LeaderboardPage(transaksi: transaksi, saldo: saldo),
                );
              },
            ),
            // ------------------------------------
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.indigo),
              title: const Text("Laporan Keuangan"),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey),
              onTap: () {
                _navigateToPage(
                    context, LaporanKeuanganPage(transaksi: transaksi));
              },
            ),
          ],
        ),
      ),

      // === Isi Halaman Tips & Motivasi ===
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "📌 Tips Keuangan Sederhana tapi Efektif",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 12),
            ...tips.map(
              (t) => Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.orange),
                  title: Text(
                    t,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "💡 Kata-kata Motivasi Keuangan",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 12),
            ...motivasi.map(
              (m) => Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                margin:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                child: ListTile(
                  leading: const Icon(Icons.lightbulb, color: Colors.teal),
                  title: Text(
                    m,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}