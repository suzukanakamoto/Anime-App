import 'package:flutter/material.dart';
import 'package:anime_streaming_app/screens/anime_detail_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'bookmarks.dart'; // Import bookmarks

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isSearching = false;
  String _searchQuery = "";

  final List<String> featuredAnimeImages = [
    'https://cdn.myanimelist.net/images/anime/10/47347.jpg',
    'https://cdn.myanimelist.net/images/anime/1244/138851.jpg',
    'https://cdn.myanimelist.net/images/anime/1171/109222.jpg',
  ];

  final List<Map<String, String>> animeList = [
    {
      'title': 'Naruto',
      'image': 'https://cdn.myanimelist.net/images/anime/13/17405.jpg'
    },
    {
      'title': 'One Piece',
      'image': 'https://cdn.myanimelist.net/images/anime/6/73245.jpg'
    },
    {
      'title': 'Attack on Titan',
      'image': 'https://cdn.myanimelist.net/images/anime/10/47347.jpg'
    },
    {
      'title': 'Jujutsu Kaisen',
      'image': 'https://cdn.myanimelist.net/images/anime/1171/109222.jpg'
    },
    {
      'title': 'Demon Slayer',
      'image': 'https://cdn.myanimelist.net/images/anime/1286/99889.jpg'
    },
    {
      'title': 'Death Note',
      'image': 'https://cdn.myanimelist.net/images/anime/9/9453.jpg'
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Search filtering
  List<Map<String, String>> get _filteredAnimeList {
    if (_searchQuery.isEmpty) {
      return animeList;
    } else {
      return animeList
          .where((anime) => anime['title']!
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  // Toggle search bar in AppBar
  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchQuery = "";
    });
  }

  // Different views for each tab
  final List<Widget> _pages = [
    const HomePage(),
    const BookmarkPage(),
    const RecentPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search anime...',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
              )
            : const Text('Anime Streaming',
                style: TextStyle(color: Colors.white)),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: _stopSearch,
            )
          else
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: _startSearch,
            ),
        ],
        backgroundColor: Colors.black, // Set AppBar color to black
      ),
      body: _pages[_selectedIndex], // Show the selected page
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, // Set background color to black
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white), // Icon color is white
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark,
                color: Colors.white), // Icon color is white
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases_outlined,
                color: Colors.white), // Icon color is white
            label: 'New Anime',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Set selected item color
        unselectedItemColor: Colors.grey, // Unselected item color
        onTap: _onItemTapped,
      ),
    );
  }
}

// HomePage content
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeScreenState = context.findAncestorStateOfType<_HomeScreenState>();
    final List<Map<String, String>> filteredAnimeList =
        homeScreenState!._filteredAnimeList;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carousel Slider for Featured Anime
          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.8,
            ),
            items: homeScreenState.featuredAnimeImages.map((imageUrl) {
              return Container(
                margin: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // Anime List
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Popular Anime',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filteredAnimeList.length,
              itemBuilder: (context, index) {
                final anime = filteredAnimeList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnimeDetailScreen(
                          animeName: anime['title']!,
                          animeImageUrl: anime['image']!,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage(anime['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          anime['title']!,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// BookmarkPage content
class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return bookmarkedAnime.isEmpty
        ? const Center(
            child: Text(
              'No Bookmarks Yet!',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        : ListView.builder(
            itemCount: bookmarkedAnime.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.network(
                  bookmarkedAnime[index]['image']!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  bookmarkedAnime[index]['name']!,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnimeDetailScreen(
                        animeName: bookmarkedAnime[index]['name']!,
                        animeImageUrl: bookmarkedAnime[index]['image']!,
                      ),
                    ),
                  );
                },
              );
            },
          );
  }
}

// TrendingPage content
class RecentPage extends StatelessWidget {
  const RecentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'New Release Anime!',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
