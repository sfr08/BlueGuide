import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyItems = [
      "Fishing Spots in Kerala",
      "Weather Alert: Cyclone Warning",
      "Govt Scheme Application Help",
      "Safety Equipment Checklist",
      "Market Prices Today",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat History"),
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
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: historyItems.length,
        separatorBuilder: (_, __) => const Divider(color: Colors.white10),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.chat_bubble_outline, color: Colors.blue),
            title: Text(historyItems[index]),
            subtitle: Text(
              "Yesterday",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              // Mock action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Loading past chat...")),
              );
            },
          );
        },
      ),
    );
  }
}
