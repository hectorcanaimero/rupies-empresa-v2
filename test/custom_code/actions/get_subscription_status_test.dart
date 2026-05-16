import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';

import 'package:rupies_empresas/custom_code/actions/get_subscription_status.dart';
import '../../helpers/mock_http_responses.dart';
import '../../helpers/test_fixtures.dart';

void main() {
  group('getSubscriptionStatus', () {
    test('returns subscription data on 200 success', () async {
      final client = MockClient((request) async {
        return successResponse({
          'hasActiveSubscription': true,
          'subscriptions': [
            {'id': 'sub-001', 'status': 'active'}
          ],
          'features': ['leads', 'services'],
        });
      });

      final result = await getSubscriptionStatus(
        client: client,
        authToken: kFakeToken,
      );

      expect(result, isNotNull);
      expect(result['hasActiveSubscription'], true);
      expect(result['features'], contains('leads'));
    });

    test('returns null when auth token is null', () async {
      final result = await getSubscriptionStatus(authToken: null);
      expect(result, isNull);
    });

    test('returns null on 500 response', () async {
      final client = MockClient((request) async {
        return errorResponse(500, 'internal_error');
      });

      final result = await getSubscriptionStatus(
        client: client,
        authToken: kFakeToken,
      );

      expect(result, isNull);
    });

    test('returns null on network exception', () async {
      final client = MockClient((request) async {
        throw Exception('Network error');
      });

      final result = await getSubscriptionStatus(
        client: client,
        authToken: kFakeToken,
      );

      expect(result, isNull);
    });

    test('returns null when success is false', () async {
      final client = MockClient((request) async {
        return errorResponse(200, 'invalid_token');
      });

      final result = await getSubscriptionStatus(
        client: client,
        authToken: kFakeToken,
      );

      expect(result, isNull);
    });

    test('sends GET request to correct URL', () async {
      Uri? capturedUrl;
      String? capturedMethod;

      final client = MockClient((request) async {
        capturedUrl = request.url;
        capturedMethod = request.method;
        return successResponse({'hasActiveSubscription': false});
      });

      await getSubscriptionStatus(client: client, authToken: kFakeToken);

      expect(capturedMethod, 'GET');
      expect(capturedUrl.toString(), '$kBaseUrl/get-subscription-history');
    });
  });
}
