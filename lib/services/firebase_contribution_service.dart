import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/coastal_knowledge.dart';
import '../services/hive_service.dart';

/// Service for submitting contributions to Firebase Firestore
class FirebaseContributionService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Submit a new contribution to Firebase (pending admin approval)
  static Future<bool> submitContribution({
    required String title,
    required String content,
    required String source,
    required String category,
  }) async {
    try {
      final user = HiveService.getUserProfile();
      final contributorName = user?.name ?? 'Anonymous';
      final contributorEmail = user?.email ?? 'anonymous@blueguide.app';

      // Create contribution document
      final contributionData = {
        'title': title,
        'content': content,
        'source': source,
        'category': category,
        'contributorName': contributorName,
        'contributorEmail': contributorEmail,
        'status': 'pending', // pending, approved, rejected
        'submittedAt': FieldValue.serverTimestamp(),
        'pointsAwarded': 0,
        'viewCount': 0,
        'helpfulCount': 0,
      };

      // Add to pending_contributions collection
      await _firestore
          .collection('pending_contributions')
          .add(contributionData);

      print('✅ Contribution submitted to Firebase: $title');
      return true;
    } catch (e) {
      print('❌ Error submitting contribution: $e');
      return false;
    }
  }

  /// Get all contributions by current user (pending + approved)
  static Future<List<Map<String, dynamic>>> getUserContributions() async {
    try {
      final user = HiveService.getUserProfile();
      print('🔍 User profile: ${user?.name} <${user?.email}>');

      if (user == null) {
        print('⚠️ No user profile found, using anonymous email');
        // Use anonymous email as fallback
        return _getContributionsByEmail('anonymous@blueguide.app');
      }

      return _getContributionsByEmail(user.email);
    } catch (e) {
      print('❌ Error fetching user contributions: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> _getContributionsByEmail(
      String email) async {
    try {
      print('🔍 Querying contributions for email: $email');

      final List<Map<String, dynamic>> allContributions = [];

      // Fetch pending contributions
      print('📥 Fetching pending contributions...');
      final pendingSnapshot = await _firestore
          .collection('pending_contributions')
          .where('contributorEmail', isEqualTo: email)
          .get();

      print('📊 Found ${pendingSnapshot.docs.length} pending contributions');
      for (var doc in pendingSnapshot.docs) {
        allContributions.add({
          'id': doc.id,
          ...doc.data(),
        });
      }

      // Fetch approved contributions
      print('📥 Fetching approved contributions...');
      final approvedSnapshot = await _firestore
          .collection('approved_knowledge')
          .where('contributorEmail', isEqualTo: email)
          .get();

      print('📊 Found ${approvedSnapshot.docs.length} approved contributions');
      for (var doc in approvedSnapshot.docs) {
        allContributions.add({
          'id': doc.id,
          ...doc.data(),
        });
      }

      // Sort by submission date (newest first)
      allContributions.sort((a, b) {
        final aTime = a['submittedAt'] ?? a['approvedAt'];
        final bTime = b['submittedAt'] ?? b['approvedAt'];
        if (aTime == null || bTime == null) return 0;
        return (bTime as Timestamp).compareTo(aTime as Timestamp);
      });

      print('✅ Total contributions found: ${allContributions.length}');
      return allContributions;
    } catch (e) {
      print('❌ Error in _getContributionsByEmail: $e');
      return [];
    }
  }

  /// Sync approved knowledge from Firebase to local Hive
  static Future<void> syncApprovedKnowledge() async {
    try {
      final snapshot = await _firestore
          .collection('approved_knowledge')
          .orderBy('approvedAt', descending: true)
          .limit(100) // Limit to most recent 100
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final knowledge = CoastalKnowledge(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['content'] ?? '',
          category: data['category'] ?? 'Community Contribution',
          verificationStatus: 'admin_verified',
          confidenceScore: 100,
          accessCount: data['viewCount'] ?? 0,
          contributorId: data['contributorName'] ?? 'Community',
          createdAt:
              (data['approvedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );

        await HiveService.cacheKnowledge(knowledge);
      }

      print('✅ Synced ${snapshot.docs.length} approved entries from Firebase');
    } catch (e) {
      print('❌ Error syncing approved knowledge: $e');
    }
  }
}
