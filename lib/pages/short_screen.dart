import 'package:flutter/material.dart';

import 'home_screen.dart';

class ShortsScreen extends StatefulWidget {
  const ShortsScreen({super.key});

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _shorts = [
    {
      'title':
          'DIY Toys | Satisfying And Relaxing | SADEK Tuts\nTiktok Compition | Fidget Trading #SADEK #Shorts tiktok',
      'author': 'SADEK Tuts',
      'likes': '245K',
      'comments': '952',
      'isSubscribed': false,
      'thumbnail': 'assets/images/short_thumbnail.jpg',
    },
    // Add more shorts data here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Shorts Video PageView
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: (index) {},
            itemCount: _shorts.length,
            itemBuilder: (context, index) {
              return _buildShortItem(_shorts[index]);
            },
          ),
          // Top Navigation
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortItem(Map<String, dynamic> shortData) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video/Thumbnail
        Image.asset(shortData['thumbnail'], fit: BoxFit.cover),

        // Right Side Actions
        Positioned(
          right: 16,
          bottom: 100,
          child: Column(
            children: [
              _buildActionButton(Icons.thumb_up_outlined, shortData['likes']),
              const SizedBox(height: 16),
              _buildActionButton(Icons.thumb_down_outlined, 'Dislike'),
              const SizedBox(height: 16),
              _buildActionButton(Icons.comment_outlined, shortData['comments']),
              const SizedBox(height: 16),
              _buildActionButton(Icons.share_outlined, 'Share'),
              const SizedBox(height: 16),
              _buildSoundButton(),
            ],
          ),
        ),

        // Bottom Info
        Positioned(
          left: 16,
          right: 72,
          bottom: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shortData['title'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: AssetImage(
                      'assets/images/profile_avatar.jpg',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    shortData['author'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('SUBSCRIBE'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildSoundButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.music_note, color: Colors.white, size: 24),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
