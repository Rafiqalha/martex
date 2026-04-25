import 'package:flutter/material.dart';
import '../../core/local_db.dart';
import '../../core/api_client.dart';
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

  Widget _buildPremiumInput(String label, String hint, TextEditingController controller, IconData icon, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: theme.colorScheme.primary),
        ),
      ),
    );
  }

  Widget _genderBtn(String label, String value, IconData icon, ThemeData theme) {
    bool active = _selectedGender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: active ? theme.colorScheme.primary : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: active ? Colors.transparent : theme.colorScheme.outlineVariant, 
              width: 2
            ),
            boxShadow: active 
                ? [BoxShadow(color: theme.colorScheme.primary.withAlpha(80), blurRadius: 15, offset: const Offset(0, 8))] 
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: active ? Colors.white : theme.colorScheme.onSurfaceVariant, size: 28),
              const SizedBox(width: 10),
              Text(
                label, 
                style: TextStyle(
                  color: active ? Colors.white : theme.colorScheme.onSurfaceVariant, 
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
        const SnackBar(
          content: Text("Bunda, mohon lengkapi semua data pertumbuhan si kecil ya!"),
          backgroundColor: Color(0xFFEF4444),
        )
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      double w = double.parse(_weightController.text);
      double h = double.parse(_heightController.text);
      
      // Calculate BMI (Z-Score approximation for now)
      // Standard WHO Z-score calculation is more complex and requires tables
      double heightInMeters = h / 100;
      double bmi = w / (heightInMeters * heightInMeters);
      // Rough approximation for Z-score (-2 to 2 is roughly normal)
      double z = (bmi - 16) / 2.0; 
      
      final m = Measurement(
        age: int.parse(_ageController.text),
        weight: w,
        height: h,
        gender: _selectedGender,
        lat: -7.9839, // Dummy coordinates
        lng: 112.6214, 
        zScore: z,
      );

      await LocalDatabase.instance.insertMeasurement(m);
      
      // Try to sync immediately
      bool syncSuccess = await ApiClient.syncData();
      
      if (mounted) {
        final String message = syncSuccess 
            ? "Tersimpan & tersinkronisasi ke cloud ✓✓" 
            : "Tersimpan lokal ✓ (Akan disinkronisasi saat online)";
            
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: syncSuccess ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
            behavior: SnackBarBehavior.floating,
          )
        );
        
        _ageController.clear();
        _weightController.clear();
        _heightController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Terjadi kesalahan: $e"),
            backgroundColor: const Color(0xFFEF4444),
          )
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 70, left: 25, right: 25, bottom: 40),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border(
                  bottom: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Jurnal Pertumbuhan", 
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    )
                  ),
                  const SizedBox(height: 5),
                  Text("Pantau parameter fisik si kecil bulan ini", 
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Profil Biologis", 
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    )
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _genderBtn("Laki-laki", "L", Icons.boy_rounded, theme),
                      const SizedBox(width: 15),
                      _genderBtn("Perempuan", "P", Icons.girl_rounded, theme),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Text("Metrik Fisik", 
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    )
                  ),
                  const SizedBox(height: 15),
                  _buildPremiumInput("Usia Bayi", "Misal: 24 (Bulan)", _ageController, Icons.cake_rounded, theme),
                  _buildPremiumInput("Berat Badan", "Misal: 12.5 (Kg)", _weightController, Icons.monitor_weight_rounded, theme),
                  _buildPremiumInput("Tinggi Badan", "Misal: 85.0 (Cm)", _heightController, Icons.height_rounded, theme),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 65,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _handleSave,
                      child: _isSaving 
                          ? const CircularProgressIndicator(color: Colors.white) 
                          : const Text("Simpan ke Buku KIA", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
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