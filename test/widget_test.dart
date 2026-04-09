import 'package:flutter_test/flutter_test.dart';

import 'package:sourdough/main.dart';

void main() {
  testWidgets('Blank screen loads correctly', (tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SourdoughApp());

    // Verify that the title is there.
    expect(find.text('Baking Calculator'), findsOneWidget);
  });
}
