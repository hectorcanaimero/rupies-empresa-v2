import 'package:flutter_test/flutter_test.dart';

import 'package:rupies_empresas/custom_code/actions/check_subscription.dart';

void main() {
  group('checkSubscription', () {
    test('returns true when active subscription and no feature key', () async {
      final result = await checkSubscription(
        null,
        getStatusFn: () async => {
          'hasActiveSubscription': true,
          'features': ['leads', 'services'],
        },
      );

      expect(result, true);
    });

    test('returns true when active and feature key present', () async {
      final result = await checkSubscription(
        'leads',
        getStatusFn: () async => {
          'hasActiveSubscription': true,
          'features': ['leads', 'services'],
        },
      );

      expect(result, true);
    });

    test('returns false when active but feature key absent', () async {
      final result = await checkSubscription(
        'premium_analytics',
        getStatusFn: () async => {
          'hasActiveSubscription': true,
          'features': ['leads', 'services'],
        },
      );

      expect(result, false);
    });

    test('returns false when subscription inactive', () async {
      final result = await checkSubscription(
        null,
        getStatusFn: () async => {
          'hasActiveSubscription': false,
          'features': [],
        },
      );

      expect(result, false);
    });

    test('returns false when getSubscriptionStatus returns null', () async {
      final result = await checkSubscription(
        null,
        getStatusFn: () async => null,
      );

      expect(result, false);
    });

    test('returns true when feature key is empty string', () async {
      final result = await checkSubscription(
        '',
        getStatusFn: () async => {
          'hasActiveSubscription': true,
          'features': ['leads'],
        },
      );

      expect(result, true);
    });

    test('returns false when getStatusFn throws', () async {
      final result = await checkSubscription(
        null,
        getStatusFn: () async => throw Exception('Network error'),
      );

      expect(result, false);
    });
  });
}
