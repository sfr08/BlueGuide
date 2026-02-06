import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/hive_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _bankController;
  late TextEditingController _ifscController;

  @override
  void initState() {
    super.initState();
    final currentProfile = HiveService.getUserProfile() ?? UserProfile.empty();

    _nameController = TextEditingController(text: currentProfile.name);
    _emailController = TextEditingController(text: currentProfile.email);
    _bankController =
        TextEditingController(text: currentProfile.bankAccountNumber);
    _ifscController = TextEditingController(text: currentProfile.ifscCode);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bankController.dispose();
    _ifscController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final newProfile = UserProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        bankAccountNumber: _bankController.text.trim(),
        ifscCode: _ifscController.text.trim(),
        // Preserve coins if existing, or 0 if new
        blueCoins: HiveService.getUserProfile()?.blueCoins ?? 0,
      );

      await HiveService.saveUserProfile(newProfile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Saved Successfully!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle("Personal Info"),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your name" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email Address",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter email" : null,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle("Bank Details (For Earnings)"),
              const SizedBox(height: 10),
              TextFormField(
                controller: _bankController,
                decoration: const InputDecoration(
                  labelText: "Account Number",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_balance),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter account number" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ifscController,
                decoration: const InputDecoration(
                  labelText: "IFSC Code",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.code),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter IFSC code" : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.save),
                label: const Text("Save & Update"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue[300],
      ),
    );
  }
}
