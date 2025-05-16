import 'package:flutter/material.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSubscriptionsList(),
          _buildFilterChips(),
          Expanded(
            child: _buildVideosList(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Image.asset(
        'assets/images/youtube_logo.png',
        height: 24,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.cast, color: Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.black),
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

  Widget _buildSubscriptionsList() {
    final List<Map<String, String>> channels = [
      {
        'name': 'Like Nastya',
        'image': 'assets/images/channel1.jpg',
        'hasNew': 'true'
      },
      {
        'name': 'Bassera',
        'image': 'assets/images/channel2.jpg',
        'hasNew': 'true'
      },
      {
        'name': 'Alor Path',
        'image': 'assets/images/channel3.jpg',
        'hasNew': 'true'
      },
      {
        'name': 'Rain Drop',
        'image': 'assets/images/channel4.jpg',
        'hasNew': 'true'
      },
         {
        'name': 'Like Nastya',
        'image': 'assets/images/channel1.jpg',
        'hasNew': 'true'
      },
      {
        'name': 'Bassera',
        'image': 'assets/images/channel2.jpg',
        'hasNew': 'true'
      },
      {
        'name': 'Alor Path',
        'image': 'assets/images/channel3.jpg',
        'hasNew': 'true'
      },
      {
        'name': 'Rain Drop',
        'image': 'assets/images/channel4.jpg',
        'hasNew': 'true'
      },
         {
        'name': 'Like Nastya',
        'image': 'assets/images/channel1.jpg',
        'hasNew': 'true'
      },
      {
        'name': 'Bassera',
        'image': 'assets/images/channel2.jpg',
        'hasNew': 'true'
      },
      {
        'name': 'Alor Path',
        'image': 'assets/images/channel3.jpg',
        'hasNew': 'true'
      },
      {
        'name': 'Rain Drop',
        'image': 'assets/images/channel4.jpg',
        'hasNew': 'true'
      },
    ];

    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: channels.length + 1, // +1 for "All" button
        itemBuilder: (context, index) {
          if (index == channels.length) {
            return _buildAllButton();
          }
          return _buildChannelItem(channels[index]);
        },
      ),
    );
  }

  Widget _buildChannelItem(Map<String, String> channel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage(channel['image']!),
              ),
              if (channel['hasNew'] == 'true')
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            channel['name']!,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAllButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Center(
              child: Text(
                'All',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final List<String> filters = ['All', 'Today', 'Yesterday', 'This month', 'Continue'];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(filters[index]),
              selected: index == 0,
              onSelected: (bool selected) {},
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.grey[800],
              labelStyle: TextStyle(
                color: index == 0 ? Colors.white : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideosList() {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return _buildVideoItem();
      },
    );
  }

  Widget _buildVideoItem() {
    return Column(
      children: [
        Stack(
          children: [
            Image.asset(
              'assets/images/thumbnail.jpg',
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
            const Positioned(
              right: 8,
              bottom: 8,
              child: Chip(
                label: Text(
                  'SHORTS',
                  style: TextStyle(color: Colors.white, fontSize: 12),
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
                backgroundImage: AssetImage('assets/images/channel_avatar.png'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Heart Touching Nasheed #Shorts',
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
}