import 'package:flutter/material.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int _blueCoins = 450;
  final List<Map<String, dynamic>> _coupons = [
    {
      "title": "Seaside Mart",
      "offer": "10% OFF",
      "cost": 100,
      "color": Colors.orange,
      "icon": Icons.shopping_basket,
    },
    {
      "title": "Kerala Cafe",
      "offer": "Free Chai",
      "cost": 50,
      "color": Colors.brown,
      "icon": Icons.coffee,
    },
    {
      "title": "Ocean Gear",
      "offer": "₹500 OFF",
      "cost": 500,
      "color": Colors.blue,
      "icon": Icons.anchor,
    },
    {
      "title": "Fish Market",
      "offer": "Priority Access",
      "cost": 200,
      "color": Colors.teal,
      "icon": Icons.storefront,
    },
  ];

  final List<Map<String, dynamic>> _history = [
    {"title": "Weather Contribution", "amount": "+50", "date": "Today"},
    {"title": "Fishing Zone Report", "amount": "+100", "date": "Yesterday"},
    {"title": "New User Bonus", "amount": "+300", "date": "Feb 5"},
  ];

  void _redeemCoupon(Map<String, dynamic> coupon) {
    if (_blueCoins >= coupon['cost']) {
      setState(() {
        _blueCoins -= (coupon['cost'] as int);
        _history.insert(0, {
          "title": "Redeemed: ${coupon['title']}",
          "amount": "-${coupon['cost']}",
          "date": "Just now"
        });
      });
      _showSuccessDialog(coupon);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Not enough Blue Coins!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog(Map<String, dynamic> coupon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("Coupon Redeemed!",
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(coupon['icon'], size: 48, color: coupon['color']),
            const SizedBox(height: 16),
            Text(
              "You got ${coupon['offer']} at ${coupon['title']}",
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Show this code at the shop:",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
              child: const Text(
                "BLUE-2024-X8Y",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Earnings"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // BALANCE CARD
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade900, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Available Balance",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.stars, color: Colors.amber, size: 32),
                      const SizedBox(width: 8),
                      Text(
                        "$_blueCoins",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "Blue Coins",
                    style: TextStyle(
                        color: Colors.amber, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // REDEEM SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Redeem Coupons",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _coupons.length,
                itemBuilder: (context, index) {
                  final coupon = _coupons[index];
                  return Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: coupon['color'].withOpacity(0.2),
                          child: Icon(coupon['icon'], color: coupon['color']),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          coupon['offer'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text(
                          coupon['title'],
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => _redeemCoupon(coupon),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            minimumSize: const Size(80, 30),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: Text(
                            "${coupon['cost']}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // HISTORY SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Recent Activity",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                final isNegative = item['amount'].toString().startsWith("-");
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'],
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            item['date'],
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 12),
                          ),
                        ],
                      ),
                      Text(
                        item['amount'],
                        style: TextStyle(
                          color: isNegative
                              ? Colors.redAccent
                              : Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
