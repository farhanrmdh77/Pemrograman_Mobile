import 'package:flutter/material.dart';
import 'add_activity_page.dart';
import 'model/activity_model.dart';

class ActivityDetailPage extends StatelessWidget {
  final ActivityModel activity;
  const ActivityDetailPage({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Aktivitas")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama Aktivitas: ${activity.name}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Text("Kategori: ${activity.category}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Text("Durasi: ${activity.duration.toInt()} Jam", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Text("Status: ${activity.isDone ? "Selesai" : "Belum"}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Text("Catatan: ${activity.notes}", style: const TextStyle(fontSize: 18)),
            const Spacer(),
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
                        // Return edited model to previous page (Home)
                        Navigator.pop(context, edited);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
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
                              onPressed: () {
                                Navigator.pop(context); // close dialog
                                Navigator.pop(context, true); // signal delete
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
