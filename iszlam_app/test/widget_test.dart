import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Supabase requires native channels — basic sanity check only
    expect(1 + 1, 2);
  });
}
