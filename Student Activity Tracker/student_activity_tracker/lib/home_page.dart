import 'package:flutter/material.dart';
import 'add_activity_page.dart';
import 'activity_detail_page.dart';
import 'model/activity_model.dart';

class HomePage extends StatefulWidget {
  final void Function(bool) onToggleDarkMode;
  final VoidCallback onSetPurple;
  final VoidCallback onSetBlue;

  const HomePage({
    super.key,
    required this.onToggleDarkMode,
    required this.onSetPurple,
    required this.onSetBlue,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ActivityModel> activities = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Activity Tracker"),
        actions: [
          PopupMenuButton<int>(
            onSelected: (v) {
              if (v == 1) widget.onSetBlue();
              if (v == 2) widget.onSetPurple();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 1, child: Text("Tema Biru")),
              PopupMenuItem(value: 2, child: Text("Tema Ungu")),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              // simple toggle: if currently dark -> light, else dark
              final brightness = Theme.of(context).brightness;
              widget.onToggleDarkMode(brightness != Brightness.dark);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push<ActivityModel?>(
            context,
            MaterialPageRoute(builder: (_) => const AddActivityPage()),
          );

          if (result != null) {
            setState(() {
              activities.add(result);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Aktivitas berhasil ditambahkan!")),
            );
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("Tambah Aktivitas Baru"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;
            if (activities.isEmpty) {
              return Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.list, size: 48),
                        SizedBox(height: 8),
                        Text(
                          "Belum ada aktivitas.Tekan tombol + untuk menambah.",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return isWide ? buildGrid() : buildList();
          },
        ),
      ),
    );
  }

  Widget buildList() {
    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(child: getIconForCategory(activity.category)),
            title: Text(activity.name),
            subtitle: Text(
              "${activity.duration.toInt()} Jam • ${activity.isDone ? "Selesai" : "Belum"}",
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ActivityDetailPage(activity: activity),
                ),
              );

              if (result == true) {
                setState(() {
                  activities.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Aktivitas dihapus")),
                );
              } else if (result is ActivityModel) {
                // edited activity returned
                setState(() {
                  activities[index] = result;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Aktivitas diperbarui")),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget buildGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return InkWell(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ActivityDetailPage(activity: activity),
              ),
            );

            if (result == true) {
              setState(() {
                activities.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Aktivitas dihapus")),
              );
            } else if (result is ActivityModel) {
              setState(() {
                activities[index] = result;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Aktivitas diperbarui")),
              );
            }
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  CircleAvatar(child: getIconForCategory(activity.category)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${activity.duration.toInt()} Jam • ${activity.isDone ? "Selesai" : "Belum"}",
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Icon getIconForCategory(String cat) {
    switch (cat) {
      case 'Belajar':
        return const Icon(Icons.menu_book);
      case 'Ibadah':
        return const Icon(Icons.self_improvement);
      case 'Olahraga':
        return const Icon(Icons.fitness_center);
      case 'Hiburan':
        return const Icon(Icons.movie);
      default:
        return const Icon(Icons.task);
    }
  }
}
