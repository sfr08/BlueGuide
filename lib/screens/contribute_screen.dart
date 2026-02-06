import 'package:flutter/material.dart';
import '../models/coastal_knowledge.dart';
import '../services/hive_service.dart';

class ContributeScreen extends StatefulWidget {
  const ContributeScreen({super.key});

  @override
  State<ContributeScreen> createState() => _ContributeScreenState();
}

class _ContributeScreenState extends State<ContributeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _infoController = TextEditingController();
  final _sourceController = TextEditingController();

  void _submitContribution() async {
    if (_formKey.currentState!.validate()) {
      // Create new knowledge entry
      final newKnowledge = CoastalKnowledge(
        id: 'contrib_${DateTime.now().millisecondsSinceEpoch}',
        title: _topicController.text.trim(),
        description: _infoController.text.trim(),
        category: 'Community Contribution',
        verificationStatus: 'community_verified',
        confidenceScore: 100, // Trusted for demo
        accessCount: 0,
        contributorId: HiveService.getUserProfile()?.name ?? 'Anonymous',
        createdAt: DateTime.now(),
      );

      print("DEBUG: Saving Contribution: ${newKnowledge.title}");

      // Save to Hive (Instant Learning!)
      await HiveService.cacheKnowledge(newKnowledge);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Contribution Added! The AI has learned this instantly."),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contribute Knowledge"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Share Your Wisdom",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                "Help preserve coastal knowledge by contributing information from experience, elders, or old texts.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),

              // TOPIC FIELD
              TextFormField(
                controller: _topicController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Topic",
                  hintText: "e.g., Weather Signs, Fishing Technique",
                  prefixIcon: Icon(Icons.topic),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a topic';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // INFO FIELD
              TextFormField(
                controller: _infoController,
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Knowledge / Information",
                  hintText: "Describe the knowledge in detail...",
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the information';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // SOURCE FIELD
              TextFormField(
                controller: _sourceController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Source / Authenticity",
                  hintText: "e.g., Grandfather, Old Manuscript, Experience",
                  prefixIcon: Icon(Icons.history_edu),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please cite your source';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // SUBMIT BUTTON
              ElevatedButton.icon(
                onPressed: _submitContribution,
                icon: const Icon(Icons.volunteer_activism),
                label: const Text("Contribute to Library"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
