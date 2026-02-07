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
    // 1. SAFETY LAYER (Always Active - Priority 0)
    final safetyAlert = SafetyService.checkSafety(query);
    if (safetyAlert != null) {
      return safetyAlert;
    }

    // CHECK CONNECTIVITY MODE
    final isOnline =
        Provider.of<ConnectivityProvider>(context, listen: false).isOnline;

    if (isOnline) {
      // === ONLINE MODE ===
      // STRICTLY use Online AI (or fallback to a generic message if it fails).
      // The user requested offline logic "should no longer apply".

      try {
        // Since we don't have a real API key, this mock service will likely fail or return mock data.
        // For this demo, let's assume it returns a "BlueGuide AI" response.
        final onlineResponse = await OnlineAIService.getResponse(query);

        return CoastalKnowledge(
          id: 'online_${DateTime.now().millisecondsSinceEpoch}',
          title: 'BlueGuide AI (Online)',
          description: onlineResponse,
          category: 'Online AI',
          verificationStatus: 'ai_generated',
          confidenceScore: 90,
          accessCount: 0,
          contributorId: 'openai_mock',
          createdAt: DateTime.now(),
        );
      } catch (e) {
        // If Online fails (e.g. API error), we tell the user we can't connect.
        // We do NOT fallback to offline DB because the user wanted strict separation.
        return CoastalKnowledge(
          id: 'online_error',
          title: 'Connection Error',
          description:
              "I'm in Online Mode but couldn't reach the server.\n\nError: $e\n\nTry switching to Offline Mode 🔴 to use the local database.",
          category: 'System',
          verificationStatus: 'system',
          confidenceScore: 0,
          accessCount: 0,
          contributorId: 'system',
          createdAt: DateTime.now(),
        );
      }
    } else {
      // === OFFLINE MODE ===
      // STRICTLY use Local Knowledge Base (JSON Rules).

      // 2. Exact/Keyword Match
      final offlineMatch = await OfflineAIService.getResponse(query);
      if (offlineMatch != null) {
        return offlineMatch;
      }

      // 3. Fuzzy Match
      final fuzzyMatch = await OfflineAIService.findFuzzyMatch(query);
      if (fuzzyMatch != null) {
        fuzzyMatch.description =
            "(I think you asked about this...)\n\n${fuzzyMatch.description}";
        return fuzzyMatch;
      }

      // 4. Offline Fallback
      return CoastalKnowledge(
        id: 'fallback_offline',
        title: 'I don\'t know that yet.',
        description:
            "I couldn't find an answer in my offline database.\n\nTry asking about 'Fish Production', 'Monsoon', or 'Chaakara'.",
        category: 'System',
        verificationStatus: 'system',
        confidenceScore: 0,
        accessCount: 0,
        contributorId: 'system',
        createdAt: DateTime.now(),
      );
    }
  }
}
