import 'package:flutter/material.dart';
import 'home_page.dart';
import 'grafik_page.dart';
import 'tips_keuangan_page.dart';
import 'goal_page.dart';
import 'laporan_keuangan_page.dart';

// Model data palsu untuk Leaderboard
class UserScore {
  final String username;
  final int score; // Score bisa berdasarkan total tabungan, atau rasio pemasukan/pengeluaran
  final String avatarUrl;

  UserScore({
    required this.username,
    required this.score,
    required this.avatarUrl,
  });
}

class LeaderboardPage extends StatelessWidget {
  final List<Map<String, dynamic>> transaksi;
  final int saldo;

  const LeaderboardPage({
    super.key,
    this.transaksi = const <Map<String, dynamic>>[],
    this.saldo = 0,
  });

  // Data Leaderboard palsu
  List<UserScore> get mockLeaderboard {
    // Skor diurutkan dari tertinggi ke terendah
    return [
      UserScore(username: "UserAnda", score: 550, avatarUrl: 'https://dl.dropboxusercontent.com/scl/fi/rn1qoh2bqexg4dredkeip/1760011347848.png?rlkey=p0aeb4z9xkwni1wm7z6dx04pm&st=ds0h5uva'),
      UserScore(username: "BudiSlayer", score: 850, avatarUrl: 'https://cdn.pixabay.com/photo/2016/08/20/05/38/avatar-1606916_1280.png'),
      UserScore(username: "AyuSaving", score: 780, avatarUrl: 'https://cdn.pixabay.com/photo/2016/08/20/05/38/avatar-1606915_1280.png'),
      UserScore(username: "EkoElite", score: 720, avatarUrl: 'https://cdn.pixabay.com/photo/2016/08/20/05/38/avatar-1606913_1280.png'),
      UserScore(username: "JokoHemat", score: 610, avatarUrl: 'https://cdn.pixabay.com/photo/2016/08/20/05/38/avatar-1606912_1280.png'),
      UserScore(username: "SantiKaya", score: 590, avatarUrl: 'https://cdn.pixabay.com/photo/2016/08/20/05/38/avatar-1606914_1280.png'),
    ]
    // Urutkan ulang berdasarkan score (tertinggi ke terendah)
    ..sort((a, b) => b.score.compareTo(a.score));
  }

  // Helper untuk membuat item navigasi drawer
  ListTile _drawerItem(BuildContext context, IconData icon, String title, Widget page, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final leaderboards = mockLeaderboard;
    // Cari posisi user saat ini dalam mock data
    final userPosition = leaderboards.indexWhere((u) => u.username == "UserAnda") + 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏆 Papan Peringkat'),
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
      ),
      
      // ================= DRAWER =================
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text('Sribuu Smart', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ),
            _drawerItem(context, Icons.home, "Beranda", HomePage(transaksi: transaksi, saldo: saldo), Colors.blue),
            _drawerItem(context, Icons.show_chart, "Grafik Keuangan", GrafikPage(transaksi: transaksi, saldo: saldo), Colors.blue),
            _drawerItem(context, Icons.lightbulb, "Tips Keuangan", TipsKeuanganPage(transaksi: transaksi, saldo: saldo), Colors.orange),
            _drawerItem(context, Icons.savings, "Goal Saving", GoalPage(totalSaldo: saldo, transaksi: transaksi), Colors.green),
            _drawerItem(context, Icons.table_chart, "Laporan Keuangan", LaporanKeuanganPage(transaksi: transaksi), Colors.indigo),
            _drawerItem(context, Icons.leaderboard, "Papan Peringkat", LeaderboardPage(transaksi: transaksi, saldo: saldo), Colors.red),
          ],
        ),
      ),

      // ================= BODY =================
      body: Column(
        children: [
          // Kartu Posisi Pengguna Saat Ini
          Card(
            margin: const EdgeInsets.all(16),
            color: Colors.amber[100],
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.star, color: Colors.amber, size: 40),
              title: const Text("Posisi Anda Saat Ini", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Peringkat #$userPosition | Skor: ${leaderboards.firstWhere((u) => u.username == "UserAnda").score}"),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),

          // Daftar Leaderboard
          Expanded(
            child: ListView.builder(
              itemCount: leaderboards.length,
              itemBuilder: (context, index) {
                final user = leaderboards[index];
                final rank = index + 1;
                
                IconData rankIcon;
                Color rankColor;
                if (rank == 1) {
                  rankIcon = Icons.military_tech;
                  rankColor = Colors.amber.shade700;
                } else if (rank == 2) {
                  rankIcon = Icons.military_tech;
                  rankColor = Colors.grey.shade500;
                } else if (rank == 3) {
                  rankIcon = Icons.military_tech;
                  rankColor = Colors.brown;
                } else {
                  rankIcon = Icons.circle;
                  rankColor = Colors.grey.shade400;
                }

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  elevation: user.username == "UserAnda" ? 6 : 2, // Menonjolkan user saat ini
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: user.username == "UserAnda" ? const BorderSide(color: Colors.red, width: 2) : BorderSide.none,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: CircleAvatar(
                      backgroundColor: rankColor,
                      child: Text(
                        rank.toString(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      user.username,
                      style: TextStyle(
                        fontWeight: user.username == "UserAnda" ? FontWeight.w900 : FontWeight.bold,
                        color: user.username == "UserAnda" ? Colors.red : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      "Skor Performa: ${user.score} poin",
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Icon(rankIcon, color: rankColor, size: 30),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}