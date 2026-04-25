import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../core/local_db.dart';
import '../../models/measurement.dart';

class NutritionRecommendationScreen extends StatefulWidget {
  const NutritionRecommendationScreen({super.key});

  @override
  State<NutritionRecommendationScreen> createState() => _NutritionRecommendationScreenState();
}

class _NutritionRecommendationScreenState extends State<NutritionRecommendationScreen> {
  String? _selectedBudget;
  bool _isLoading = false;
  List<dynamic>? _recommendations;
  int _selectedDay = 1;
  Measurement? _latestData;

  final List<Map<String, dynamic>> _budgetOptions = [
    {'value': 'low', 'label': 'Ekonomis', 'icon': Icons.savings_rounded, 'desc': 'Tempe, Tahu, Telur'},
    {'value': 'medium', 'label': 'Menengah', 'icon': Icons.account_balance_wallet_rounded, 'desc': 'Ayam, Ikan, Telur'},
    {'value': 'high', 'label': 'Variasi Luas', 'icon': Icons.diamond_rounded, 'desc': 'Daging Sapi, Ikan, Susu'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchLatestData();
  }

  Future<void> _fetchLatestData() async {
    final data = await LocalDatabase.instance.getAllMeasurements();
    if (data.isNotEmpty) {
      setState(() {
        _latestData = data.first;
      });
    }
  }

  List<Map<String, dynamic>> _getFallbackMenu(String budget) {
    if (budget == 'low') {
      return List.generate(7, (i) => {
        'hari': i + 1,
        'menu': {
          'pagi': (i % 2 == 0) ? 'Nasi lembek, telur puyuh rebus matang, bayam cincang.' : 'Bubur saring, telur dadar potong kecil, wortel rebus.',
          'siang': (i % 2 == 0) ? 'Nasi tim, perkedel tahu panggang, kuah kaldu sayur.' : 'Nasi lembek, tempe mendoan lembut (tanpa cabai), bayam.',
          'malam': (i % 2 == 0) ? 'Nasi lembek, orek tempe basah (manis/gurih), labu siam.' : 'Bubur saring, tahu kukus, kuah kaldu.'
        }
      });
    } else if (budget == 'medium') {
      return List.generate(7, (i) => {
        'hari': i + 1,
        'menu': {
          'pagi': (i % 2 == 0) ? 'Nasi tim, telur ayam orak-arik mentega, brokoli rebus.' : 'Nasi lembek, dada ayam suwir halus, wortel.',
          'siang': (i % 2 == 0) ? 'Nasi lembek, sup ayam bening, kentang potong dadu.' : 'Nasi tim, ikan lele goreng fillet (tanpa duri), bayam.',
          'malam': (i % 2 == 0) ? 'Nasi lembek, tumis ayam cincang kecap, buncis.' : 'Nasi lembek, telur rebus, kuah sup kaldu.'
        }
      });
    } else {
      return List.generate(7, (i) => {
        'hari': i + 1,
        'menu': {
          'pagi': (i % 2 == 0) ? 'Oatmeal dimasak dengan susu UHT/formula, pisang potong.' : 'Roti gandum panggang mentega, orak-arik telur, susu.',
          'siang': (i % 2 == 0) ? 'Nasi tim, semur daging sapi cincang, buncis rebus.' : 'Kentang tumbuk (mashed potato), ayam fillet mentega, wortel.',
          'malam': (i % 2 == 0) ? 'Nasi lembek, ikan salmon/tenggiri kukus bawang putih, brokoli.' : 'Pasta makaroni rebus lunak, saus keju daging cincang.'
        }
      });
    }
  }

  Future<void> _generateRecommendation() async {
    if (_selectedBudget == null || _latestData == null) return;

    setState(() => _isLoading = true);
    
    String statusGizi = _latestData!.zScore < -2.0 ? "Stunting/Underweight" : "Normal";
    if (_latestData!.zScore > 2.0) statusGizi = "Overweight";

    try {
      final response = await ApiClient.getNutritionRecommendation(
        age: _latestData!.age,
        statusGizi: statusGizi,
        budget: _selectedBudget!,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (response != null && response['status'] == 'success') {
            _recommendations = response['recommendation'];
          } else {
            _recommendations = _getFallbackMenu(_selectedBudget!);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Koneksi AI terputus. Menggunakan menu cadangan offline.")),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _recommendations = _getFallbackMenu(_selectedBudget!);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Koneksi internet tidak stabil. Menggunakan menu cadangan offline.")),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nutrition AI"),
        leading: Navigator.canPop(context) ? IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ) : null,
      ),
      body: _isLoading 
          ? _buildLoadingState(theme)
          : _recommendations == null 
              ? _buildBudgetSelector(theme) 
              : _buildRecommendationUI(theme),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            "AI sedang meramu menu terbaik...",
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("Mohon tunggu sebentar, Bunda."),
        ],
      ),
    );
  }

  Widget _buildBudgetSelector(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withAlpha(50),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: theme.colorScheme.primary.withAlpha(50)),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: theme.colorScheme.primary, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pilih Kategori Budget", 
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const Text("Agar AI bisa menyesuaikan menu dengan bahan yang tersedia."),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ..._budgetOptions.map((opt) {
            bool isSelected = _selectedBudget == opt['value'];
            return GestureDetector(
              onTap: () => setState(() => _selectedBudget = opt['value']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : theme.colorScheme.outlineVariant,
                    width: 2,
                  ),
                  boxShadow: isSelected 
                      ? [BoxShadow(color: theme.colorScheme.primary.withAlpha(80), blurRadius: 15, offset: const Offset(0, 8))]
                      : [],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white.withAlpha(40) : theme.colorScheme.primary.withAlpha(30),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(opt['icon'], color: isSelected ? Colors.white : theme.colorScheme.primary),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(opt['label'], 
                            style: TextStyle(
                              color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                          Text(opt['desc'], 
                            style: TextStyle(
                              color: isSelected ? Colors.white70 : theme.colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            )),
                        ],
                      ),
                    ),
                    if (isSelected) const Icon(Icons.check_circle_rounded, color: Colors.white),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: _selectedBudget == null ? null : _generateRecommendation,
              child: const Text("Generate Menu Mingguan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationUI(ThemeData theme) {
    final currentDayData = _recommendations!.firstWhere((d) => d['hari'] == _selectedDay);
    final menu = currentDayData['menu'];

    return Column(
      children: [
        Container(
          height: 90,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 7,
            itemBuilder: (context, index) {
              int day = index + 1;
              bool isSelected = _selectedDay == day;
              return GestureDetector(
                onTap: () => setState(() => _selectedDay = day),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 60,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? Colors.transparent : theme.colorScheme.outlineVariant),
                    boxShadow: isSelected 
                      ? [BoxShadow(color: theme.colorScheme.primary.withAlpha(80), blurRadius: 10, offset: const Offset(0, 4))]
                      : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("HARI", style: TextStyle(
                        color: isSelected ? Colors.white70 : theme.colorScheme.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      )),
                      Text("$day", style: TextStyle(
                        color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      )),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Menu Hari Ke-$_selectedDay", 
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                    TextButton.icon(
                      onPressed: () => setState(() {
                        _recommendations = null;
                        _selectedDay = 1;
                      }), 
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text("Reset"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildMealCard(theme, "Pagi", menu['pagi'], Icons.wb_sunny_rounded, Colors.orange),
                _buildMealCard(theme, "Siang", menu['siang'], Icons.light_mode_rounded, Colors.blue),
                _buildMealCard(theme, "Malam", menu['malam'], Icons.dark_mode_rounded, Colors.indigo),
                
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer.withAlpha(50),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: theme.colorScheme.secondary.withAlpha(50)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_rounded, color: theme.colorScheme.secondary),
                          const SizedBox(width: 12),
                          const Text("Tips Nutrisi", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text("Pastikan tekstur makanan sesuai dengan kemampuan mengunyah si kecil. Berikan minum air putih yang cukup."),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMealCard(ThemeData theme, String time, String content, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(30),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(time, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900, color: iconColor)),
                const SizedBox(height: 6),
                Text(content, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}