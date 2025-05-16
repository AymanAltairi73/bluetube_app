import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildCategories(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildMainVideo(),
                  _buildShortsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
     // bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Image.asset(
            'assets/images/youtube_logo.png',
            height: 24,
          ),
        ],
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
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _buildChip('Explore', Icons.explore),
          _buildChip('All', null, selected: true),
          _buildChip('Mixes', null),
          _buildChip('Music', null),
          _buildChip('Graphic', null),
        ],
      ),
    );
  }

  Widget _buildChip(String label, IconData? icon, {bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        backgroundColor: selected ? Colors.black : Colors.grey[200],
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: 16, color: selected ? Colors.white : Colors.black),
            if (icon != null) const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainVideo() {
    return Column(
      children: [
        Image.asset(
          'assets/images/thumbnail.jpg',
          width: double.infinity,
          height: 220,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/channel_avatar.png'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'The Beauty of Existence - Heart Touching Nasheed',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '19,210,251 views • Jul 1, 2016',
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
    );
  }

  Widget _buildShortsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Image.asset('assets/images/shorts_icon.png', height: 20),
              const SizedBox(width: 8),
              const Text(
                'Shorts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                ' BETA',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage('assets/images/short_${index + 1}.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'DIY Toys | Satisfying And Relaxing | DIY Tiktok Compilation..',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '24M views',
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget _buildBottomNavBar() {
  //   return BottomNavigationBar(
  //     type: BottomNavigationBarType.fixed,
  //     selectedItemColor: Colors.black,
  //     unselectedItemColor: Colors.grey,
  //     currentIndex: 0,
  //     items: const [
  //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
  //       BottomNavigationBarItem(icon: Icon(Icons.play_circle_outline), label: 'Shorts'),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.add_circle_outline, size: 40),
  //         label: '',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.subscriptions_outlined),
  //         label: 'Subscription',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.video_library_outlined),
  //         label: 'Library',
  //       ),
  //     ],
  //   );
  // }
}