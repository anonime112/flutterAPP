import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:repair_service_ui/config/maps_config.dart';

/// Watsonx (IBM Watson Orchestrate) client for route recommendations.
class WatsonxService {
  /// Fetch route recommendations from Watsonx based on a travel query.
  static Future<Map<String, dynamic>> fetchRecommendations(
    String message, {
    void Function(String chunk)? onChunk,
  }) async {
    if (kWatsonxEndpoint.isEmpty || kWatsonxApiKey.isEmpty) {
      return {'error': 'Watsonx not configured', 'recommendations': []};
    }

    final client = http.Client();
    try {
      final uri = Uri.parse('${kWatsonxEndpoint}/api/v1/orchestrate/runs/stream');
      final request = http.Request('POST', uri);
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json, text/event-stream',
        'Authorization': 'Bearer ${kWatsonxApiKey}',
      });
      request.body = jsonEncode({
        'message': {
          'role': 'user',
          'content': [
            {
              'type': 'text',
              'text': message,
            }
          ],
        },
        'llm_params': {
          'max_new_tokens': 500,
          'temperature': 0.7,
        },
      });

      final streamedResp = await client.send(request).timeout(
        const Duration(seconds: 40),
        onTimeout: () => throw Exception('Watsonx request timeout'),
      );

      final buffer = StringBuffer();
      await for (final chunk in streamedResp.stream.transform(utf8.decoder)) {
        final normalized = _normalizeChunk(chunk);
        buffer.write(normalized);
        if (onChunk != null && normalized.isNotEmpty) {
          onChunk(normalized);
        }
      }

      final body = buffer.toString();
      if (streamedResp.statusCode == 200 || streamedResp.statusCode == 201) {
        Map<String, dynamic>? data;
        try {
          data = jsonDecode(body) as Map<String, dynamic>;
        } catch (_) {
          final matches = RegExp(r'data:\s*(\{.*\})', dotAll: true).allMatches(body);
          if (matches.isNotEmpty) {
            try {
              data = jsonDecode(matches.last.group(1)!) as Map<String, dynamic>;
            } catch (_) {
              data = null;
            }
          }
        }

        if (data != null) {
          return {
            'success': true,
            'data': data,
            'recommendations': _parseRecommendations(data),
            'body': body,
          };
        }

        return {
          'success': false,
          'error': 'Unable to parse Watsonx response',
          'body': body,
          'recommendations': [],
        };
      }

      return {
        'error': 'API Error: ${streamedResp.statusCode}',
        'body': body,
        'recommendations': [],
      };
    } catch (e) {
      return {
        'error': 'Exception: $e',
        'recommendations': [],
      };
    } finally {
      client.close();
    }
  }

  /// Parse recommendations from Watsonx response
  static List<Map<String, dynamic>> _parseRecommendations(
      Map<String, dynamic> data) {
    final recommendations = <Map<String, dynamic>>[];
    
    // Try to extract recommendations from various possible response formats
    if (data['output'] != null) {
      final output = data['output'];
      if (output is Map && output['message'] != null) {
        final message = output['message'];
        if (message is Map && message['content'] != null) {
          final content = message['content'];
          if (content is List) {
            for (var item in content) {
              if (item is Map) {
                recommendations.add({
                  'type': item['type'] ?? 'text',
                  'text': item['text'] ?? item['content'] ?? '',
                });
              }
            }
          }
        }
      }
    }
    
    // If no content found, try to create a summary from the full response
    if (recommendations.isEmpty && data['output'] != null) {
      recommendations.add({
        'type': 'response',
        'text': jsonEncode(data['output']),
      });
    }

    return recommendations;
  }

  static String _normalizeChunk(String chunk) {
    final lines = chunk.split(RegExp(r'\r?\n'));
    final buffer = StringBuffer();
    for (final line in lines) {
      if (line.startsWith('data: ')) {
        buffer.write(line.substring(6));
      } else if (line.startsWith('data:')) {
        buffer.write(line.substring(5));
      } else {
        buffer.write(line);
      }
    }
    return buffer.toString();
  }

  /// Fetch simple route suggestions (legacy)
  static Future<List<Map<String, dynamic>>> fetchRouteSuggestions(
      String from, String to) async {
    final message = 'Suggest the best travel routes from $from to $to in Abidjan. '
        'Consider VTC, public transport, and carpooling options with estimated times and costs.';
    
    final result = await fetchRecommendations(message);
    
    if (result['success'] == true) {
      return result['recommendations'] ?? [];
    }
    return [];
  }
}
