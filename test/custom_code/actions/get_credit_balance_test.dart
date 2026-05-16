import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';

import 'package:rupies_empresas/custom_code/actions/get_credit_balance.dart';
import '../../helpers/mock_http_responses.dart';
import '../../helpers/test_fixtures.dart';

void main() {
  group('getCreditBalance', () {
    test('returns balance data on 200 success', () async {
      final client = MockClient((request) async {
        return successResponse({
          'hasBalance': true,
          'creditsRemaining': 15,
          'creditsGranted': 20,
          'creditsUsed': 5,
          'isUnlimited': false,
          'periodEnd': '2026-06-01',
          'plan': {'id': 'plan-basic', 'name': 'Básico'},
        });
      });

      final result = await getCreditBalance(
        client: client,
        authToken: kFakeToken,
      );

      expect(result['hasBalance'], true);
      expect(result['creditsRemaining'], 15);
      expect(result['creditsGranted'], 20);
      expect(result['creditsUsed'], 5);
      expect(result['isUnlimited'], false);
      expect(result['periodEnd'], '2026-06-01');
      expect(result['plan']['id'], 'plan-basic');
    });

    test('returns default values when auth token is null', () async {
      final result = await getCreditBalance(authToken: null);

      expect(result['hasBalance'], false);
      expect(result['creditsRemaining'], 0);
      expect(result['isUnlimited'], false);
      expect(result['plan'], isNull);
    });

    test('returns default values on 500 response', () async {
      final client = MockClient((request) async {
        return errorResponse(500, 'internal_error');
      });

      final result = await getCreditBalance(
        client: client,
        authToken: kFakeToken,
      );

      expect(result['hasBalance'], false);
      expect(result['creditsRemaining'], 0);
    });

    test('returns default values on network exception', () async {
      final client = MockClient((request) async {
        throw Exception('Network error');
      });

      final result = await getCreditBalance(
        client: client,
        authToken: kFakeToken,
      );

      expect(result['hasBalance'], false);
      expect(result['creditsRemaining'], 0);
    });

    test('returns default values when success is false', () async {
      final client = MockClient((request) async {
        return errorResponse(200, 'invalid_user');
      });

      final result = await getCreditBalance(
        client: client,
        authToken: kFakeToken,
      );

      expect(result['hasBalance'], false);
      expect(result['creditsRemaining'], 0);
    });

    test('sends GET request with correct URL', () async {
      Uri? capturedUrl;

      final client = MockClient((request) async {
        capturedUrl = request.url;
        return successResponse({'hasBalance': false});
      });

      await getCreditBalance(client: client, authToken: kFakeToken);

      expect(capturedUrl.toString(), '$kBaseUrl/get-credit-balance');
    });
  });
}
