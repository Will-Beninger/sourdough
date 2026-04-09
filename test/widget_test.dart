import 'package:flutter_test/flutter_test.dart';
import 'package:sourdough/main.dart';

void main() {
  testWidgets('Blank screen loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SourdoughApp());

    // Verify that the text 'Vibecoded Sourdough App' is present.
    expect(find.text('Vibecoded Sourdough App'), findsOneWidget);
  });
}
