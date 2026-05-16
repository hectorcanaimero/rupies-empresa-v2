import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';

import 'package:rupies_empresas/custom_code/actions/cancel_subscription.dart';
import '../../helpers/mock_http_responses.dart';
import '../../helpers/test_fixtures.dart';

void main() {
  group('cancelSubscription', () {
    test('returns data on 200 success', () async {
      final client = MockClient((request) async {
        return successResponse({
          'subscriptionId': 'sub-001',
          'canceledAt': '2026-05-16',
        });
      });

      final result = await cancelSubscription(
        'sub-001',
        false,
        'Too expensive',
        client: client,
        authToken: kFakeToken,
      );

      expect(result['subscriptionId'], 'sub-001');
      expect(result['canceledAt'], '2026-05-16');
    });

    test('returns error when auth token is null', () async {
      final result = await cancelSubscription(
        'sub-001',
        false,
        null,
        authToken: null,
      );

      expect(result['success'], false);
      expect(result['error'], contains('autenticado'));
    });

    test('returns error on 500 response', () async {
      final client = MockClient((request) async {
        return errorResponse(500, 'Erro ao cancelar assinatura');
      });

      final result = await cancelSubscription(
        'sub-001',
        true,
        null,
        client: client,
        authToken: kFakeToken,
      );

      expect(result['success'], false);
    });

    test('returns error on network exception', () async {
      final client = MockClient((request) async {
        throw Exception('Network error');
      });

      final result = await cancelSubscription(
        'sub-001',
        false,
        'reason',
        client: client,
        authToken: kFakeToken,
      );

      expect(result['success'], false);
      expect(result['error'], contains('Erro'));
    });

    test('sends correct request body with reason', () async {
      Map<String, dynamic>? capturedBody;

      final client = MockClient((request) async {
        capturedBody = jsonDecode(request.body) as Map<String, dynamic>;
        return successResponse({'subscriptionId': 'sub-001'});
      });

      await cancelSubscription(
        'sub-001',
        true,
        'Too expensive',
        client: client,
        authToken: kFakeToken,
      );

      expect(capturedBody!['subscriptionId'], 'sub-001');
      expect(capturedBody!['immediate'], true);
      expect(capturedBody!['reason'], 'Too expensive');
    });

    test('sends null reason in request body', () async {
      Map<String, dynamic>? capturedBody;

      final client = MockClient((request) async {
        capturedBody = jsonDecode(request.body) as Map<String, dynamic>;
        return successResponse({'subscriptionId': 'sub-001'});
      });

      await cancelSubscription(
        'sub-001',
        false,
        null,
        client: client,
        authToken: kFakeToken,
      );

      expect(capturedBody!['reason'], isNull);
    });

    test('returns error from success:false 200 response', () async {
      final client = MockClient((request) async {
        return errorResponse(200, 'subscription_not_found');
      });

      final result = await cancelSubscription(
        'sub-invalid',
        false,
        null,
        client: client,
        authToken: kFakeToken,
      );

      expect(result['success'], false);
      expect(result['error'], 'subscription_not_found');
    });
  });
}
