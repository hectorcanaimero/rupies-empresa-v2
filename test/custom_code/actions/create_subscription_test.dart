import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:rupies_empresas/custom_code/actions/create_subscription.dart';
import '../../helpers/mock_http_responses.dart';
import '../../helpers/test_fixtures.dart';

void main() {
  group('createSubscription', () {
    test('returns success with subscription data on 200', () async {
      final client = MockClient((request) async {
        return successResponse({
          'subscriptionId': 'sub-new-001',
          'status': 'active',
        });
      });

      final result = await createSubscription(
        'plan-basic',
        'monthly',
        'pix',
        client: client,
        authToken: kFakeToken,
      );

      expect(result['success'], true);
      expect(result['subscriptionId'], 'sub-new-001');
    });

    test('returns success with non-map data', () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode({'success': true, 'data': 'string-value'}),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final result = await createSubscription(
        'plan-basic',
        'monthly',
        'pix',
        client: client,
        authToken: kFakeToken,
      );

      expect(result['success'], true);
      expect(result['data'], 'string-value');
    });

    test('returns error when auth token is null', () async {
      final result = await createSubscription(
        'plan-basic',
        'monthly',
        'pix',
        authToken: null,
      );

      expect(result['success'], false);
      expect(result['error'], contains('autenticado'));
    });

    test('returns error on 500 response', () async {
      final client = MockClient((request) async {
        return errorResponse(500, 'Erro ao criar assinatura');
      });

      final result = await createSubscription(
        'plan-basic',
        'monthly',
        'pix',
        client: client,
        authToken: kFakeToken,
      );

      expect(result['success'], false);
    });

    test('returns error on network exception', () async {
      final client = MockClient((request) async {
        throw Exception('Network error');
      });

      final result = await createSubscription(
        'plan-basic',
        'monthly',
        'pix',
        client: client,
        authToken: kFakeToken,
      );

      expect(result['success'], false);
      expect(result['error'], contains('Erro'));
    });

    test('sends correct request body', () async {
      Map<String, dynamic>? capturedBody;

      final client = MockClient((request) async {
        capturedBody = jsonDecode(request.body) as Map<String, dynamic>;
        return successResponse({'subscriptionId': 'sub-001'});
      });

      await createSubscription(
        'plan-pro',
        'yearly',
        'credit_card',
        client: client,
        authToken: kFakeToken,
      );

      expect(capturedBody!['planId'], 'plan-pro');
      expect(capturedBody!['billingCycle'], 'yearly');
      expect(capturedBody!['paymentMethod'], 'credit_card');
    });

    test('returns error message from non-200 JSON body', () async {
      final client = MockClient((request) async {
        return errorResponse(422, 'Plano inválido');
      });

      final result = await createSubscription(
        'bad-plan',
        'monthly',
        'pix',
        client: client,
        authToken: kFakeToken,
      );

      expect(result['success'], false);
      expect(result['error'], 'Plano inválido');
    });
  });
}
