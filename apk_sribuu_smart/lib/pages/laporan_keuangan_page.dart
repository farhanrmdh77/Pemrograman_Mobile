// File: laporan_keuangan_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home_page.dart';
import 'grafik_page.dart';
import 'tips_keuangan_page.dart';
import 'goal_page.dart';
import 'leaderboard_page.dart'; // ⬅️ IMPORT BARU

class LaporanKeuanganPage extends StatelessWidget {
  final List<Map<String, dynamic>> transaksi;

  const LaporanKeuanganPage({super.key, required this.transaksi});

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  // Drawer item helper
  Widget _drawerItem(BuildContext context,
      {required IconData icon,
      required String title,
      required Color color,
      required Widget page}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: () {
        // Menggunakan pushReplacement untuk navigasi drawer
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> laporan = [];
    int saldo = 0;

    final sorted = List<Map<String, dynamic>>.from(transaksi)
      ..sort((a, b) =>
          DateTime.parse(a['tanggal']).compareTo(DateTime.parse(b['tanggal'])));

    // Hitung saldo dan siapkan data laporan
    for (var item in sorted) {
      int debit = item['jenis'] == 'masuk' ? item['jumlah'] as int : 0;
      int kredit = item['jenis'] == 'keluar' ? item['jumlah'] as int : 0;
      saldo += debit - kredit;

      laporan.add({
        'tanggal':
            DateFormat('dd/MM/yyyy').format(DateTime.parse(item['tanggal'])),
        'keterangan': item['keterangan'],
        'debit': debit,
        'kredit': kredit,
        'saldo': saldo,
      });
    }

    int totalDebit =
        laporan.fold(0, (sum, item) => sum + (item['debit'] as int));
    int totalKredit =
        laporan.fold(0, (sum, item) => sum + (item['kredit'] as int));
    int saldoAkhir = saldo;

    final currency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Keuangan Bulanan'),
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

      // ================= DRAWER =================
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
            _drawerItem(
              context,
              icon: Icons.home,
              title: "Beranda",
              color: Colors.blue,
              page: const HomePage(),
            ),
            _drawerItem(
              context,
              icon: Icons.show_chart,
              title: "Grafik Keuangan",
              color: Colors.green,
              page: GrafikPage(transaksi: transaksi, saldo: saldo),
            ),
            _drawerItem(
              context,
              icon: Icons.lightbulb,
              title: "Tips Keuangan",
              color: Colors.orange,
              // Perlu menyediakan transaksi dan saldo
              page: TipsKeuanganPage(transaksi: transaksi, saldo: saldo),
            ),
            _drawerItem(
              context,
              icon: Icons.savings,
              title: "Goal Saving",
              color: Colors.teal,
              page: GoalPage(
                totalSaldo: saldo,
                transaksi: transaksi,
              ),
            ),
            // 🏆 PAPAN PERINGKAT ⬅️ BARU
            _drawerItem(
              context,
              icon: Icons.leaderboard,
              title: "Papan Peringkat",
              color: Colors.red,
              page: LeaderboardPage(transaksi: transaksi, saldo: saldo),
            ),
            // ---------------------------------
            _drawerItem(
              context,
              icon: Icons.table_chart,
              title: "Laporan Keuangan",
              color: Colors.indigo,
              page: LaporanKeuanganPage(transaksi: transaksi),
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double fontSize = constraints.maxWidth < 400 ? 11 : 13;

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          "LAPORAN KEUANGAN BULAN ${DateFormat('MMMM yyyy', 'id_ID').format(DateTime.now()).toUpperCase()}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Table(
                          border: TableBorder.all(color: Colors.black12),
                          columnWidths: const {
                            0: FlexColumnWidth(1.2),
                            1: FlexColumnWidth(2.3),
                            2: FlexColumnWidth(3.5),
                            3: FlexColumnWidth(2.5),
                            4: FlexColumnWidth(2.5),
                            5: FlexColumnWidth(2.5),
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: Colors.blue[100]),
                              children: [
                                _headerCell("No", fontSize),
                                _headerCell("Tanggal", fontSize),
                                _headerCell("Keterangan", fontSize),
                                _headerCell("Debit", fontSize),
                                _headerCell("Kredit", fontSize),
                                _headerCell("Saldo", fontSize),
                              ],
                            ),
                            ...laporan.asMap().entries.map((entry) {
                              int index = entry.key + 1;
                              var item = entry.value;
                              return TableRow(children: [
                                _cell(index.toString(), fontSize),
                                _cell(item['tanggal'], fontSize),
                                _cell(item['keterangan'], fontSize),
                                _cell(
                                  item['debit'] == 0
                                      ? "-"
                                      : currency.format(item['debit']),
                                  fontSize,
                                ),
                                _cell(
                                  item['kredit'] == 0
                                      ? "-"
                                      : currency.format(item['kredit']),
                                  fontSize,
                                ),
                                _cell(currency.format(item['saldo']), fontSize),
                              ]);
                            }),
                            TableRow(
                              decoration:
                                  BoxDecoration(color: Colors.yellow[200]),
                              children: [
                                _cell("", fontSize),
                                _cell("", fontSize),
                                _cell("Jumlah", fontSize,
                                    isBold: true, align: TextAlign.center),
                                _cell(currency.format(totalDebit), fontSize,
                                    isBold: true),
                                _cell(currency.format(totalKredit), fontSize,
                                    isBold: true),
                                _cell(currency.format(saldoAkhir), fontSize,
                                    isBold: true),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ================= KOMPONEN TAMBAHAN =================
  Widget _headerCell(String text, double fontSize) => Padding(
        padding: const EdgeInsets.all(6),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize + 1),
        ),
      );

  Widget _cell(String text, double fontSize,
      {bool isBold = false, TextAlign align = TextAlign.center}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}