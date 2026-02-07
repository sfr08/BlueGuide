import 'package:flutter/material.dart';
import '../models/coastal_knowledge.dart';
import '../services/hive_service.dart';
import '../services/firebase_contribution_service.dart';

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
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("📤 Submitting to cloud..."),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 1),
        ),
      );

      // Submit to Firebase
      final success = await FirebaseContributionService.submitContribution(
        title: _topicController.text.trim(),
        content: _infoController.text.trim(),
        source: _sourceController.text.trim(),
        category: 'Community Contribution',
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "✅ Contribution submitted! Waiting for admin approval.\n\nYou'll earn BlueCoins once approved."),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 4),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "❌ Failed to submit. Please check your internet connection."),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
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
