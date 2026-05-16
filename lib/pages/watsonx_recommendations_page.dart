import 'package:flutter/material.dart';
import 'package:repair_service_ui/utils/constants.dart';
import 'package:repair_service_ui/services/watsonx_service.dart';
import 'package:repair_service_ui/widgets/app_drawer.dart';

class WatsonxRecommendationsPage extends StatefulWidget {
  const WatsonxRecommendationsPage({super.key});

  @override
  State<WatsonxRecommendationsPage> createState() =>
      _WatsonxRecommendationsPageState();
}

class _WatsonxRecommendationsPageState
    extends State<WatsonxRecommendationsPage> {
  final _queryController = TextEditingController();
  bool _loading = false;
  Map<String, dynamic>? _result;
  List<Map<String, dynamic>> _recommendations = [];
  String _assistantText = '';
  String _lastQuery = '';

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _fetchRecommendations() async {
    if (_queryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer une requête')),
      );
      return;
    }

    final query = _queryController.text.trim();
    setState(() {
      _loading = true;
      _result = null;
      _recommendations = [];
      _assistantText = '';
      _lastQuery = query;
    });

    final result = await WatsonxService.fetchRecommendations(
      query,
      onChunk: (chunk) {
        if (!mounted) return;
        setState(() {
          _assistantText += chunk;
        });
      },
    );

    setState(() {
      _loading = false;
      _result = result;
      final recs = result['recommendations'];
      if (recs is List) {
        _recommendations = recs.whereType<Map<String, dynamic>>().toList();
      } else {
        _recommendations = [];
      }
      if (_assistantText.isEmpty && result['body'] != null) {
        _assistantText = result['body'].toString();
      }
    });

    if (result['error'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${result['error']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Recommandations Watsonx',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Demandez à l\'IA Watsonx',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Constants.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Posez une question sur les trajets, les itinéraires ou les meilleures solutions de transport à Abidjan.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _queryController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Ex: Quel est le meilleur trajet de Marcory à Plateau?\n\nOu: Recommande-moi un itinéraire de Zone 4 à Yopougon.',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loading ? null : _fetchRecommendations,
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.accentOrange,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: _loading ? const SizedBox() : const Icon(Icons.send),
              label: Text(
                _loading ? 'Chargement...' : 'Envoyer',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),
            if (_lastQuery.isNotEmpty)
              _buildChatBlock(),
            if (_recommendations.isEmpty && !_loading && _result != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber[300]!),
                ),
                child: Text(
                  'Aucune recommandation trouvée.',
                  style: TextStyle(color: Colors.amber[900]),
                ),
              ),
            if (_recommendations.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommandations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Constants.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._recommendations.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final rec = entry.value;
                    return _buildRecommendationCard(idx, rec);
                  }).toList(),
                ],
              ),
            if (_loading)
              Column(
                children: [
                  Center(
                    child: CircularProgressIndicator(
                      color: Constants.accentOrange,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Watsonx analyse votre demande...',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            if (_result != null && _result!['error'] != null)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Erreur',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red[900],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _result!['error'].toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[700],
                      ),
                    ),
                    if (_result!['body'] != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Réponse: ${_result!['body']}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.red[600],
                          fontFamily: 'monospace',
                        ),
                      ),
                    ]
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Conversation',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Constants.primaryColor,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMessageBubble('Vous', _lastQuery, false),
              const SizedBox(height: 12),
              _buildMessageBubble('Watsonx', _assistantText.isNotEmpty ? _assistantText : 'En attente de la réponse...', true),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMessageBubble(String sender, String text, bool isAssistant) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isAssistant ? Constants.accentLagoon.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Constants.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(int index, Map<String, dynamic> rec) {
    final isJson = rec['type'] == 'response';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Constants.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Constants.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Constants.accentOrange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isJson ? 'Réponse Watsonx' : 'Conseil',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Constants.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SelectableText(
            rec['text'] ?? '',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
