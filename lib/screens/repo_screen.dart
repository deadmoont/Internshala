import 'package:flutter/material.dart';
import 'package:internshala/screens/repo_detail_screen.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class RepoScreen extends StatefulWidget {
  const RepoScreen({super.key});

  @override
  State<RepoScreen> createState() => _RepoScreenState();
}

class _RepoScreenState extends State<RepoScreen> {
  late Future<List<Map<String, dynamic>>> _repos;

  @override
  void initState() {
    super.initState();
    _repos = ApiService().fetchPublicRepos();
  }

  String formatDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }

  void _showOwnerInfoDialog(BuildContext context, Map<String, dynamic> owner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Username',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                Text(
                  owner['login'] ?? 'Unknown User',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (owner['avatar_url'] != null)
                CircleAvatar(
                  backgroundImage: NetworkImage(owner['avatar_url']),
                  radius: 40,
                ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text('Followers', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(owner['followers']?.toString() ?? 'N/A'),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Following', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(owner['following']?.toString() ?? 'N/A'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Repos'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _repos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No repos available'));
          } else {
            final repos = snapshot.data!;
            return ListView.builder(
              itemCount: repos.length,
              itemBuilder: (context, index) {
                final repo = repos[index];
                final description = (repo['description'] as String?)?.isNotEmpty == true
                    ? repo['description']
                    : 'No description available';
                final comments = repo['comments'] ?? 0;
                final createdAt = formatDate(repo['created_at'] ?? '');
                final updatedAt = formatDate(repo['updated_at'] ?? '');
                final owner = repo['owner'] as Map<String, dynamic>?;

                return GestureDetector(
                  onLongPress: () {
                    if (owner != null) {
                      _showOwnerInfoDialog(context, owner);
                    }
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RepoDetailPage(repo: repo),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description', // Added a header for the description
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Comments: $comments',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 14, color: Colors.blueAccent),
                              const SizedBox(width: 5),
                              Text(
                                'Created: $createdAt',
                                style: const TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.update, size: 14, color: Colors.orangeAccent),
                              const SizedBox(width: 5),
                              Text(
                                'Updated: $updatedAt',
                                style: const TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
