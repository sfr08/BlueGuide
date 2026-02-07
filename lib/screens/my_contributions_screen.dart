import 'package:flutter/material.dart';
import '../services/firebase_contribution_service.dart';

class MyContributionsScreen extends StatefulWidget {
  const MyContributionsScreen({super.key});

  @override
  State<MyContributionsScreen> createState() => _MyContributionsScreenState();
}

class _MyContributionsScreenState extends State<MyContributionsScreen> {
  List<Map<String, dynamic>> _contributions = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadContributions();
  }

  Future<void> _loadContributions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final contributions =
          await FirebaseContributionService.getUserContributions();
      setState(() {
        _contributions = contributions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load contributions: $e';
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'pending':
      default:
        return Icons.hourglass_empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Contributions'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadContributions,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(_errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadContributions,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _contributions.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.assignment_outlined,
                                size: 80, color: Colors.grey[600]),
                            const SizedBox(height: 20),
                            Text('No Contributions Yet',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700])),
                            const SizedBox(height: 10),
                            Text(
                                'Share your coastal knowledge to help the community!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600])),
                            const SizedBox(height: 30),
                            ElevatedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.add),
                              label: const Text('Contribute Now'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadContributions,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _contributions.length,
                        itemBuilder: (context, index) {
                          final contribution = _contributions[index];
                          final status = contribution['status'] ?? 'pending';
                          final title = contribution['title'] ?? 'Untitled';
                          final content = contribution['content'] ?? '';
                          final submittedAt = contribution['submittedAt'];

                          String dateStr = 'Unknown';
                          if (submittedAt != null) {
                            try {
                              final date = submittedAt.toDate();
                              dateStr =
                                  '${date.day}/${date.month}/${date.year}';
                            } catch (e) {
                              dateStr = 'Invalid date';
                            }
                          }

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(title,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(status),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(_getStatusIcon(status),
                                                size: 16, color: Colors.white),
                                            const SizedBox(width: 4),
                                            Text(status.toUpperCase(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(content,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[300])),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today,
                                          size: 14, color: Colors.grey[500]),
                                      const SizedBox(width: 4),
                                      Text('Submitted: $dateStr',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[500])),
                                      if (status.toLowerCase() ==
                                          'approved') ...[
                                        const Spacer(),
                                        Icon(Icons.stars,
                                            size: 16, color: Colors.amber[400]),
                                        const SizedBox(width: 4),
                                        Text('+100 BlueCoins',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber[400])),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
