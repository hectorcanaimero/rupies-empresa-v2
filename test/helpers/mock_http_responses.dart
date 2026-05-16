import 'dart:convert';
import 'package:http/http.dart' as http;

http.Response successResponse(Map<String, dynamic> data) {
  return http.Response(
    jsonEncode({'success': true, 'data': data}),
    200,
    headers: {'content-type': 'application/json'},
  );
}

http.Response errorResponse(int statusCode, String error) {
  return http.Response(
    jsonEncode({'success': false, 'error': error}),
    statusCode,
    headers: {'content-type': 'application/json'},
  );
}

http.Response insufficientCreditsResponse() {
  return http.Response(
    jsonEncode({
      'success': false,
      'error': 'insufficient_credits',
      'creditsRemaining': 0,
    }),
    402,
    headers: {'content-type': 'application/json'},
  );
}
