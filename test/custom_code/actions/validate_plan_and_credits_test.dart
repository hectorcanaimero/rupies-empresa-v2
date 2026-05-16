import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rupies_empresas/backend/schema/structs/subs_data_type_struct.dart';
import 'package:rupies_empresas/custom_code/actions/validate_plan_and_credits.dart';
import '../../helpers/test_fixtures.dart';

void main() {
  group('validatePlanAndCredits', () {
    testWidgets('returns true when active with credits', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      final context = tester.element(find.byType(Scaffold));
      final result = await validatePlanAndCredits(
        context,
        subscriptionOverride: activeWithCredits(),
      );

      expect(result, true);
    });

    testWidgets('returns true when active unlimited', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      final context = tester.element(find.byType(Scaffold));
      final result = await validatePlanAndCredits(
        context,
        subscriptionOverride: activeUnlimited(),
      );

      expect(result, true);
    });

    testWidgets('returns false when subscription inactive', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      final context = tester.element(find.byType(Scaffold));

      final futureResult = validatePlanAndCredits(
        context,
        subscriptionOverride: inactive(),
      );

      await tester.pumpAndSettle();

      // Verify dialog is showing with correct title
      expect(find.text('Plano não ativo'), findsOneWidget);

      // Tap "Fechar" to dismiss
      await tester.tap(find.text('Fechar'));
      await tester.pumpAndSettle();

      final result = await futureResult;
      expect(result, false);
    });

    testWidgets('returns false when active but no credits', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      final context = tester.element(find.byType(Scaffold));

      final futureResult = validatePlanAndCredits(
        context,
        subscriptionOverride: activeNoCredits(),
      );

      await tester.pumpAndSettle();

      // Verify dialog shows "Sem créditos"
      expect(find.text('Sem créditos'), findsOneWidget);

      await tester.tap(find.text('Fechar'));
      await tester.pumpAndSettle();

      final result = await futureResult;
      expect(result, false);
    });

    testWidgets('returns false with default empty struct', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      final context = tester.element(find.byType(Scaffold));

      final futureResult = validatePlanAndCredits(
        context,
        subscriptionOverride: SubsDataTypeStruct(),
      );

      await tester.pumpAndSettle();

      expect(find.text('Plano não ativo'), findsOneWidget);

      await tester.tap(find.text('Fechar'));
      await tester.pumpAndSettle();

      final result = await futureResult;
      expect(result, false);
    });
  });
}
