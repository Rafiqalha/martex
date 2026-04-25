import 'package:flutter/material.dart';
import '../../core/local_db.dart';
import '../../models/measurement.dart';

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
  bool _isSaving = false;

  Widget _buildPremiumInput(String label, String hint, TextEditingController controller, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 15, offset: const Offset(0, 5)),
        ],
        border: Border.all(color: const Color(0xFF10B981).withAlpha(30), width: 2),
      ),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF0F172A), fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold),
          hintStyle: TextStyle(color: Colors.grey.withAlpha(150)),
          prefixIcon: Icon(icon, color: const Color(0xFF10B981)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _genderBtn(String label, String value, IconData icon) {
    bool active = _selectedGender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: active 
                ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)])
                : const LinearGradient(colors: [Colors.white, Colors.white]),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: active ? Colors.transparent : const Color(0xFFE2E8F0), width: 2),
            boxShadow: active 
                ? [BoxShadow(color: const Color(0xFF10B981).withAlpha(80), blurRadius: 15, offset: const Offset(0, 8))] 
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: active ? Colors.white : Colors.grey, size: 28),
              const SizedBox(width: 10),
              Text(
                label, 
                style: TextStyle(
                  color: active ? Colors.white : Colors.grey, 
                  fontWeight: FontWeight.w900,
                  fontSize: 15
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (_ageController.text.isEmpty || _weightController.text.isEmpty || _heightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bunda, mohon lengkapi semua data pertumbuhan si kecil ya!"))
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      double w = double.parse(_weightController.text);
      double h = double.parse(_heightController.text);
      double z = (w / h) - 0.5;
      
      final m = Measurement(
        age: int.parse(_ageController.text),
        weight: w,
        height: h,
        gender: _selectedGender,
        lat: -7.9839, 
        lng: 112.6214, 
        zScore: z,
      );

      await LocalDatabase.instance.insertMeasurement(m);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Hebat! Jurnal pertumbuhan si kecil berhasil dicatat."),
            backgroundColor: Color(0xFF065F46),
            behavior: SnackBarBehavior.floating,
          )
        );
        
        _ageController.clear();
        _weightController.clear();
        _heightController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Terjadi kesalahan: $e")));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 70, left: 25, right: 25, bottom: 40),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF065F46), Color(0xFF10B981), Color(0xFF34D399)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withAlpha(80),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Jurnal Pertumbuhan", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                  SizedBox(height: 5),
                  Text("Pantau parameter fisik si kecil bulan ini", style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Profil Biologis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _genderBtn("Laki-laki", "L", Icons.boy_rounded),
                      const SizedBox(width: 15),
                      _genderBtn("Perempuan", "P", Icons.girl_rounded),
                    ],
                  ),
                  const SizedBox(height: 35),
                  const Text("Metrik Fisik", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                  const SizedBox(height: 15),
                  _buildPremiumInput("Usia Bayi", "Misal: 24 (Bulan)", _ageController, Icons.cake_rounded),
                  _buildPremiumInput("Berat Badan", "Misal: 12.5 (Kg)", _weightController, Icons.monitor_weight_rounded),
                  _buildPremiumInput("Tinggi Badan", "Misal: 85.0 (Cm)", _heightController, Icons.height_rounded),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 65,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        elevation: 10,
                        shadowColor: const Color(0xFF0F172A).withAlpha(60),
                      ),
                      onPressed: _isSaving ? null : _handleSave,
                      child: _isSaving 
                          ? const CircularProgressIndicator(color: Color(0xFF10B981)) 
                          : const Text("Simpan ke Buku KIA", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}