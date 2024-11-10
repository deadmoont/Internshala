import 'package:flutter/material.dart';

class RepoDetailPage extends StatelessWidget {
  final Map<String, dynamic> repo;

  const RepoDetailPage({Key? key, required this.repo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final files = repo['files'] as Map<String, dynamic>? ?? {};

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Repository Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              repo['description']?.isNotEmpty == true
                  ? repo['description']
                  : 'No description available',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Files:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
                    color: Colors.grey[850],
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.insert_drive_file,
                            color: Colors.blueAccent,
                            size: 30,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  file['filename'] ?? 'No filename',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Type: ${file['type'] ?? 'Unknown'}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Size: $fileSize',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
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

  String _formatFileSize(int size) {
    if (size < 1024) {
      return '$size B';
    } else if (size < 1048576) {
      return '${(size / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(size / 1048576).toStringAsFixed(2)} MB';
    }
  }
}


// void _launchURL(String url) async {
//   Uri uri = Uri.parse(url);
//
//   if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//     throw Exception('Could not launch $url');
//   }
// }

