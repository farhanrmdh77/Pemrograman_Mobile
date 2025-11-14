import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(const FeedbackApp());

class FeedbackApp extends StatelessWidget {
  const FeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback Pengguna',
      debugShowCheckedModeBanner: false,
      home: const FeedbackPage(),
    );
  }
}

/// =============================
/// DATA MODEL FEEDBACK
/// =============================
class FeedbackData {
  final String nama;
  final String gender;
  final String hobi;
  final double rating;
  final String komentar;

  FeedbackData({
    required this.nama,
    required this.gender,
    required this.hobi,
    required this.rating,
    required this.komentar,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'gender': gender,
      'hobi': hobi,
      'rating': rating,
      'komentar': komentar,
    };
  }

  factory FeedbackData.fromMap(Map<String, dynamic> map) {
    return FeedbackData(
      nama: map['nama'],
      gender: map['gender'],
      hobi: map['hobi'],
      rating: map['rating'],
      komentar: map['komentar'],
    );
  }
}

/// =============================
/// HALAMAN UTAMA FEEDBACK
/// =============================
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  List<FeedbackData> _feedbackList = [];

  @override
  void initState() {
    super.initState();
    _loadFeedback();
  }

  Future<void> _loadFeedback() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getStringList('feedbackList') ?? [];
    setState(() {
      _feedbackList = savedData
          .map((e) => FeedbackData.fromMap(jsonDecode(e)))
          .toList();
    });
  }

  Future<void> _saveFeedback() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _feedbackList.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList('feedbackList', data);
  }

  void _openFormDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const FeedbackFormDialog(),
    ).then((result) {
      if (result != null && result is FeedbackData) {
        setState(() {
          _feedbackList.insert(0, result);
        });
        _saveFeedback();
      }
    });
  }

  void _deleteFeedback(FeedbackData feedback) {
    setState(() {
      _feedbackList.remove(feedback);
    });
    _saveFeedback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Kritik & Saran Pengguna',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // 👉 panah kembali jadi putih
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 110, 16, 16),
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: _openFormDialog,
                icon: const Icon(Icons.add_comment_rounded),
                label: const Text("Tambah Feedback"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blueAccent,
                  elevation: 5,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _feedbackList.isEmpty
                    ? const Center(
                        child: Text(
                          "Belum ada feedback.",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _feedbackList.length,
                        itemBuilder: (context, index) {
                          final fb = _feedbackList[index];
                          return Hero(
                            tag: fb.nama,
                            child: Card(
                              color: Colors.white.withOpacity(0.95),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 5,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 26,
                                  backgroundColor: Colors.blueAccent,
                                  child: Text(
                                    fb.nama[0].toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 22),
                                  ),
                                ),
                                title: Text(
                                  fb.nama,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Text(
                                  "${fb.gender} • ⭐ ${fb.rating.toStringAsFixed(1)} • ${fb.hobi.isNotEmpty ? fb.hobi : 'Tidak ada hobi'}",
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FeedbackDetailPage(
                                        data: fb,
                                        onDelete: () => _deleteFeedback(fb),
                                      ),
                                    ),
                                  );
                                },
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

/// =============================
/// FORM TAMBAH FEEDBACK
/// =============================
class FeedbackFormDialog extends StatefulWidget {
  const FeedbackFormDialog({super.key});

  @override
  State<FeedbackFormDialog> createState() => _FeedbackFormDialogState();
}

class _FeedbackFormDialogState extends State<FeedbackFormDialog> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hobiController = TextEditingController();
  final TextEditingController _komentarController = TextEditingController();
  double _rating = 3.0;
  String _gender = 'Laki-laki';

  void _submit() {
    if (_namaController.text.trim().isEmpty ||
        _komentarController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Nama dan komentar wajib diisi!")));
      return;
    }
    Navigator.pop(
      context,
      FeedbackData(
        nama: _namaController.text,
        gender: _gender,
        hobi: _hobiController.text,
        rating: _rating,
        komentar: _komentarController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.blueAccent, Color(0xFF6dd5ed)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Tambah Feedback",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              const SizedBox(height: 16),
              _buildField("Nama", _namaController),
              const SizedBox(height: 12),
              _buildGenderSelector(),
              const SizedBox(height: 12),
              _buildField("Hobi (opsional)", _hobiController),
              const SizedBox(height: 16),
              _buildRatingSlider(),
              _buildField("Komentar", _komentarController, maxLines: 5),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Batal"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Kirim"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String hint, TextEditingController c,
      {int maxLines = 1}) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _gender,
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: 'Laki-laki', child: Text("Laki-laki")),
            DropdownMenuItem(value: 'Perempuan', child: Text("Perempuan")),
          ],
          onChanged: (value) => setState(() => _gender = value!),
        ),
      ),
    );
  }

  Widget _buildRatingSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Rating:",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Slider(
          value: _rating,
          min: 1,
          max: 5,
          divisions: 4,
          activeColor: Colors.yellowAccent,
          inactiveColor: Colors.white38,
          onChanged: (v) => setState(() => _rating = v),
        ),
      ],
    );
  }
}

/// =============================
/// DETAIL FEEDBACK
/// =============================
class FeedbackDetailPage extends StatelessWidget {
  final FeedbackData data;
  final VoidCallback onDelete;

  const FeedbackDetailPage({
    super.key,
    required this.data,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Detail Feedback",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // 👉 panah kembali jadi putih
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          // 🔥 Tombol Delete di kanan atas
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              tooltip: 'Hapus Feedback',
              onPressed: () {
                // Konfirmasi sebelum hapus
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text("Hapus Feedback"),
                    content: const Text(
                        "Apakah kamu yakin ingin menghapus feedback ini?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Batal"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          onDelete();
                          Navigator.pop(context); // Tutup dialog
                          Navigator.pop(context); // Kembali ke halaman utama
                        },
                        child: const Text("Hapus"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Color(0xFF6dd5ed)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Hero(
            tag: data.nama,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.97),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        data.nama[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      data.nama,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${data.gender} • ⭐ ${data.rating.toStringAsFixed(1)} / 5.0",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _infoTile(Icons.favorite, "Hobi",
                        data.hobi.isNotEmpty ? data.hobi : "-"),
                    const SizedBox(height: 14),
                    _infoTile(Icons.comment, "Komentar", data.komentar),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
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
