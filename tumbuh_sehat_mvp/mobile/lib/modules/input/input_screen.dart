import 'package:flutter/material.dart';
import '../core/local_db.dart';
import '../models/measurement.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String _selectedGender = 'L';
  Map<String, dynamic>? _selectedLocation;
  bool _isSaving = false;

  // Data statis lokasi untuk membypass GPS (titik koordinat ini akan menyalakan Heatmap Web)
  final List<Map<String, dynamic>> _locations = [
    {"name": "DKI Jakarta", "lat": -6.2088, "lng": 106.8456},
    {"name": "Jawa Barat", "lat": -6.9147, "lng": 107.6098},
    {"name": "Jawa Tengah", "lat": -7.1509, "lng": 110.1402},
    {"name": "Jawa Timur", "lat": -7.2504, "lng": 112.7688},
    {"name": "Nusa Tenggara Timur (NTT)", "lat": -8.6500, "lng": 121.0833},
    {"name": "Papua", "lat": -4.2699, "lng": 138.0803},
  ];

  Widget _build3DInput(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 1, offset: const Offset(0, 4)),
              const BoxShadow(color: Colors.white, blurRadius: 0, offset: Offset(0, -2)),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF10B981)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _build3DDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Lokasi Posyandu (Manual)", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 1, offset: const Offset(0, 4)),
              const BoxShadow(color: Colors.white, blurRadius: 0, offset: Offset(0, -2)),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Map<String, dynamic>>(
              isExpanded: true,
              hint: const Text("Pilih Provinsi", style: TextStyle(color: Colors.grey)),
              value: _selectedLocation,
              icon: const Icon(Icons.location_on_rounded, color: Color(0xFF10B981)),
              items: _locations.map((Map<String, dynamic> loc) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: loc,
                  child: Text(loc["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedLocation = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _genderBtn(String label, String value, IconData icon) {
    bool active = _selectedGender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF10B981) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: active ? Colors.transparent : const Color(0xFFE2E8F0), width: 2),
            boxShadow: active ? [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: active ? Colors.white : Colors.grey),
              const SizedBox(width: 10),
              Text(label, style: TextStyle(color: active ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (_ageController.text.isEmpty || _weightController.text.isEmpty || _heightController.text.isEmpty || _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mohon lengkapi semua data dan lokasi!")));
      return;
    }

    setState(() => _isSaving = true);
    try {
      double z = (double.parse(_weightController.text) / double.parse(_heightController.text)) - 0.5;
      
      final m = Measurement(
        age: int.parse(_ageController.text),
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        gender: _selectedGender,
        lat: _selectedLocation!['lat'], // Ambil koordinat dari dropdown
        lng: _selectedLocation!['lng'], // Ambil koordinat dari dropdown
        zScore: z,
      );

      await LocalDatabase.instance.insertMeasurement(m);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Terjadi kesalahan sistem: $e")));
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Input Data", style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Row(
              children: [
                _genderBtn("Laki-laki", "L", Icons.male_rounded),
                const SizedBox(width: 15),
                _genderBtn("Perempuan", "P", Icons.female_rounded),
              ],
            ),
            const SizedBox(height: 30),
            _build3DInput("Usia (Bulan)", _ageController, Icons.calendar_today_rounded),
            const SizedBox(height: 20),
            _build3DInput("Berat (kg)", _weightController, Icons.monitor_weight_rounded),
            const SizedBox(height: 20),
            _build3DInput("Tinggi (cm)", _heightController, Icons.height_rounded),
            const SizedBox(height: 20),
            _build3DDropdown(), // Dropdown Lokasi Manual
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 65,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                  shadowColor: const Color(0xFF0F172A).withOpacity(0.5),
                ),
                onPressed: _isSaving ? null : _handleSave,
                child: _isSaving 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text("Simpan Data", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}