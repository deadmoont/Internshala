import 'package:flutter/material.dart';

class BookmarkPage extends StatelessWidget {
  final List<String> bookmarkedPhotos;

  const BookmarkPage({super.key, required this.bookmarkedPhotos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Dark background color
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Bookmarked Photos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black, // Dark app bar background
      ),
      body: bookmarkedPhotos.isEmpty
          ? const Center(
        child: Text(
          'No bookmarked photos',
          style: TextStyle(color: Colors.white70), // Light text for visibility
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.7,
        ),
        itemCount: bookmarkedPhotos.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.grey[850], // Dark card color
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                bookmarkedPhotos[index],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  return progress == null
                      ? child
                      : const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
