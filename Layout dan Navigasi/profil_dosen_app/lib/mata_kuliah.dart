import 'package:flutter/material.dart';

class MataKuliahPage extends StatelessWidget {
  const MataKuliahPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> jadwal = [
      {
        'mataKuliah': 'Pemrograman Mobile',
        'hari': 'Senin',
        'jamMasuk': '09:00',
        'jamKeluar': '12:20',
      },
      {
        'mataKuliah': 'Rekayasa Perangkat Lunak',
        'hari': 'Senin',
        'jamMasuk': '13:00',
        'jamKeluar': '15:00',
      },
      {
        'mataKuliah': 'Testing dan Implementasi Sistem',
        'hari': 'Rabu',
        'jamMasuk': '12:30',
        'jamKeluar': '15:00',
      },
      {
        'mataKuliah': 'Multimedia',
        'hari': 'Rabu',
        'jamMasuk': '15:01',
        'jamKeluar': '18:21',
      },
      {
        'mataKuliah': 'Manajemen Resiko',
        'hari': 'Kamis',
        'jamMasuk': '09:01',
        'jamKeluar': '11:31',
      },
      {
        'mataKuliah': 'Technopreneurship',
        'hari': 'Kamis',
        'jamMasuk': '12:30',
        'jamKeluar': '15.00',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jadwal Mata Kuliah',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlue, Colors.blueAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: jadwal.length,
          itemBuilder: (context, index) {
            final data = jadwal[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon bagian kiri (timeline style)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.access_time_filled,
                      color: Colors.blueAccent,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 15),

                  // Isi kartu jadwal
                  Expanded(
                    child: Card(
                      color: Colors.white.withOpacity(0.9),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['mataKuliah']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    color: Colors.blueAccent, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  data['hari']!,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.schedule,
                                    color: Colors.blueAccent, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  "${data['jamMasuk']} - ${data['jamKeluar']}",
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
