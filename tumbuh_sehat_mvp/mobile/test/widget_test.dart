import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Memanggil kelas TumbuhSehatApp kita, bukan MyApp lagi
    await tester.pumpWidget(const TumbuhSehatApp());
    
    // Pastikan aplikasi berhasil dimuat
    expect(find.byType(TumbuhSehatApp), findsOneWidget);
  });
}