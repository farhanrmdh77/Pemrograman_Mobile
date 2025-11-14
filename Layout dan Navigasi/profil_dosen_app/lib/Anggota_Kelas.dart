import 'package:flutter/material.dart';

class AnggotaKelasPage extends StatelessWidget {
  const AnggotaKelasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> anggota = [
      {'nim': '701230011', 'nama': "ACHMAD REZA DZURRYATUL ASY'ARI", 'foto': 'assets/anggota/achmad.jpg'},
      {'nim': '701230013', 'nama': "DAVID ARDI NUGRAHA", 'foto': 'assets/anggota/david.jpg'},
      {'nim': '701230014', 'nama': "ABDUL AZIZ ATOI\'IB", 'foto': 'assets/anggota/abdul.jpg'},
      {'nim': '701230015', 'nama': "DEWI RAHAYU", 'foto': 'assets/anggota/dewi.jpg'},
      {'nim': '701230016', 'nama': "M.RENO NOVRIANSYAH", 'foto': 'assets/anggota/reno.jpg'},
      {'nim': '701230017', 'nama': "NOVIANA SAFITRI", 'foto': 'assets/anggota/noviana.jpg'},
      {'nim': '701230018', 'nama': "EKA SAPUTRA", 'foto': 'assets/anggota/eka.jpg'},
      {'nim': '701230019', 'nama': "DIAN AGUS SAPUTRA", 'foto': 'assets/anggota/dian.jpg'},
      {'nim': '701230020', 'nama': "ADI SAPUTRA", 'foto': 'assets/anggota/adi.jpg'},
      {'nim': '701230041', 'nama': "NAILA ZUHROTUL HAPSARI", 'foto': 'assets/anggota/naila.jpg'},
      {'nim': '701230042', 'nama': "CERRY NOVIYANTI", 'foto': 'assets/anggota/cerry.jpg'},
      {'nim': '701230043', 'nama': "NANDA SEPTA LIAN SARI", 'foto': 'assets/anggota/nanda.jpg'},
      {'nim': '701230045', 'nama': "DAFFA ALFAREZA", 'foto': 'assets/anggota/daffa.jpg'},
      {'nim': '701230046', 'nama': "M.IQBAL", 'foto': 'assets/anggota/iqbal.jpg'},
      {'nim': '701230047', 'nama': "DESY IKA HARIYANI", 'foto': 'assets/anggota/desy.jpg'},
      {'nim': '701230048', 'nama': "RAYHAN SYAWAL", 'foto': 'assets/anggota/rayhan.jpg'},
      {'nim': '701230049', 'nama': "M.FARHAN RAMADHAN", 'foto': 'assets/anggota/farhan.jpg'},
      {'nim': '701230050', 'nama': "NOVA WIJAYA", 'foto': 'assets/anggota/nova.jpg'},
      {'nim': '701230071', 'nama': "RIFQI ZIYAD FULVIAN", 'foto': 'assets/anggota/rifqi.jpg'},
      {'nim': '701230072', 'nama': "AHMAD AZQI YAUCI", 'foto': 'assets/anggota/azqi.jpg'},
      {'nim': '701230073', 'nama': "ADITYA RAHMATTULLAH", 'foto': 'assets/anggota/aditya.jpg'},
      {'nim': '701230074', 'nama': "INTAN RHAMADANI", 'foto': 'assets/anggota/intan.jpg'},
      {'nim': '701230075', 'nama': "SOLI AMALIA RAHMADHANI", 'foto': 'assets/anggota/soli.jpg'},
      {'nim': '701230076', 'nama': "ONE AZIZAH", 'foto': 'assets/anggota/one.jpg'},
      {'nim': '701230078', 'nama': "MUHAMMAD DENDI SAPUTRA", 'foto': 'assets/anggota/dendi.jpg'},
      {'nim': '701230079', 'nama': "MUHAMMAD FARHAN CHABLULLAH", 'foto': 'assets/anggota/farchab.jpg'},
      {'nim': '701220274', 'nama': "NAZARUDDIN", 'foto': 'assets/anggota/nazar.jpg'},
      {'nim': '701230045', 'nama': "SHOLIKUL HADI", 'foto': 'assets/anggota/sholik.jpg'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Anggota Kelas 5B Sistem Informasi',
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
          itemCount: anggota.length,
          itemBuilder: (context, index) {
            final data = anggota[index];
            return Card(
              color: Colors.white.withOpacity(0.9),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    data['foto'] ?? 'assets/default_avatar.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Kalau foto tidak ditemukan, tampilkan lingkaran default
                      return const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.purpleAccent,
                        child: Icon(Icons.person, color: Colors.white),
                      );
                    },
                  ),
                ),
                title: Text(
                  data['nama']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  'NIM: ${data['nim']}',
                  style: const TextStyle(color: Colors.black54),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            );
          },
        ),
      ),
    );
  }
}
