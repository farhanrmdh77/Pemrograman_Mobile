import 'package:flutter/material.dart';
import 'model/activity_model.dart';

class AddActivityPage extends StatefulWidget {
  final ActivityModel? existing;
  const AddActivityPage({super.key, this.existing});

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  final nameController = TextEditingController();
  final notesController = TextEditingController();

  String category = "Belajar";
  double duration = 1;
  bool isDone = false;

  final categories = [
    "Belajar",
    "Ibadah",
    "Olahraga",
    "Hiburan",
    "Lainnya",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      nameController.text = widget.existing!.name;
      notesController.text = widget.existing!.notes;
      category = widget.existing!.category;
      duration = widget.existing!.duration;
      isDone = widget.existing!.isDone;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Aktivitas" : "Tambah Aktivitas")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nama Aktivitas"),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                items: categories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => category = v!),
                decoration: const InputDecoration(labelText: "Kategori Aktivitas"),
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Durasi (Jam): ${duration.toInt()}"),
                  Slider(
                    value: duration,
                    min: 1,
                    max: 8,
                    divisions: 7,
                    label: duration.toInt().toString(),
                    onChanged: (v) => setState(() => duration = v),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text("Status Aktivitas"),
                subtitle: Text(isDone ? "Sudah Selesai" : "Belum"),
                value: isDone,
                onChanged: (v) => setState(() => isDone = v),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: "Catatan Tambahan"),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.trim().isEmpty) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Error"),
                              content: const Text("Nama Aktivitas wajib diisi!"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
                              ],
                            ),
                          );
                          return;
                        }

                        final newActivity = ActivityModel(
                          name: nameController.text.trim(),
                          category: category,
                          duration: duration,
                          isDone: isDone,
                          notes: notesController.text.trim(),
                        );

                        Navigator.pop(context, newActivity);
                      },
                      child: Text(isEditing ? "Simpan Perubahan" : "Simpan"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
