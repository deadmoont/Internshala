import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true, // Allows panning
          minScale: 0.5, // Minimum zoom-out level
          maxScale: 4.0, // Maximum zoom-in level
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
