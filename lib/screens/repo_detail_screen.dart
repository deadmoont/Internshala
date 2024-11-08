import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RepoDetailPage extends StatelessWidget {
  final Map<String, dynamic> repo;

  const RepoDetailPage({Key? key, required this.repo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final files = repo['files'] as Map<String, dynamic>? ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text('Repository Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              repo['description']?.isNotEmpty == true
                  ? repo['description']
                  : 'No description available',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Files:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: files.keys.length,
                itemBuilder: (context, index) {
                  String filename = files.keys.elementAt(index);
                  Map<String, dynamic> file = files[filename];
                  String fileSize = _formatFileSize(file['size'] ?? 0);

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  file['filename'] ?? 'No filename',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Type: ${file['type'] ?? 'Unknown'}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'Size: $fileSize',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.open_in_new, color: Colors.blue),
                            onPressed: () {
                              final url = file['raw_url'] ?? '';
                              if (url.isNotEmpty) {
                                _launchURL(url);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Formats file size into a human-readable format (e.g., KB, MB)
  String _formatFileSize(int size) {
    if (size < 1024) {
      return '$size B';
    } else if (size < 1048576) {
      return '${(size / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(size / 1048576).toStringAsFixed(2)} MB';
    }
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
