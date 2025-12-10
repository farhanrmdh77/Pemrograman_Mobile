import 'package:flutter/material.dart';
import 'add_activity_page.dart';
import 'model/activity_model.dart';

class ActivityDetailPage extends StatelessWidget {
  final ActivityModel activity;
  const ActivityDetailPage({super.key, required this.activity});

  // Widget pembangun untuk setiap detail dalam Card
  Widget _buildDetailCard(
    BuildContext context,
    String label,
    String value, {
    required IconData icon,
    Color? color,
    bool isTitle = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ikon di sisi kiri
            Icon(icon, color: color ?? Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label (misalnya: Nama Aktivitas)
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  // Nilai (misalnya: Belajar Flutter)
                  Text(
                    value,
                    style: isTitle
                        ? Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold)
                        : Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Aktivitas")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Nama Aktivitas (sebagai judul utama)
            _buildDetailCard(
              context,
              "Nama Aktivitas",
              activity.name,
              icon: Icons.label_important,
              isTitle: true,
            ),
            // 2. Kategori
            _buildDetailCard(
              context,
              "Kategori",
              activity.category,
              icon: Icons.category,
            ),
            // 3. Durasi
            _buildDetailCard(
              context,
              "Durasi",
              "${activity.duration.toInt()} Jam",
              icon: Icons.timer,
            ),
            // 4. Status
            _buildDetailCard(
              context,
              "Status",
              activity.isDone ? "Selesai" : "Belum Selesai",
              icon: activity.isDone ? Icons.check_circle : Icons.pending,
              // Memberi warna ikon/teks status
              color: activity.isDone ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.secondary,
            ),
            // 5. Catatan
            _buildDetailCard(
              context,
              "Catatan",
              activity.notes.isEmpty ? "Tidak ada catatan" : activity.notes,
              icon: Icons.note_alt,
            ),
            
            const Spacer(), // Mendorong tombol ke bawah
            
            // Tombol Aksi (Edit & Hapus)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                    onPressed: () async {
                      final edited = await Navigator.push<ActivityModel?>(
                        context,
                        MaterialPageRoute(builder: (_) => AddActivityPage(existing: activity)),
                      );
                      if (edited != null) {
                        // Kembali ke halaman sebelumnya dengan model yang diedit
                        Navigator.pop(context, edited);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    // Menggunakan warna yang lebih lembut dari colorScheme untuk latar belakang tombol hapus
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.errorContainer, 
                      foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    icon: const Icon(Icons.delete),
                    label: const Text("Hapus Aktivitas"),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Hapus Aktivitas?"),
                          content: const Text("Yakin ingin menghapus aktivitas ini?"),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
                            ElevatedButton(
                              // Menggunakan warna Error utama untuk tombol konfirmasi hapus
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.error,
                                foregroundColor: Theme.of(context).colorScheme.onError,
                              ),
                              onPressed: () {
                                Navigator.pop(context); // close dialog
                                Navigator.pop(context, true); // signal delete (true)
                              },
                              child: const Text("Hapus"),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}