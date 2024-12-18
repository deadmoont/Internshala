import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:internshala/screens/gallery_screen.dart';
import 'package:internshala/screens/repo_screen.dart';
import 'package:internshala/screens/bookmark_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  var _currentIndex = 0;
  final Set<String> _bookmarkedPhotos = {};

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      const RepoScreen(),
      GalleryScreen(
        onBookmarkToggle: _toggleBookmark,
        bookmarkedPhotos: _bookmarkedPhotos,
      ),
    ]);
  }

  void _toggleBookmark(String photoUrl) {
    setState(() {
      if (_bookmarkedPhotos.contains(photoUrl)) {
        _bookmarkedPhotos.remove(photoUrl);
      } else {
        _bookmarkedPhotos.add(photoUrl);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'View Vault',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: const Icon(
                  Icons.bookmark,
                  color: Colors.redAccent,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookmarkPage(
                        bookmarkedPhotos: _bookmarkedPhotos.toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: Colors.black87,
        selectedItemColor: Colors.purpleAccent,
        unselectedItemColor: Colors.white60,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(TablerIcons.brand_github),
            title: const Text("Repo-List"),
            selectedColor: Colors.purpleAccent,
          ),
          SalomonBottomBarItem(
            icon: const Icon(TablerIcons.photo_search),
            title: const Text("Gallery"),
            selectedColor: Colors.pinkAccent,
          ),
        ],
      ),
    );
  }
}
