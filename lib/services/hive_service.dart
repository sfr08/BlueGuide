import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive_flutter/hive_flutter.dart';
import '../models/coastal_knowledge.dart';
import '../models/user_profile.dart';

class HiveService {
  static const String knowledgeBoxName = 'knowledge_box';
  static const String userBoxName = 'user_box';

  static Box<CoastalKnowledge> get knowledgeBox =>
      Hive.box<CoastalKnowledge>(knowledgeBoxName);

  static Box<UserProfile> get userBox => Hive.box<UserProfile>(userBoxName);

  static Future init() async {
    await Hive.initFlutter();

    // Check if adapters are registered to avoid errors on hot restart (if not handled by hive_flutter internally)
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CoastalKnowledgeAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserProfileAdapter());
    }

    await Hive.openBox<CoastalKnowledge>(knowledgeBoxName);
    await Hive.openBox<UserProfile>(userBoxName);

    await _seedKnowledgeBase();
  }

  static Future<void> _seedKnowledgeBase() async {
    final box = knowledgeBox;
    print("DEBUG: Checking Knowledge Box... Count: ${box.length}");

    // Force re-seeding logic to ensure custom data is loaded
    // In a real app we might check a version flag.
    // For now, we will verify if 'custom_data_loaded' marker exists or just clear and reload if count is low/default.

    // Simplification: Let's read the custom file. If it parses, we UPSERT it.

    print("DEBUG: Starting Custom Seed Process...");
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/custom_data.json');
      print("DEBUG: Custom JSON Loaded. Length: ${jsonString.length}");

      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      if (jsonMap.containsKey('chatbot_data')) {
        final List<dynamic> jsonList = jsonMap['chatbot_data'];
        print("DEBUG: Found 'chatbot_data' with ${jsonList.length} items.");

        // We will upsert these.
        // NOTE: Typically valid to clear purely cached data if we want strict sync
        // box.clear();

        for (var item in jsonList) {
          // Generate ID from question hash to be consistent
          final String id = "q_${item['question'].hashCode}";

          // Create rich description by appending keywords to answer
          // This helps the fuzzy search find it even if the question isn't exact
          // UPDATE: User requested to hide keywords.
          final String combinedDesc = item['answer'];

          final knowledge = CoastalKnowledge(
            id: id,
            title: item['question'],
            description: combinedDesc,
            category: item['category'] ?? 'General',
            verificationStatus: 'verified',
            confidenceScore: 100,
            accessCount: 0,
            contributorId: 'system_custom',
            createdAt: DateTime.now(),
          );
          await box.put(knowledge.id, knowledge);
        }
        print(
            "DEBUG: SUCCESS! Custom data merged. Total entries: ${box.length}");
      }
    } catch (e) {
      print("DEBUG: Custom data load skipped or failed: $e");
      // Fallback to original seed ONLY if box is empty
      if (box.isEmpty) {
        await _seedOriginalFallback();
      }
    }
  }

  static Future<void> _seedOriginalFallback() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/knowledge_base.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      for (var item in jsonList) {
        // ... (simple mapping as before)
        final knowledge = CoastalKnowledge(
          id: item['id'],
          title: item['title'],
          description: item['description'],
          category: item['category'],
          verificationStatus: item['verificationStatus'],
          confidenceScore: item['confidenceScore'],
          accessCount: item['accessCount'],
          contributorId: item['contributorId'],
          createdAt: DateTime.parse(item['createdAt']),
        );
        await HiveService.knowledgeBox.put(knowledge.id, knowledge);
      }
    } catch (e) {
      print("Fallback seed failed: $e");
    }
  }

  /// Save or Update User Profile
  static Future<void> saveUserProfile(UserProfile profile) async {
    await userBox.put('current_user', profile);
  }

  /// Get User Profile
  static UserProfile? getUserProfile() {
    return userBox.get('current_user');
  }

  /// Cache or Add Knowledge
  static Future<void> cacheKnowledge(CoastalKnowledge knowledge) async {
    await knowledgeBox.put(knowledge.id, knowledge);

    // Simple LRU-ish cleanup if too big
    if (knowledgeBox.length > 500) {
      // Just delete the first one for now (simplification)
      knowledgeBox.deleteAt(0);
    }
  }
}
