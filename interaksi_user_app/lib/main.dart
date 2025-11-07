import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

/// ===============================================
/// App Root
/// ===============================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'State & Interaksi • Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

/// ===============================================
/// MODEL sederhana untuk data form
/// ===============================================
class FeedbackItem {
  final String name;
  final String gender;           // "L" / "P"
  final double rating;           // 1..5
  final bool isAgree;            // setuju syarat
  final List<String> hobbies;    // ["Coding","Olahraga",...]
  final String comment;

  FeedbackItem({
    required this.name,
    required this.gender,
    required this.rating,
    required this.isAgree,
    required this.hobbies,
    required this.comment,
  });
}

/// ===============================================
/// HOME: menampilkan daftar feedback + tombol ke Counter demo + tambah feedback
/// ===============================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<FeedbackItem> _items = [];

  Future<void> _openForm() async {
    final result = await Navigator.push<FeedbackItem>(
      context,
      MaterialPageRoute(builder: (_) => const FeedbackFormPage()),
    );

    if (result != null) {
      setState(() => _items.add(result));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback berhasil ditambahkan')),
      );
    }
  }

  void _openCounterDemo() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CounterPage()));
  }

  void _openDetail(FeedbackItem item) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(item: item)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo: State & Interaksi Pengguna"),
      ),
      body: Column(
        children: [
          // Banner aksi cepat
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.add_comment),
                    label: const Text("Tambah Feedback"),
                    onPressed: _openForm,
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.exposure_plus_1),
                  label: const Text("Counter Demo"),
                  onPressed: _openCounterDemo,
                ),
              ],
            ),
          ),
          const Divider(height: 16),
          // Daftar feedback
          Expanded(
            child: _items.isEmpty
                ? const Center(
              child: Text(
                "Belum ada data.\nTekan \"Tambah Feedback\" untuk mulai.",
                textAlign: TextAlign.center,
              ),
            )
                : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, i) {
                final it = _items[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(it.name.isNotEmpty ? it.name[0].toUpperCase() : "?"),
                    ),
                    title: Text(it.name),
                    subtitle: Text(
                      "Gender: ${it.gender == 'L' ? 'Laki-laki' : 'Perempuan'}  •  "
                          "Rating: ${it.rating.toStringAsFixed(1)}  •  "
                          "Hobi: ${it.hobbies.join(', ')}",
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _openDetail(it),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openForm,
        icon: const Icon(Icons.add),
        label: const Text("Feedback"),
      ),
    );
  }
}

/// ===============================================
/// COUNTER DEMO: setState() + FAB (+ / - / reset)
/// ===============================================
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  void _inc() => setState(() => _counter++);
  void _dec() => setState(() => _counter--);
  void _reset() => setState(() => _counter = 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Counter • setState() Demo")),
      body: Center(
        child: Text(
          "$_counter",
          style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          "Penjelasan: setiap tombol memanggil setState() untuk mengubah nilai _counter "
              "dan memicu rebuild UI.",
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(onPressed: _dec, child: const Icon(Icons.remove)),
          const SizedBox(width: 12),
          FloatingActionButton(onPressed: _inc, child: const Icon(Icons.add)),
          const SizedBox(width: 12),
          FloatingActionButton.small(onPressed: _reset, child: const Icon(Icons.refresh)),
        ],
      ),
    );
  }
}

/// ===============================================
/// FORM PAGE: TextField, Radio, Checkbox, Switch, Slider + validasi
/// Mengembalikan FeedbackItem melalui Navigator.pop(context, data)
/// ===============================================
class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _commentCtrl = TextEditingController();

  String _gender = "L";
  double _rating = 3;
  bool _agree = false;

  // checkbox hobbies
  final Map<String, bool> _hobbyMap = {
    "Coding": false,
    "Membaca": false,
    "Olahraga": false,
  };

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final hobbies = _hobbyMap.entries.where((e) => e.value).map((e) => e.key).toList();

    if (!_agree) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Perlu Persetujuan"),
          content: const Text("Centang \"Setuju syarat & ketentuan\" untuk melanjutkan."),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
        ),
      );
      return;
    }

    final item = FeedbackItem(
      name: _nameCtrl.text.trim(),
      gender: _gender,
      rating: _rating,
      isAgree: _agree,
      hobbies: hobbies,
      comment: _commentCtrl.text.trim(),
    );

    Navigator.pop(context, item);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Feedback Pengguna")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: "Nama",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? "Nama wajib diisi" : null,
            ),
            const SizedBox(height: 16),
            // Gender - Radio
            const Text("Jenis Kelamin", style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    value: "L",
                    groupValue: _gender,
                    title: const Text("Laki-laki"),
                    onChanged: (v) => setState(() => _gender = v ?? "L"),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    value: "P",
                    groupValue: _gender,
                    title: const Text("Perempuan"),
                    onChanged: (v) => setState(() => _gender = v ?? "P"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Hobi - Checkbox
            const Text("Hobi", style: TextStyle(fontWeight: FontWeight.bold)),
            ..._hobbyMap.keys.map((h) {
              return CheckboxListTile(
                value: _hobbyMap[h],
                title: Text(h),
                onChanged: (val) => setState(() => _hobbyMap[h] = val ?? false),
              );
            }),
            const SizedBox(height: 8),
            // Rating - Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Rating (1–5)"),
                Text(_rating.toStringAsFixed(1)),
              ],
            ),
            Slider(
              min: 1,
              max: 5,
              divisions: 8,
              value: _rating,
              onChanged: (v) => setState(() => _rating = v),
            ),
            const SizedBox(height: 8),
            // Comment
            TextFormField(
              controller: _commentCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Komentar",
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 8),
            // Agreement - Switch
            SwitchListTile(
              value: _agree,
              title: const Text("Setuju syarat & ketentuan"),
              onChanged: (v) => setState(() => _agree = v),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.save),
              onPressed: _submit,
              label: const Text("Simpan & Kembalikan ke Home"),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===============================================
/// DETAIL PAGE: tampilkan isi FeedbackItem
/// ===============================================
class DetailPage extends StatelessWidget {
  final FeedbackItem item;
  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Feedback")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Nama"),
            subtitle: Text(item.name),
          ),
          ListTile(
            leading: const Icon(Icons.transgender),
            title: const Text("Jenis Kelamin"),
            subtitle: Text(item.gender == "L" ? "Laki-laki" : "Perempuan"),
          ),
          ListTile(
            leading: const Icon(Icons.star_rate),
            title: const Text("Rating"),
            subtitle: Text(item.rating.toStringAsFixed(1)),
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text("Hobi"),
            subtitle: Text(item.hobbies.isEmpty ? "-" : item.hobbies.join(", ")),
          ),
          ListTile(
            leading: const Icon(Icons.chat_bubble_outline),
            title: const Text("Komentar"),
            subtitle: Text(item.comment.isEmpty ? "-" : item.comment),
          ),
          const SizedBox(height: 16),
          Center(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text("Kembali"),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }
}
