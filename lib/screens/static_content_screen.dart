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
      content: """BlueGuide Privacy Policy

Last Updated: February 2026

1. INTRODUCTION
BlueGuide respects your privacy and is committed to protecting your personal information. This privacy policy explains how we collect, use, and safeguard your data.

2. DATA COLLECTION
We collect minimal data necessary to provide coastal information services:
• Location data (for weather alerts and fishing zone information)
• User account information (name, email, phone number)
• Chat history and queries
• Device information and usage statistics
• Contribution data (if you share coastal knowledge)

3. DATA USAGE
Your data is used exclusively to:
• Provide personalized coastal information
• Send weather alerts and safety notifications
• Award BlueCoins for contributions
• Improve our AI assistant's accuracy
• Analyze usage patterns for service enhancement

4. DATA SHARING
We do NOT share your personal data with third parties without explicit consent, except:
• When required by law or legal authorities
• With trusted service providers (under strict confidentiality agreements)
• Aggregated, anonymized data for research purposes

5. ⚠️ DATA AUTHENTICITY DISCLAIMER
IMPORTANT: BlueGuide aggregates information from multiple sources including user contributions, government databases, and third-party APIs.

• We make NO GUARANTEES about the accuracy, completeness, or timeliness of any information provided
• Information may be outdated, incorrect, or incomplete
• User-contributed content is NOT verified or validated by BlueGuide
• Weather data and fishing zone information should be cross-verified with official sources

6. ⚠️ LIMITATION OF LIABILITY
BlueGuide is NOT RESPONSIBLE for:
• Any decisions made based on information from our platform
• Consequences arising from the use or misuse of data
• Loss, injury, damage, or harm resulting from reliance on our information
• Accuracy of user-contributed content
• Third-party data accuracy or availability

You use BlueGuide services AT YOUR OWN RISK. Always verify critical information with official government authorities before making important decisions.

7. DATA SECURITY
We implement industry-standard security measures to protect your data. However, no system is 100% secure, and we cannot guarantee absolute security.

8. YOUR RIGHTS
You have the right to:
• Access your personal data
• Request data correction or deletion
• Opt-out of promotional communications
• Withdraw consent at any time

9. CHILDREN'S PRIVACY
BlueGuide is not intended for users under 13 years of age. We do not knowingly collect data from children.

10. CHANGES TO POLICY
We may update this policy periodically. Continued use of BlueGuide constitutes acceptance of any changes.

11. CONTACT
For privacy concerns or data requests, contact:
Email: privacy@blueguide.com
Phone: +91-XXX-XXX-XXXX

By using BlueGuide, you acknowledge that you have read, understood, and agree to this Privacy Policy and accept all associated risks.""",
    );
  }

  factory StaticContentScreen.help() {
    return const StaticContentScreen(
      title: "Help & Support",
      content: """GETTING STARTED

Ask Questions
Type your question in the chat to get help with sea safety, weather alerts, fishing zones, government schemes, coastal ecology, and emergency procedures.

Create an Account
Login to save your chat history, earn rewards, track contributions, and access personalized alerts.

Navigation
• New Chat - Start a fresh conversation
• Chat History - View past conversations
• Contribute - Share your coastal knowledge
• My Earnings - Check BlueCoins balance
• Settings - Customize your experience


HOW TO CONTRIBUTE

Share your coastal expertise and earn BlueCoins!

What to Contribute
• Local fishing spots and seasonal patterns
• Traditional fishing techniques
• Weather prediction methods
• Safety tips and emergency procedures
• Marine species identification
• Local regulations and restrictions
• Tide patterns and coastal conditions
• Government scheme experiences
• Equipment recommendations

Contribution Process
1. Tap "Contribute" in the menu
2. Choose a category
3. Write clear, accurate information
4. Add photos if available
5. Submit for review
6. Earn 10-50 BlueCoins once approved

Guidelines
• Be accurate and truthful
• Share practical, useful information
• Write in clear, simple language
• Include specific details
• Respect local communities
• No illegal or harmful content


REWARDS SYSTEM

Earn BlueCoins
• Make valuable contributions
• Ask quality questions
• Help other users
• Daily login streaks
• Complete challenges

Redeem For
• Fishing gear discounts
• Fuel coupons
• Government service fee waivers
• Mobile recharge vouchers


TIPS FOR BETTER RESULTS

• Ask specific, detailed questions
• Enable location for accurate weather alerts
• Review chat history for past conversations
• Verify critical information with officials
• Contribute regularly to earn more
• Enable notifications for safety alerts


TROUBLESHOOTING

Problem: AI not responding
Solution: Check internet connection and restart app

Problem: Login issues
Solution: Verify phone number/email and request new OTP

Problem: BlueCoins not credited
Solution: Wait 24-48 hours for review approval

Problem: Incorrect information
Solution: Report via feedback and verify with official sources


CONTACT SUPPORT

Email: support@blueguide.com
Phone: +91-XXX-XXX-XXXX
Hours: Monday-Saturday, 9 AM - 6 PM IST

WhatsApp: +91-XXX-XXX-XXXX
Telegram: @BlueGuideSupport


IMPORTANT NOTICE

Always verify critical safety information with official coastal guard and fisheries authorities. BlueGuide is a knowledge-sharing platform, not a substitute for official guidance.

Stay safe!""",
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
