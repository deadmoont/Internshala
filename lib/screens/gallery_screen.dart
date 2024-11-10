import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'full_screen_image.dart';

class GalleryScreen extends StatefulWidget {
  final void Function(String) onBookmarkToggle;
  final Set<String> bookmarkedPhotos;

  const GalleryScreen({
    super.key,
    required this.onBookmarkToggle,
    required this.bookmarkedPhotos,
  });

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<String>> _photos;

  // Local state to handle bookmarked photos within this screen
  late Set<String> _localBookmarkedPhotos;

  @override
  void initState() {
    super.initState();
    _photos = _apiService.fetchPhotos();
    _localBookmarkedPhotos = Set<String>.from(widget.bookmarkedPhotos);
  }

  void _toggleBookmark(String photoUrl) {
    setState(() {
      if (_localBookmarkedPhotos.contains(photoUrl)) {
        _localBookmarkedPhotos.remove(photoUrl);
      } else {
        _localBookmarkedPhotos.add(photoUrl);
      }
    });
    widget.onBookmarkToggle(photoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          'Gallery',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),

      body: FutureBuilder<List<String>>(
        future: _photos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No photos available'));
          }

          final photos = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.7,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photoUrl = photos[index];
              final isBookmarked = _localBookmarkedPhotos.contains(photoUrl);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(imageUrl: photoUrl),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Card(
                      color: Colors.grey[850],
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          photoUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : const Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.red,
                        ),
                        onPressed: () => _toggleBookmark(photoUrl),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
