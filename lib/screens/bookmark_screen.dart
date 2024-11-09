import 'package:flutter/material.dart';

class BookmarkPage extends StatelessWidget {
  final List<String> bookmarkedPhotos;

  const BookmarkPage({super.key, required this.bookmarkedPhotos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarked Photos')),
      body: bookmarkedPhotos.isEmpty
          ? const Center(child: Text('No bookmarked photos'))
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
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                bookmarkedPhotos[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
