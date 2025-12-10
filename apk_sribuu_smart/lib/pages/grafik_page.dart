// File: grafik_page.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'home_page.dart';
import 'tips_keuangan_page.dart';
import 'goal_page.dart';
import 'laporan_keuangan_page.dart';
import 'leaderboard_page.dart'; // ⬅️ IMPORT BARU

class GrafikPage extends StatefulWidget {
  final List<Map<String, dynamic>> transaksi;
  final int saldo;

  const GrafikPage({
    Key? key,
    required this.transaksi,
    required this.saldo,
  }) : super(key: key);


  @override
  State<GrafikPage> createState() => _GrafikPageState();
}

class _GrafikPageState extends State<GrafikPage> {
  bool isBarChart = true;

  void _logout(BuildContext context) {
    // Menggunakan pushReplacement untuk kembali ke halaman login, asumsi '/login' terdaftar
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Ambil dan urutkan tanggal
  List<String> _getSortedDates({bool hanyaYangAdaData = false}) {
    final semuaTanggal = widget.transaksi
        .map((item) => DateFormat('dd/MM/yyyy').format(DateTime.parse(item['tanggal'])))
        .toSet()
        .toList();

    semuaTanggal.sort((a, b) =>
        DateFormat('dd/MM/yyyy').parse(a).compareTo(DateFormat('dd/MM/yyyy').parse(b)));

    if (!hanyaYangAdaData) return semuaTanggal;

    return semuaTanggal.where((tanggal) {
      final totalMasuk = widget.transaksi.where((item) =>
          item['jenis'] == 'masuk' &&
          DateFormat('dd/MM/yyyy').format(DateTime.parse(item['tanggal'])) == tanggal);
      final totalKeluar = widget.transaksi.where((item) =>
          item['jenis'] == 'keluar' &&
          DateFormat('dd/MM/yyyy').format(DateTime.parse(item['tanggal'])) == tanggal);
      return totalMasuk.isNotEmpty || totalKeluar.isNotEmpty;
    }).toList();
  }

  // Buat data campuran (masuk dan keluar)
  List<BarChartGroupData> _generateCampuranData() {
    final sortedDates = _getSortedDates(hanyaYangAdaData: true);
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < sortedDates.length; i++) {
      final tanggal = sortedDates[i];
      final totalMasuk = widget.transaksi
          .where((item) =>
              item['jenis'] == 'masuk' &&
              DateFormat('dd/MM/yyyy').format(DateTime.parse(item['tanggal'])) == tanggal)
          .fold(0, (sum, item) => sum + (item['jumlah'] as int));
      final totalKeluar = widget.transaksi
          .where((item) =>
              item['jenis'] == 'keluar' &&
              DateFormat('dd/MM/yyyy').format(DateTime.parse(item['tanggal'])) == tanggal)
          .fold(0, (sum, item) => sum + (item['jumlah'] as int));

      if (totalMasuk > 0 || totalKeluar > 0) {
        barGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              if (totalMasuk > 0)
                BarChartRodData(toY: totalMasuk.toDouble(), color: Colors.green, width: 10),
              if (totalKeluar > 0)
                BarChartRodData(toY: totalKeluar.toDouble(), color: Colors.red, width: 10),
            ],
            barsSpace: 6,
          ),
        );
      }
    }
    return barGroups;
  }

  // Buat data tunggal (hanya masuk / keluar)
  List<BarChartGroupData> _generateSingleTypeData(String type) {
    final sortedDates = _getSortedDates(hanyaYangAdaData: true);
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < sortedDates.length; i++) {
      final tanggal = sortedDates[i];
      final total = widget.transaksi
          .where((item) =>
              item['jenis'] == type &&
              DateFormat('dd/MM/yyyy').format(DateTime.parse(item['tanggal'])) == tanggal)
          .fold(0, (sum, item) => sum + (item['jumlah'] as int));

      if (total > 0) {
        Color barColor = type == 'masuk' ? Colors.green : Colors.red;
        barGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [BarChartRodData(toY: total.toDouble(), color: barColor, width: 14)],
          ),
        );
      }
    }
    return barGroups;
  }

  // Buat titik data untuk line chart
  List<FlSpot> _generateLineSpots(String type) {
    final sortedDates = _getSortedDates(hanyaYangAdaData: true);
    List<FlSpot> spots = [];

    for (int i = 0; i < sortedDates.length; i++) {
      final tanggal = sortedDates[i];
      final total = widget.transaksi
          .where((item) =>
              item['jenis'] == type &&
              DateFormat('dd/MM/yyyy').format(DateTime.parse(item['tanggal'])) == tanggal)
          .fold(0, (sum, item) => sum + (item['jumlah'] as int));
      if (total > 0) {
        spots.add(FlSpot(i.toDouble(), total.toDouble()));
      }
    }
    return spots;
  }

  // =================== UI ===================
  @override
  Widget build(BuildContext context) {
    final tanggalSekarang =
        DateFormat('EEEE, dd MMM yyyy HH:mm', 'id').format(DateTime.now());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Grafik Keuangan'),
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
              icon: Icon(isBarChart ? Icons.show_chart : Icons.bar_chart),
              onPressed: () => setState(() => isBarChart = !isBarChart),
              tooltip: "Ubah tampilan grafik",
            ),
            IconButton(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Campuran"),
              Tab(text: "Menerima"),
              Tab(text: "Membayar"),
            ],
          ),
        ),

        // Drawer
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
        child: const Icon(
          Icons.account_balance_wallet,
          size: 80,
          color: Colors.white,
        ),
      ),

      // 🔹 BERANDA
      _drawerItem(
        context,
        Icons.home,
        "Beranda",
        // Menggunakan widget.transaksi dan widget.saldo untuk mempertahankan data saat navigasi
        HomePage(transaksi: widget.transaksi, saldo: widget.saldo), 
        Colors.blue,
      ),

      // 🔹 GRAFIK KEUANGAN
      _drawerItem(
        context,
        Icons.show_chart,
        "Grafik Keuangan",
        // Tetap di halaman ini
        GrafikPage(
          transaksi: widget.transaksi,
          saldo: widget.saldo,
        ),
        Colors.blue,
      ),

      // 🔹 TIPS KEUANGAN
      _drawerItem(
        context,
        Icons.lightbulb,
        "Tips Keuangan",
        TipsKeuanganPage(
          transaksi: widget.transaksi,
          saldo: widget.saldo,
        ),
        Colors.orange,
      ),

      // 🔹 GOAL SAVING
      _drawerItem(
        context,
        Icons.savings,
        "Goal Saving",
        GoalPage(
          totalSaldo: widget.saldo,
          transaksi: widget.transaksi,
        ),
        Colors.green,
      ),
      
      // 🏆 PAPAN PERINGKAT ⬅️ BARU
      _drawerItem(
        context,
        Icons.leaderboard,
        "Papan Peringkat",
        LeaderboardPage(
          transaksi: widget.transaksi,
          saldo: widget.saldo,
        ),
        Colors.red,
      ),

      // 🔹 LAPORAN KEUANGAN
      _drawerItem(
        context,
        Icons.table_chart,
        "Laporan Keuangan",
        LaporanKeuanganPage(transaksi: widget.transaksi),
        Colors.indigo,
      ),
    ],
  ),
),

        // Body
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  isBarChart ? _buildBarChartCampuran() : _buildLineChartCampuran(),
                  isBarChart ? _buildBarChartSingle('masuk') : _buildLineChartSingle('masuk'),
                  isBarChart ? _buildBarChartSingle('keluar') : _buildLineChartSingle('keluar'),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey.shade100,
              width: double.infinity,
              child: Text(
                "Diperbarui: $tanggalSekarang",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _drawerItem(
      BuildContext context, IconData icon, String title, Widget page, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        Navigator.pop(context);
        // Menggunakan pushReplacement agar halaman drawer tidak menumpuk di stack
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page)); 
      },
    );
  }

  // =================== CHART ===================

  Widget _buildBarChartCampuran() {
    final barData = _generateCampuranData();
    final sortedDates = _getSortedDates(hanyaYangAdaData: true);

    if (barData.isEmpty) return const Center(child: Text("Belum ada data transaksi"));

    final maxY = barData
            .map((e) => e.barRods.map((r) => r.toY).reduce((a, b) => a > b ? a : b))
            .reduce((a, b) => a > b ? a : b) *
        1.2;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          maxY: maxY,
          barGroups: barData,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 36,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= sortedDates.length) return const SizedBox.shrink();
                  return Text(
                    sortedDates[index],
                    style: const TextStyle(fontSize: 11),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          gridData: const FlGridData(show: true),
        ),
      ),
    );
  }

  Widget _buildLineChartCampuran() {
    final masukSpots = _generateLineSpots('masuk');
    final keluarSpots = _generateLineSpots('keluar');
    final sortedDates = _getSortedDates(hanyaYangAdaData: true);

    if (masukSpots.isEmpty && keluarSpots.isEmpty) {
      return const Center(child: Text("Belum ada data transaksi"));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: sortedDates.length - 1,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 36,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= sortedDates.length) return const SizedBox.shrink();
                  return Text(
                    sortedDates[index],
                    style: const TextStyle(fontSize: 11),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: true),
          lineBarsData: [
            LineChartBarData(spots: masukSpots, isCurved: true, color: Colors.green),
            LineChartBarData(spots: keluarSpots, isCurved: true, color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChartSingle(String type) {
    final barData = _generateSingleTypeData(type);
    final sortedDates = _getSortedDates(hanyaYangAdaData: true);

    if (barData.isEmpty) return const Center(child: Text("Belum ada data transaksi"));

    final maxY =
        barData.map((e) => e.barRods[0].toY).reduce((a, b) => a > b ? a : b) * 1.2;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          maxY: maxY,
          barGroups: barData,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 36,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= sortedDates.length) return const SizedBox.shrink();
                  return Text(
                    sortedDates[index],
                    style: const TextStyle(fontSize: 11),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          gridData: const FlGridData(show: true),
        ),
      ),
    );
  }

  Widget _buildLineChartSingle(String type) {
    final spots = _generateLineSpots(type);
    final sortedDates = _getSortedDates(hanyaYangAdaData: true);

    if (spots.isEmpty) return const Center(child: Text("Belum ada data transaksi"));

    final color = type == 'masuk' ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: sortedDates.length - 1,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 36,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= sortedDates.length) return const SizedBox.shrink();
                  return Text(
                    sortedDates[index],
                    style: const TextStyle(fontSize: 11),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: true),
          lineBarsData: [
            LineChartBarData(spots: spots, isCurved: true, color: color),
          ],
        ),
      ),
    );
  }
}