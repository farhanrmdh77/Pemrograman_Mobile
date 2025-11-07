import 'package:flutter/material.dart';
import 'dart:ui';

void main() => runApp(const MyApp());

/// ======================================================
/// ROOT APP
/// ======================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Feedback Modern',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

/// ======================================================
/// MODEL DATA
/// ======================================================
class FeedbackItem {
  final String name;
  final String gender;
  final double rating;
  final bool isAgree;
  final List<String> hobbies;
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

/// ======================================================
/// HOME PAGE (daftar feedback + navigasi)
/// ======================================================
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
        const SnackBar(content: Text('Feedback berhasil ditambahkan!')),
      );
    }
  }

  void _openDetail(FeedbackItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(item: item)),
    );
  }

  void _openCounter() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CounterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Feedback Pengguna",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Colors.white,
            shadows: [
              Shadow(color: Colors.black45, blurRadius: 8, offset: Offset(1, 1))
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black.withOpacity(0.3),
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.25)),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D0D0D), Color(0xFF1B1F33), Color(0xFF2E2A59)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _openForm,
                        icon: const Icon(Icons.add_comment, color: Colors.white),
                        label: const Text(
                          "Tambah Feedback",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _openCounter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      child: const Icon(Icons.exposure_plus_1, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _items.isEmpty
                    ? const Center(
                        child: Text(
                          "Belum ada feedback.\nTambahkan melalui tombol di atas.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _items.length,
                        itemBuilder: (context, i) {
                          final it = _items[i];
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.2)),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.deepPurpleAccent,
                                child: Text(
                                  it.name.isNotEmpty
                                      ? it.name[0].toUpperCase()
                                      : "?",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                it.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              subtitle: Text(
                                "Rating: ${it.rating.toStringAsFixed(1)} • "
                                "Hobi: ${it.hobbies.join(', ')}",
                                style: const TextStyle(color: Colors.white70),
                              ),
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: Colors.white60,
                              ),
                              onTap: () => _openDetail(it),
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

/// ======================================================
/// FORM PAGE (REVISI)
/// ======================================================
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

  final Map<String, bool> _hobbyMap = {
    "Coding": false,
    "Membaca": false,
    "Olahraga": false,
    "Memancing": false,
    "Bermain Game": false,
    "Mukbang": false,
  };

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final hobbies =
        _hobbyMap.entries.where((e) => e.value).map((e) => e.key).toList();
    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Centang setuju sebelum menyimpan.")));
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
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Form Feedback",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(color: Colors.black45, blurRadius: 8, offset: Offset(1, 1))
            ],
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.25),
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0A), Color(0xFF1B1B33)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildTextField("Nama", _nameCtrl, Icons.person),
                  const SizedBox(height: 16),
                  _buildGender(),
                  const SizedBox(height: 16),
                  _buildCheckboxes(),
                  const SizedBox(height: 16),
                  _buildSlider(),
                  const SizedBox(height: 16),
                  _buildComment(),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text(
                      "Setuju syarat & ketentuan",
                      style: TextStyle(color: Colors.white),
                    ),
                    value: _agree,
                    onChanged: (v) => setState(() => _agree = v),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.save),
                    label: const Text("Simpan Feedback"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController c, IconData icon) {
    return TextFormField(
      controller: c,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white30),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.deepPurpleAccent),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
    );
  }

  Widget _buildGender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Jenis Kelamin",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                value: "L",
                groupValue: _gender,
                title: const Text("Laki-laki",
                    style: TextStyle(color: Colors.white70)),
                onChanged: (v) => setState(() => _gender = v ?? "L"),
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                value: "P",
                groupValue: _gender,
                title: const Text("Perempuan",
                    style: TextStyle(color: Colors.white70)),
                onChanged: (v) => setState(() => _gender = v ?? "P"),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildCheckboxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Hobi",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
        ..._hobbyMap.keys.map((h) {
          return CheckboxListTile(
            value: _hobbyMap[h],
            title: Text(h, style: const TextStyle(color: Colors.white70)),
            onChanged: (val) => setState(() => _hobbyMap[h] = val ?? false),
          );
        }),
      ],
    );
  }

  Widget _buildSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Rating (1–5)",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Slider(
          value: _rating,
          min: 1,
          max: 5,
          divisions: 8,
          label: _rating.toStringAsFixed(1),
          onChanged: (v) => setState(() => _rating = v),
        ),
      ],
    );
  }

  Widget _buildComment() {
    return TextFormField(
      controller: _commentCtrl,
      maxLines: 3,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: "Komentar",
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

/// ======================================================
/// DETAIL PAGE
/// ======================================================
class DetailPage extends StatelessWidget {
  final FeedbackItem item;

  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Detail Feedback",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black54,
                blurRadius: 8,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0.25),
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0A), Color(0xFF1B1B33)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea( // 💡 Pastikan isi tidak tertutup header
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Tambah jarak biar nama tidak nempel header
                const SizedBox(height: 8),

                // Nama User
                Center(
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 10,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                _buildInfoCard(
                  icon: Icons.male_rounded,
                  title: "Jenis Kelamin",
                  content: item.gender == 'L' ? "Laki-laki" : "Perempuan",
                  iconColor: Colors.purpleAccent,
                ),
                const SizedBox(height: 12),

                _buildInfoCard(
                  icon: Icons.star_rounded,
                  title: "Rating",
                  content: item.rating.toStringAsFixed(1),
                  iconColor: Colors.amberAccent,
                ),
                const SizedBox(height: 12),

                _buildInfoCard(
                  icon: Icons.palette_rounded,
                  title: "Hobi",
                  content: item.hobbies.isNotEmpty
                      ? item.hobbies.join(", ")
                      : "Tidak ada",
                  iconColor: Colors.purpleAccent,
                ),
                const SizedBox(height: 12),

                _buildInfoCard(
                  icon: Icons.comment_rounded,
                  title: "Komentar",
                  content: item.comment.isNotEmpty
                      ? item.comment
                      : "Tidak ada komentar",
                  iconColor: Colors.deepPurpleAccent,
                ),

                const SizedBox(height: 30),

                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text(
                      "Kembali",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget kartu info
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


/// ======================================================
/// COUNTER PAGE
/// ======================================================
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;
  void _inc() => setState(() => _count++);
  void _dec() => setState(() => _count--);
  void _reset() => setState(() => _count = 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Counter Demo",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(color: Colors.black45, blurRadius: 8)],
            )),
        backgroundColor: Colors.black.withOpacity(0.25),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0A), Color(0xFF1F1F3C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            "$_count",
            style: const TextStyle(
              fontSize: 70,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(color: Colors.deepPurpleAccent, blurRadius: 20),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
              onPressed: _dec, child: const Icon(Icons.remove)),
          const SizedBox(width: 12),
          FloatingActionButton(
              onPressed: _inc, child: const Icon(Icons.add)),
          const SizedBox(width: 12),
          FloatingActionButton.small(
              onPressed: _reset, child: const Icon(Icons.refresh)),
        ],
      ),
    );
  }
}
