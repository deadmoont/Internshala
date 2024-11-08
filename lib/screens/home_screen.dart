import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:internshala/screens/gallery_screen.dart';
import 'package:internshala/screens/repo_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  var _currentIndex = 0;

  final List<Widget> _pages = [
    const RepoScreen(),
    const GalleryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
              'View Vault',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
            ),
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(TablerIcons.brand_github),
            title: const Text("Repo-List"),
            selectedColor: Colors.purple,
            unselectedColor: Colors.black,
          ),
          SalomonBottomBarItem(
            icon: const Icon(TablerIcons.photo_search),
            title: const Text("Gallery"),
            selectedColor: Colors.pink,
          ),
        ],
      ),
    );
  }
}
