import '../models/coastal_knowledge.dart';
import '../providers/connectivity_provider.dart';
import 'offline_ai_service.dart';
import 'online_ai_service.dart';
import 'safety_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DecisionEngine {
  /// The Brain of BlueGuide.
  /// Decides which service answers the question based on priority.
  static Future<CoastalKnowledge> processQuery(
      BuildContext context, String query) async {
    // 1. SAFETY LAYER (Priority 0)
    // Runs purely offline, regex-based, instant blocking for danger.
    final safetyAlert = SafetyService.checkSafety(query);
    if (safetyAlert != null) {
      return safetyAlert;
    }

    // 2. OFFLINE EXACT/KEYWORD MATCH (Priority 1)
    // Fast, proprietary knowledge base search.
    final offlineMatch = await OfflineAIService.getResponse(query);
    if (offlineMatch != null) {
      return offlineMatch;
    }

    // 3. SEMANTIC FUZZY MATCH (Priority 2)
    // Jaccard similarity for "I think you meant..." assertions.
    final fuzzyMatch = await OfflineAIService.findFuzzyMatch(query);
    if (fuzzyMatch != null) {
      // Add a disclaimer to fuzzy matches
      fuzzyMatch.description =
          "(I think you asked about this...)\n\n${fuzzyMatch.description}";
      return fuzzyMatch;
    }

    // 4. ONLINE AI LAYER (Priority 3)
    // Fallback to LLM if internet is available.
    final isOnline =
        Provider.of<ConnectivityProvider>(context, listen: false).isOnline;
    if (isOnline) {
      try {
        final onlineResponse = await OnlineAIService.getResponse(query);
        return CoastalKnowledge(
          id: 'online_${DateTime.now().millisecondsSinceEpoch}',
          title: 'BlueGuide AI',
          description: onlineResponse,
          category: 'Online AI',
          verificationStatus: 'ai_generated',
          confidenceScore: 70, // Lower confidence for standard LLM
          accessCount: 0,
          contributorId: 'openai',
          createdAt: DateTime.now(),
        );
      } catch (e) {
        // Online failed, fall through to final fallback
        print("Online AI Failed: $e");
      }
    }

    // 5. FINAL FALLBACK (Priority 4)
    return CoastalKnowledge(
      id: 'fallback',
      title: 'I don\'t know that yet.',
      description:
          "I couldn't find a reliable answer in my offline database.\n\nPlease ask a local expert, check with the fisheries department, or try rewording your question (e.g., 'Safety', 'Fishing').",
      category: 'System',
      verificationStatus: 'system',
      confidenceScore: 0,
      accessCount: 0,
      contributorId: 'system',
      createdAt: DateTime.now(),
    );
  }
}
