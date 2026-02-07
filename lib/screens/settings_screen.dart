import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
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
      body: ListView(
        children: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return SwitchListTile(
                title: const Text("Dark Mode"),
                subtitle: Text(
                  themeProvider.isDarkMode ? "Enabled" : "Disabled",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                value: themeProvider.isDarkMode,
                onChanged: (val) => themeProvider.setDarkMode(val),
                secondary: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.blueGrey,
                ),
              );
            },
          ),
          SwitchListTile(
            title: const Text("Notifications"),
            value: _notifications,
            onChanged: (val) => setState(() => _notifications = val),
            secondary: const Icon(Icons.notifications, color: Colors.blueGrey),
          ),
          const Divider(color: Colors.white10),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.blueGrey),
            title: const Text("Language"),
            subtitle: Text(
              "English",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.white54),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
