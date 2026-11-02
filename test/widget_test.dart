import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_monitor/main.dart';

void main() {
  testWidgets('Smart Monitor dashboard renders metrics, dynamic levels, and toggles LED', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SmartMonitorApp());
    await tester.pumpAndSettle();

    // Verify Header and Connection Status
    expect(find.text('SMART MONITOR'), findsOneWidget);
    expect(find.text('Dashboard Lingkungan'), findsOneWidget);
    expect(find.text('Terhubung'), findsOneWidget);

    // Verify Metrics and Dynamic Levels
    expect(find.text('28.5'), findsOneWidget);
    expect(find.text('°C'), findsOneWidget);
    expect(find.text('Optimal'), findsOneWidget);

    expect(find.text('70'), findsOneWidget);
    expect(find.text('%'), findsOneWidget);
    expect(find.text('Nyaman'), findsOneWidget);

    // Verify Hardware Metadata
    expect(find.text('DHT22 / Termal'), findsOneWidget);
    expect(find.textContaining('Node: ESP32-WROOM'), findsOneWidget);

    // Initial LED State
    expect(find.text('Mati'), findsOneWidget);
    expect(find.text('Menyala'), findsNothing);

    // Toggle LED Switch
    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);

    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    // State updated to Menyala
    expect(find.text('Menyala'), findsOneWidget);
    expect(find.text('Mati'), findsNothing);
  });
}
