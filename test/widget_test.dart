import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solarsize/main.dart';

void main() {
  testWidgets('shows the starter results', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('SolarSize'), findsOneWidget);
    expect(find.text('Fridge'), findsOneWidget);
    expect(find.text('3 kVA'), findsOneWidget);
    expect(find.text('≈ \$1,750'), findsOneWidget);
  });

  testWidgets('adding an air conditioner updates the results', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Air conditioner'));
    await tester.pumpAndSettle();

    expect(find.text('5 kVA'), findsOneWidget);
    expect(find.text('≈ \$2,910'), findsOneWidget);
  });

  testWidgets('unchecking installation lowers the cost', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(find.text('≈ \$1,520'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(find.text('≈ \$1,750'), findsOneWidget);
  });

  testWidgets('minus on a single item removes it', (tester) async {
    await tester.pumpWidget(const MyApp());

    // the fridge is the first tile and its quantity is 1
    await tester.tap(find.byIcon(Icons.remove).first);
    await tester.pump();

    expect(find.text('Fridge'), findsNothing);
    expect(find.text('Fridge removed'), findsOneWidget);
  });

  testWidgets('changing the hours of an appliance', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Fridge'));
    await tester.pumpAndSettle();
    expect(find.text('How many hours a day is it on?'), findsOneWidget);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('How many hours a day is it on?'), findsNothing);
  });
}
