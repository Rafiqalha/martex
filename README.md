# TumbuhSehat: Infrastruktur Data Gizi Nasional

TumbuhSehat adalah **Dual-Layer Platform** (B2G SaaS) yang mengubah cara pemerintah dan masyarakat mendeteksi serta menangani stunting. Kami menggabungkan aplikasi *mobile offline-first* bergaya gamifikasi untuk orang tua/kader, dengan arsitektur *backend* terpusat untuk visualisasi *heatmap* spasial bagi pengambil kebijakan.

## Fitur yang Telah Dibangun (Checkpoint 4 - MVP)
Aplikasi *mobile* (Layer 1) sudah fungsional dan siap didemonstrasikan:
1. **Offline-First Z-Score Engine:** Kalkulasi status gizi standar WHO (Usia, Berat, Tinggi, Gender) yang berjalan 100% tanpa internet menggunakan SQLite.
2. **Flat 3D Gamification UI:** Sistem "Rapor Tumbuh" interaktif yang memvisualisasikan kondisi anak dalam bentuk "Pohon Sehat" dan koleksi lencana (Badges) untuk meningkatkan retensi pengguna.
3. **Smart Nutrition Tracker:** Mesin rekomendasi diet cerdas berbasis *rule-based heuristic* yang memberikan target nutrisi harian murah meriah (Telur, Ati Ayam) beserta sistem *Streak* (runtutan hari) untuk manipulasi psikologis pembentukan kebiasaan sehat.
4. **Floating Modular Navigation:** Arsitektur *IndexedStack* dan *Floating Bottom Navbar* untuk manajemen memori yang sangat efisien (0ms *loading time* antar tab).
5. **Batch Sync Pipeline:** Jembatan API yang siap menembakkan antrean data lokal ke *cloud* secara masal saat perangkat kembali *online*.

## Fitur yang Akan Dikembangkan (Roadmap Skalabilitas)
1. **Web Dashboard Intelligence (Layer 2):** Pusat komando (*Command Center*) berbasis Next.js untuk Kemenkes/BGN yang menampilkan *Heatmap Spasial Real-Time* titik rawan stunting.
2. **IoT Smart Scale Integration:** Koneksi Bluetooth otomatis antara aplikasi dan timbangan/meteran digital di Posyandu untuk menghilangkan *human error*.
3. **AI Food Scanner:** Model *Computer Vision* yang dapat mendeteksi estimasi kalori dan protein hewani hanya dengan memotret piring MPASI anak.

## Tech Stack & Arsitektur Sistem
Sistem ini dibangun dengan arsitektur *Enterprise-grade* yang memisahkan *frontend*, *backend*, dan *database*:
* **Mobile Frontend:** Flutter & Dart (State Preservation via IndexedStack).
* **Local Storage:** SQLite (LocalDatabase pattern).
* **Backend API:** Python & FastAPI (Batch Processing Architecture).
* **Cloud Database:** PostgreSQL via Supabase.
* **ORM:** SQLAlchemy (Siap untuk ekstensi PostGIS di masa depan).
* **UI/UX Style:** Flat 3D / Claymorphism & Dark Neo.