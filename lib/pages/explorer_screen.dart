import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryGrid(),
            const SizedBox(height: 20),
            _buildTrendingSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/logo.png'),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.cast, color: Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined, color: Colors.black),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: const Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/profile.png'),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 2.5,
        children: [
          _buildCategoryCard(
            icon: Icons.local_fire_department,
            title: 'Trending',
            gradient: const LinearGradient(
              colors: [Colors.orange, Colors.red],
            ),
          ),
          _buildCategoryCard(
            icon: Icons.music_note,
            title: 'Music',
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.lightBlue],
            ),
          ),
          _buildCategoryCard(
            icon: Icons.sports_esports,
            title: 'Gaming',
            gradient: const LinearGradient(
              colors: [Colors.green, Colors.lightGreen],
            ),
          ),
          _buildCategoryCard(
            icon: Icons.article,
            title: 'News',
            gradient: const LinearGradient(
              colors: [Colors.indigo, Colors.blue],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String title,
    required Gradient gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Trending videos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return _buildVideoCard(
              thumbnail: 'assets/images/video_thumbnail.png',
              duration: '54:48',
              title: 'Build it in Figma: Create a Design System — Foundations',
              channel: 'Figma',
              views: '44K',
              timeAgo: '4 months ago',
            );
          },
        ),
      ],
    );
  }

  Widget _buildVideoCard({
    required String thumbnail,
    required String duration,
    required String title,
    required String channel,
    required String views,
    required String timeAgo,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                thumbnail,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  color: Colors.black,
                  child: Text(
                    duration,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const Positioned(
                left: 8,
                top: 8,
                child: Chip(
                  label: Text(
                    'LIVE',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/channel_logo.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$channel • $views views • $timeAgo',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: 1,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline, size: 40),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.subscriptions),
          label: 'Subscription',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_library),
          label: 'Library',
        ),
      ],
    );
  }
}