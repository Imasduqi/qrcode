## Nama File

**`SPEC.md`**

Singkat, jelas, dan konvensional — AI langsung paham ini adalah dokumen spesifikasi utama.

---

## Isi SPEC.md

---

# QRKit — Spesifikasi Aplikasi

## Identitas Proyek
- **Nama Aplikasi:** QRKit
- **Mata Kuliah:** Teknologi Mobile
- **Nama Mahasiswa:** Imam Faqih Masduqi
- **Kelas:** A

---

## Deskripsi Singkat
Aplikasi Flutter yang memiliki dua fitur utama: generate QR Code dari teks input dan scan QR Code menggunakan kamera perangkat. Navigasi antar fitur menggunakan BottomNavigationBar.

---

## Tech Stack
- **Framework:** Flutter
- **Bahasa:** Dart
- **Package Generate:** qr_flutter
- **Package Scan:** mobile_scanner

---

## Struktur File
```
lib/
├── main.dart
├── splash_screen.dart
├── home_screen.dart
├── generate_qr.dart
└── scan_qr.dart
```

---

## Alur Navigasi
```
App Launch
    ↓
SplashScreen (2 detik, auto-navigate)
    ↓
HomeScreen (BottomNavigationBar)
    ├── Tab 1: GenerateQRPage
    └── Tab 2: ScanQRPage
```

---

## Detail Setiap Screen

### 1. SplashScreen (`splash_screen.dart`)
- Tampil otomatis saat app dibuka
- Durasi 2 detik lalu auto-navigate ke HomeScreen
- Konten:
  - Ikon QR besar di tengah
  - Nama app: QRKit
  - Nama: Imam Faqih Masduqi
  - Kelas: A
  - Mata Kuliah: Teknologi Mobile

### 2. HomeScreen (`home_screen.dart`)
- Wrapper BottomNavigationBar
- Tab 1: ikon qr_code, label "Generate"
- Tab 2: ikon qr_code_scanner, label "Scan"

### 3. GenerateQRPage (`generate_qr.dart`)
- AppBar judul: "Generate QR Code"
- Subjudul: "Masukkan teks untuk diubah menjadi QR"
- TextField untuk input teks bebas
- Tombol "Generate"
- Kotak output: menampilkan widget QR Code setelah tombol ditekan
- Teks kecil di bawah QR: menampilkan ulang teks yang di-encode
- Sebelum generate: kotak output kosong dengan placeholder

### 4. ScanQRPage (`scan_qr.dart`)
- AppBar judul: "Scan QR Code"
- Subjudul: "Arahkan kamera ke QR Code"
- Preview kamera menggunakan MobileScanner widget
- Overlay kotak scan di tengah area kamera (garis sudut empat penjuru)
- Card hasil di bawah kamera
  - Default: "Belum ada hasil scan"
  - Setelah QR terdeteksi: tampilkan teks hasil scan

---

## Tema Visual
- **Background:** putih (#FFFFFF) atau abu sangat muda (#F5F5F5)
- **Warna Primer:** Indigo (#1A237E)
- **Tombol & Aksen:** warna primer
- **Card hasil scan:** background abu muda (#EEEEEE)
- **Font:** default Flutter (Roboto)

---

## Catatan Penting untuk AI
- Seluruh kode dalam satu project Flutter standar
- Tidak ada backend, tidak ada autentikasi, tidak ada database
- Permission kamera harus ditangani untuk fitur scan (android & iOS)
- Gunakan StatefulWidget untuk GenerateQRPage dan ScanQRPage
- Pastikan package sudah ditambahkan di pubspec.yaml sebelum digunakan

---

