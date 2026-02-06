import 'package:intl/intl.dart';
import '../models/coastal_knowledge.dart';
import 'hive_service.dart';

class OfflineAIService {
  static Future<CoastalKnowledge?> getResponse(String query) async {
    // Ensuring Hive is ready is done in main, but we safe check
    if (!HiveService.knowledgeBox.isOpen) return null;

    if (query.trim().isEmpty) return null;

    final lowerQuery = query.toLowerCase();

    // --- DYNAMIC HANDLERS ---

    // Date/Time
    if (lowerQuery.contains("time") && lowerQuery.contains("now") ||
        lowerQuery.contains("what time")) {
      final now = DateTime.now();
      return _createDynamicResponse(
          "Current Time", DateFormat('hh:mm a').format(now));
    }

    if (lowerQuery.contains("date") || lowerQuery.contains("today")) {
      final now = DateTime.now();
      return _createDynamicResponse(
          "Today's Date", DateFormat('EEEE, MMMM d, yyyy').format(now));
    }

    if (lowerQuery.contains("day") && lowerQuery.contains("today") ||
        lowerQuery.contains("what day")) {
      final now = DateTime.now();
      return _createDynamicResponse("Today is", DateFormat('EEEE').format(now));
    }

    // --- KEYWORD SEARCH ON HIVE ---

    final keywords = lowerQuery
        .split(RegExp(r'\s+'))
        .where((k) => k.length > 2) // Ignore small words
        .toList();

    print("DEBUG: Query='$query', Keywords=$keywords");

    if (keywords.isEmpty) return null;

    CoastalKnowledge? bestMatch;
    double highestScore = 0.0;

    // QUERY HIVE
    final allKnowledge = HiveService.knowledgeBox.values;
    print("DEBUG: Searching through ${allKnowledge.length} Hive entries...");

    for (final knowledge in allKnowledge) {
      double score = 0.0;
      final titleLower = knowledge.title.toLowerCase();
      final descLower = knowledge.description.toLowerCase();

      for (final keyword in keywords) {
        if (titleLower.contains(keyword)) score += 3.0;
        if (descLower.contains(keyword)) score += 1.0;
      }

      // Boost by confidence (0-100 mapped to 0.0-1.0)
      score *= (knowledge.confidenceScore / 100.0);

      // Boost specific exact matches for greetings
      if (knowledge.category == "General" && titleLower.contains(keywords[0])) {
        score += 5.0;
      }

      // CRITICAL: Boost User Contributions so they override default data
      if (knowledge.id.startsWith('contrib_')) {
        score += 50.0;
      }

      if (score > highestScore) {
        highestScore = score;
        bestMatch = knowledge;
      }
    }

    if (highestScore < 1.0) return null;

    return bestMatch;
  }

  /// Returns a fuzzy match using Jaccard Similarity (Intersection / Union)
  static Future<CoastalKnowledge?> findFuzzyMatch(String query) async {
    if (!HiveService.knowledgeBox.isOpen) return null;
    if (query.trim().isEmpty) return null;

    final queryTokens = _tokenize(query);
    if (queryTokens.isEmpty) return null;

    CoastalKnowledge? bestMatch;
    double highestJaccard = 0.0;

    final allKnowledge = HiveService.knowledgeBox.values;

    for (final knowledge in allKnowledge) {
      // Combine title and description for matching
      final docText = "${knowledge.title} ${knowledge.description}";
      final docTokens = _tokenize(docText);

      final intersection = queryTokens.intersection(docTokens).length;
      final union = queryTokens.union(docTokens).length;

      if (union == 0) continue;

      double jaccard = intersection / union;

      // Boost if title words match exactly
      final titleTokens = _tokenize(knowledge.title);
      if (queryTokens.intersection(titleTokens).isNotEmpty) {
        jaccard += 0.1; // Bonus for title matches
      }

      if (jaccard > highestJaccard) {
        highestJaccard = jaccard;
        bestMatch = knowledge;
      }
    }

    // Lower threshold for fuzzy matching (0.05 implies at least some meaningful overlap)
    if (highestJaccard < 0.05) return null;

    return bestMatch;
  }

  static Set<String> _tokenize(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '') // Remove punctuation
        .split(RegExp(r'\s+'))
        .where((w) => w.length > 2 && !_stopWords.contains(w))
        .toSet();
  }

  static const _stopWords = {
    'the',
    'and',
    'is',
    'are',
    'was',
    'for',
    'with',
    'that',
    'this',
    'how',
    'what',
    'why',
    'who'
  };

  static CoastalKnowledge _createDynamicResponse(String title, String desc) {
    return CoastalKnowledge(
      id: 'dynamic_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: desc,
      category: 'Dynamic',
      verificationStatus: 'system',
      confidenceScore: 100,
      accessCount: 0,
      contributorId: 'system',
      createdAt: DateTime.now(),
    );
  }
}
