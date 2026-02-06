import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat_message.dart';
import '../widgets/chat_bubble.dart';
import '../services/decision_engine.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'static_content_screen.dart';
import 'rewards_screen.dart';
import 'contribute_screen.dart';
import 'profile_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(text: text.trim(), sender: MessageSender.user),
      );

      // TEMP AI RESPONSE (demo)
      _messages.add(
        ChatMessage(
          text:
              "This is a demo response. Offline and online AI logic will be connected here.",
          sender: MessageSender.ai,
        ),
      );
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        sender: MessageSender.user,
      ));
    });

    _controller.clear();

    // The Decision Engine handles all logic (Safety -> Offline -> Online -> Fallback)
    final knowledge = await DecisionEngine.processQuery(context, text);

    setState(() {
      _messages.add(ChatMessage(
        text: knowledge.description,
        sender: MessageSender.ai,
      ));
    });
  }

  void _startNewChat() {
    setState(() {
      _messages.clear();
    });
    Navigator.pop(context); // Close drawer
  }

  void _handleLogout(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.pop(context); // Close drawer
  }

  void _navigateTo(Widget screen) {
    Navigator.pop(context); // Close drawer first
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BlueGuide"),
        centerTitle: true,
        // The default leading icon is already a Hamburger (menu) when a Drawer is present.
        // We can explicitly define it if we want to customize the icon, but the default is correct.
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              if (auth.isLoggedIn) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: PopupMenuButton<String>(
                    offset: const Offset(0, 45),
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, size: 20, color: Colors.white),
                    ),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        // Value null so it doesn't close menu immediately if we want custom logic,
                        // but actually we want to tap it.
                        // Better to make it enabled and handle navigation.
                        value: 'profile',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(auth.name.isEmpty ? "User" : auth.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(auth.email.isEmpty ? "No Email" : auth.email,
                                style: const TextStyle(fontSize: 12)),
                            const SizedBox(height: 4),
                            const Text("Edit Profile",
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 10)),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, size: 20),
                            SizedBox(width: 8),
                            Text("Logout"),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (String value) {
                      if (value == 'logout') {
                        auth.logout();
                      } else if (value == 'profile') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProfileScreen()));
                      }
                    },
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Text("Login",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                );
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width *
            0.6, // "Full half screen" (approx 60%)
        backgroundColor: const Color(0xFF111827),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF0B0F1A),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue,
                    child: Text("🐠", style: TextStyle(fontSize: 28)),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "BlueGuide Menu",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.add, "New Chat", _startNewChat),
            _buildDrawerItem(Icons.history, "Chat History",
                () => _navigateTo(const HistoryScreen())),
            _buildDrawerItem(Icons.attach_money, "My Earnings",
                () => _navigateTo(const RewardsScreen())),
            _buildDrawerItem(Icons.settings, "Settings",
                () => _navigateTo(const SettingsScreen())),
            _buildDrawerItem(Icons.privacy_tip, "Privacy Policy",
                () => _navigateTo(StaticContentScreen.privacy())),
            _buildDrawerItem(Icons.help, "Help",
                () => _navigateTo(StaticContentScreen.help())),
            const Divider(color: Colors.white10),
            _buildDrawerItem(Icons.volunteer_activism, "Contribute",
                () => _navigateTo(const ContributeScreen())),
            const Divider(color: Colors.white10),
            _buildDrawerItem(
                Icons.logout, "Logout", () => _handleLogout(context)),
          ],
        ),
      ),
      body: Column(
        children: [
          // CHAT AREA
          Expanded(
            child: _messages.isEmpty
                ? _WelcomeView(onSuggestionSelected: _handleSubmitted)
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return ChatBubble(message: _messages[index]);
                    },
                  ),
          ),

          // INPUT BAR
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        color:
            const Color(0xFF0B0F1A), // Match background or be slightly lighter
        child: TextField(
          controller: _controller,
          minLines: 1,
          maxLines: 4,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Ask BlueGuide...",
            hintStyle: TextStyle(color: Colors.grey[600]),
            fillColor: const Color(0xFF1E293B), // Lighter input bg
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
              ),
              onPressed: _sendMessage,
            ),
          ),
          onSubmitted: (_) => _sendMessage(),
        ),
      ),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  final Function(String) onSuggestionSelected;

  const _WelcomeView({required this.onSuggestionSelected});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.blue.withOpacity(0.3), width: 2),
              ),
              child: const Text(
                "🐠", // The "Talking Fish"
                style: TextStyle(fontSize: 64),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Welcome to BlueGuide",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Your coastal knowledge assistant",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 48),
            // Example queries
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildSuggestionChip("🌊  Sea Safety"),
                _buildSuggestionChip("🎣  Fishing Zones"),
                _buildSuggestionChip("🌩️  Weather Alerts"),
                _buildSuggestionChip("🏛️  Gov Schemes"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String label) {
    return InkWell(
      onTap: () => onSuggestionSelected(label),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
