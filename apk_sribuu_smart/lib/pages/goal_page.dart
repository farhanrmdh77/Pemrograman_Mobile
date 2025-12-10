// File: goal_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'grafik_page.dart';
import 'tips_keuangan_page.dart';
import 'laporan_keuangan_page.dart';
import 'leaderboard_page.dart'; // ⬅️ IMPORT BARU

// ================= MODEL GOAL =================
class Goal {
  String name;
  double target;

  Goal({required this.name, required this.target});

  Map<String, dynamic> toMap() {
    return {'name': name, 'target': target};
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      name: map['name'],
      target: map['target'].toDouble(),
    );
  }
}

// ================= HALAMAN GOAL SAVING =================
class GoalPage extends StatefulWidget {
  final int totalSaldo;
  final List<Map<String, dynamic>> transaksi;

  const GoalPage({
    Key? key,
    required this.totalSaldo,
    required this.transaksi,
  }) : super(key: key);

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  List<Goal> goals = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController targetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadGoals();
  }

  // Simpan semua goal + goal terakhir sebagai goal aktif
  Future<void> saveGoals() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> goalStrings =
        goals.map((goal) => jsonEncode(goal.toMap())).toList();
    await prefs.setStringList('goals', goalStrings);

    if (goals.isNotEmpty) {
      final activeGoal = goals.last;
      prefs.setString('goal', jsonEncode({
        'name': activeGoal.name,
        'target': activeGoal.target,
        'progress': widget.totalSaldo,
      }));
    }
  }

  // Muat semua goal
  Future<void> loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? goalStrings = prefs.getStringList('goals');
    if (goalStrings != null) {
      setState(() {
        goals = goalStrings.map((g) => Goal.fromMap(jsonDecode(g))).toList();
      });
    }
  }

  void addGoal() {
    String name = nameController.text;
    double target = double.tryParse(targetController.text) ?? 0;
    if (name.isNotEmpty && target > 0) {
      setState(() {
        goals.add(Goal(name: name, target: target));
      });
      saveGoals();
      nameController.clear();
      targetController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Goal '$name' berhasil ditambahkan dan dijadikan goal aktif."),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void editGoal(int index) {
    nameController.text = goals[index].name;
    targetController.text = goals[index].target.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Edit Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Goal'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Target Nominal'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                goals[index].name = nameController.text;
                goals[index].target =
                    double.tryParse(targetController.text) ?? goals[index].target;
              });
              saveGoals();
              nameController.clear();
              targetController.clear();
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void deleteGoal(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      goals.removeAt(index);
    });
    await saveGoals();

    // Jika semua goal dihapus, hapus juga goal aktif
    if (goals.isEmpty) {
      prefs.remove('goal');
    }
  }

  double calculatePercentage(double target) {
    if (widget.totalSaldo <= 0) return 0;
    double percent = (widget.totalSaldo / target) * 100;
    if (percent > 100) percent = 100;
    return percent;
  }

  void _logout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logout berhasil")),
    );
  }

  // ============== UI ==============
  @override
  Widget build(BuildContext context) {
    int saldo = widget.totalSaldo;
    final transaksi = widget.transaksi;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        title: const Text('Goal Saving'),
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
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
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
              child: Center(
                child: Image.network(
                  'https://dl.dropboxusercontent.com/scl/fi/rn1qoh2bqexg4dredkeip/1760011347848.png?rlkey=p0aeb4z9xkwni1wm7z6dx04pm&st=ds0h5uva',
                  height: 120,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.blue),
              title: const Text("Beranda"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.show_chart, color: Colors.blue),
              title: const Text("Grafik Keuangan"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GrafikPage(
                      transaksi: transaksi,
                      saldo: saldo,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb, color: Colors.orange),
              title: const Text("Tips Keuangan"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TipsKeuanganPage(
                      transaksi: transaksi,
                      saldo: saldo,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.savings, color: Colors.green),
              title: const Text("Goal Saving"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // 🏆 PAPAN PERINGKAT ⬅️ BARU
            ListTile(
              leading: const Icon(Icons.leaderboard, color: Colors.red),
              title: const Text("Papan Peringkat"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LeaderboardPage(
                      transaksi: transaksi,
                      saldo: saldo, // Mengganti totalSaldo menjadi saldo
                    ),
                  ),
                );
              },
            ),
            // ---------------------------------
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.indigo),
              title: const Text("Laporan Keuangan"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LaporanKeuanganPage(transaksi: transaksi),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Goal',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.flag),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: targetController,
                decoration: InputDecoration(
                  labelText: 'Target Nominal',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                onPressed: addGoal,
                label: const Text('Tambah Goal'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: goals.isEmpty
                    ? const Center(child: Text('Belum ada goal'))
                    : ListView.builder(
                        itemCount: goals.length,
                        itemBuilder: (context, index) {
                          final goal = goals[index];
                          double percent = calculatePercentage(goal.target);

                          return GestureDetector(
                            onTap: () => editGoal(index),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    CircularPercentIndicator(
                                      radius: 30,
                                      lineWidth: 6,
                                      percent: percent / 100,
                                      center: Text(
                                        "${percent.toInt()}%",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      progressColor: Colors.blue,
                                      backgroundColor: Colors.grey.shade300,
                                      circularStrokeCap: CircularStrokeCap.round,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            goal.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Target: Rp ${goal.target.toStringAsFixed(0)}",
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () => deleteGoal(index),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}