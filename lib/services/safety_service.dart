import '../models/coastal_knowledge.dart';

class SafetyService {
  static const List<Map<String, dynamic>> _safetyRules = [
    {
      "pattern": r"(cyclone|tsunami|storm|flood|hurricane|typhoon)",
      "response":
          "⚠️ **DANGER:** Severe weather alert keywords detected.\n\nIMMEDIATE ACTION:\n1. Secure your boat immediately.\n2. Do NOT go to sea.\n3. Listen to official radio/government alerts.\n4. Move to high ground if a Tsunami warning is issued.",
      "category": "Critical Warning"
    },
    {
      "pattern": r"(eat|cook).*(puffer|stonefish|jellyfish|unknown|strange)",
      "response":
          "⚠️ **SAFETY WARNING:** Do NOT eat unknown or dangerous marine life.\n\nMany species like Pufferfish or Stonefish contain lethal toxins that heat cannot destroy. If unsure, release it immediately.",
      "category": "Food Safety"
    },
    {
      "pattern": r"(bite|sting|poison).*(jellyfish|snake|stonefish)",
      "response":
          "🚑 **MEDICAL EMERGENCY:**\n\n1. Do NOT rub the wound.\n2. Rinse with vinegar or seawater (NOT fresh water).\n3. Immerse in hot water (45°C) if possible.\n4. Seek immediate medical attention.",
      "category": "First Aid"
    },
    {
      "pattern": r"(lost|stranded|engine fail|sinking)",
      "response":
          "🆘 **MAYDAY / EMERGENCY:**\n\n1. Wear Life Jackets immediately.\n2. Activate EPIRB/Beacon if available.\n3. Signal with flares or mirror.\n4. Call Coast Guard (1093 in India) or local authorities.",
      "category": "Emergency"
    }
  ];

  static CoastalKnowledge? checkSafety(String query) {
    final lowerQuery = query.toLowerCase();

    for (final rule in _safetyRules) {
      final regExp = RegExp(rule['pattern'] as String);
      if (regExp.hasMatch(lowerQuery)) {
        return CoastalKnowledge(
          id: 'safety_alert_${DateTime.now().millisecondsSinceEpoch}',
          title: rule['category'] as String,
          description: rule['response'] as String,
          category: 'Safety Alert',
          verificationStatus: 'system_critical',
          confidenceScore: 100,
          accessCount: 0,
          contributorId: 'system',
          createdAt: DateTime.now(),
        );
      }
    }
    return null;
  }
}
