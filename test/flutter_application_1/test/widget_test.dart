// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  // Ganti nama test agar sesuai dengan fungsionalitas aplikasi
  testWidgets('Menampilkan Biodata Nama dan NIM dengan benar', (WidgetTester tester) async {
    
    // 1. Build aplikasi Biodata Anda (MyApp akan memanggil BiodataScreen)
    await tester.pumpWidget(const BiodataApp()); // Ganti MyApp() menjadi BiodataApp()

    // 2. Verifikasi komponen utama, misalnya judul AppBar
    expect(find.text('Biodata Diri'), findsOneWidget); 
    
    // 3. Verifikasi Nama ditampilkan
    // Pastikan teks Nama sesuai dengan yang ada di BiodataScreen Anda
    expect(find.text('M. Farhan Ramadhan'), findsOneWidget); 
    
    // 4. Verifikasi NIM ditampilkan
    // Pastikan teks NIM sesuai dengan yang ada di BiodataScreen Anda
    expect(find.text('701230049'), findsOneWidget);
    
    // 5. Verifikasi Hobi ditampilkan
    expect(find.text('Bermain Layangan'), findsOneWidget);

    // 6. Verifikasi bahwa elemen dari aplikasi counter lama sudah hilang
    // Ini adalah langkah opsional untuk memastikan kode counter lama tidak tersisa.
    expect(find.byIcon(Icons.add), findsNothing);
    expect(find.text('0'), findsNothing);
  });
}