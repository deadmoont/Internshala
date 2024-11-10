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
          backgroundColor: Colors.grey[850],
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Username',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70),
              ),
              Text(
                owner['login'] ?? 'Unknown User',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ],
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
                      const Text(
                        'Followers',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
                      ),
                      Text(
                        owner['followers']?.toString() ?? 'N/A',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Following',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
                      ),
                      Text(
                        owner['following']?.toString() ?? 'N/A',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.blueAccent),
              ),
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
      backgroundColor: Colors.black, // Set background color to black
      appBar: AppBar(
        backgroundColor: Colors.black87, // Set AppBar color to dark
        title: const Text(
          'Public Repos',
          style: TextStyle(color: Colors.white), // Set title text color to white
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _repos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No repos available', style: TextStyle(color: Colors.white)));
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
                    color: Colors.grey[850], // Set card color to dark grey
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blueGrey.withOpacity(0.3), Colors.black.withOpacity(0.3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.info, color: Colors.blue, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Set text color to white
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70, // Adjust text color for readability
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
                              const Icon(Icons.calendar_today, size: 16, color: Colors.blueAccent),
                              const SizedBox(width: 5),
                              Text(
                                'Created: $createdAt',
                                style: const TextStyle(fontSize: 14, color: Colors.white70),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.update, size: 16, color: Colors.orangeAccent),
                              const SizedBox(width: 5),
                              Text(
                                'Updated: $updatedAt',
                                style: const TextStyle(fontSize: 14, color: Colors.white70),
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
