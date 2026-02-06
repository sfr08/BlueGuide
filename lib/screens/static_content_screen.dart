import 'package:flutter/material.dart';

class StaticContentScreen extends StatelessWidget {
  final String title;
  final String content;

  const StaticContentScreen({
    super.key,
    required this.title,
    required this.content,
  });

  factory StaticContentScreen.privacy() {
    return const StaticContentScreen(
      title: "Privacy Policy",
      content:
          "BlueGuide respects your privacy.\n\nWe collect minimal data to provide you with coastal information. Your location data is used only for weather alerts and relevant fishing zone information.\n\nWe do not share your personal data with third parties without consent.",
    );
  }

  factory StaticContentScreen.help() {
    return const StaticContentScreen(
      title: "Help & Support",
      content:
          "How to use BlueGuide:\n\n1. Ask questions in the chat about sea safety, weather, or government schemes.\n2. Use the menu to access your earnings and history.\n3. Login to save your progress.\n\nContact support@blueguide.com for assistance.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
        child: Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                height: 1.6,
              ),
        ),
      ),
    );
  }
}
