import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class KontakBantuanPage extends StatelessWidget {
  const KontakBantuanPage({super.key});

  // ✅ Fungsi untuk membuka tautan (WA, email, IG, dsb)
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        debugPrint('Gagal membuka tautan: $url');
      }
    } catch (e) {
      debugPrint('Terjadi kesalahan saat membuka tautan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(
          'Kontak & Bantuan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.support_agent_rounded,
                    size: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Butuh Bantuan?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hubungi kami melalui kontak berikut jika mengalami kendala.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 🔹 WhatsApp
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                    color: Colors.white.withOpacity(0.95),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.chat, color: Colors.white),
                      ),
                      title: const Text(
                        'WhatsApp Admin',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('+62 895-6067-21625'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        await _launchUrl('https://wa.me/qr/ZBW5GVYVCZMXE1');
                      },
                    ),
                  ),

                  // 🔹 Email
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                    color: Colors.white.withOpacity(0.95),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        child: Icon(Icons.email, color: Colors.white),
                      ),
                      title: const Text(
                        'Email Resmi Kampus',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('mail@uinjambi.ac.id'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        await _launchUrl('https://uinjambi.ac.id/');
                      },
                    ),
                  ),

                  // 🔹 Instagram
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                    color: Colors.white.withOpacity(0.95),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.purpleAccent,
                        child: Icon(Icons.camera_alt, color: Colors.white),
                      ),
                      title: const Text(
                        'Instagram Kampus',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('@uinjambi.ac.id'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        await _launchUrl(
                          'https://www.instagram.com/uinjambi.ac.id?igsh=eHJ3azBzYTh0MGp4',
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
