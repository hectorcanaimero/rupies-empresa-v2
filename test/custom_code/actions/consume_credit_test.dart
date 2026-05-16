import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';

import 'package:rupies_empresas/custom_code/actions/consume_credit.dart';
import '../../helpers/mock_http_responses.dart';
import '../../helpers/test_fixtures.dart';

void main() {
  group('consumeCredit', () {
    test('returns success with credits remaining on 200', () async {
      final client = MockClient((request) async {
        return successResponse({
          'creditsRemaining': 9,
          'isUnlimited': false,
        });
      });

      final result = await consumeCredit(
        'service_created',
        'ref-123',
        client: client,
        authToken: kFakeToken,
      );

      expect(result['success'], true);
      expect(result['creditsRemaining'], 9);
      expect(result['isUnlimited'], false);
      expect(result['error'], isNull);
    });

    test('returns insufficient credits on 402', () async {
      final client = MockClient((request) async {
        return insufficientCreditsResponse();
      });

      final result = await consumeCredit(
        'service_created',
        'ref-123',
        client: client,
        authToken: kFakeToken,
      );

      expect(result['success'], false);
      expect(result['error'], 'insufficient_credits');
    });

    test('returns error when auth token is null', () async {
      final result = await consumeCredit(
        'service_created',
        'ref-123',
        authToken: null,
      );

      expect(result['success'], false);
      expect(result['error'], 'unauthenticated');
    });

    test('returns error on 500 response', () async {
      final client = MockClient((request) async {
        return errorResponse(500, 'internal_error');
      });

      final result = await consumeCredit(
        'service_created',
        null,
        client: client,
        authToken: kFakeToken,
      );

      expect(result['success'], false);
      expect(result['error'], 'internal_error');
    });

    test('returns error on network exception', () async {
      final client = MockClient((request) async {
        throw Exception('Network error');
      });

      final result = await consumeCredit(
        'service_created',
        null,
        client: client,
        authToken: kFakeToken,
      );

      expect(result['success'], false);
      expect(result['error'], 'exception');
    });

    test('sends correct request body with referenceId', () async {
      Map<String, dynamic>? capturedBody;

      final client = MockClient((request) async {
        capturedBody = jsonDecode(request.body) as Map<String, dynamic>;
        return successResponse({
          'creditsRemaining': 9,
          'isUnlimited': false,
        });
      });

      await consumeCredit(
        'lead_contact',
        'lead-456',
        client: client,
        authToken: kFakeToken,
      );

      expect(capturedBody!['actionType'], 'lead_contact');
      expect(capturedBody!['referenceId'], 'lead-456');
      expect(capturedBody!['cost'], 1);
    });

    test('sends correct request body without referenceId', () async {
      Map<String, dynamic>? capturedBody;

      final client = MockClient((request) async {
        capturedBody = jsonDecode(request.body) as Map<String, dynamic>;
        return successResponse({
          'creditsRemaining': 9,
          'isUnlimited': false,
        });
      });

      await consumeCredit(
        'service_created',
        null,
        client: client,
        authToken: kFakeToken,
      );

      expect(capturedBody!['actionType'], 'service_created');
      expect(capturedBody!.containsKey('referenceId'), false);
    });

    test('sends Authorization header with Bearer token', () async {
      String? capturedAuth;

      final client = MockClient((request) async {
        capturedAuth = request.headers['Authorization'];
        return successResponse({
          'creditsRemaining': 9,
          'isUnlimited': false,
        });
      });

      await consumeCredit(
        'service_created',
        null,
        client: client,
        authToken: kFakeToken,
      );

      expect(capturedAuth, 'Bearer $kFakeToken');
    });
  });
}
