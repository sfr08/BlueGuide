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

    // TEMP DEBUG: Force clear to ensure seed happens if it looks empty or wrong
    // if (box.isEmpty) { ... }

    if (box.isNotEmpty) {
      print("DEBUG: Box already seeded. Skipping JSON load.");
      return;
    }

    print("DEBUG: Starting Seed Process...");
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/knowledge_base.json');
      print("DEBUG: JSON Loaded. Length: ${jsonString.length}");

      final List<dynamic> jsonList = json.decode(jsonString);
      print("DEBUG: JSON Parsed. Items: ${jsonList.length}");

      for (var item in jsonList) {
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
        await box.put(knowledge.id, knowledge);
      }
      print(
          "DEBUG: SUCCESS! Knowledge Base seeded with ${box.length} entries.");
    } catch (e, stack) {
      print("DEBUG ERROR seeding knowledge base: $e");
      print(stack);
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
