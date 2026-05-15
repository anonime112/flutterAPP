import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:repair_service_ui/config/maps_config.dart';

/// Watsonx (IBM Watson Orchestrate) client for route recommendations.
class WatsonxService {
  /// Fetch route recommendations from Watsonx based on a travel query.
  static Future<Map<String, dynamic>> fetchRecommendations(String message) async {
    if (kWatsonxEndpoint.isEmpty || kWatsonxApiKey.isEmpty) {
      return {'error': 'Watsonx not configured', 'recommendations': []};
    }

    try {
      final uri = Uri.parse('${kWatsonxEndpoint}/api/v1/orchestrate/runs/stream');
      
      final body = jsonEncode({
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

      final resp = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${kWatsonxApiKey}',
        },
        body: body,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => http.Response('Timeout', 408),
      );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final data = jsonDecode(resp.body);
        return {
          'success': true,
          'data': data,
          'recommendations': _parseRecommendations(data),
        };
      } else {
        return {
          'error': 'API Error: ${resp.statusCode}',
          'body': resp.body,
          'recommendations': [],
        };
      }
    } catch (e) {
      return {
        'error': 'Exception: $e',
        'recommendations': [],
      };
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
