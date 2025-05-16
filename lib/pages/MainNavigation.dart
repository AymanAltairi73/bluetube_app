import 'package:flutter/material.dart';
import 'package:bluetube_app/pages/home_screen.dart';
import 'LibraryScreen.dart';
import 'SubscriptionScreen.dart';
import 'UploadScreen.dart';
import 'short_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const ShortsScreen(),
    const UploadScreen(),
    const SubscriptionScreen(),
    const LibraryScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      _showUploadOptions();
      return;
    }
    
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.video_call),
                title: const Text('Upload Video'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.short_text),
                title: const Text('Create Short'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.live_tv),
                title: const Text('Go Live'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // تحقق مما إذا كانت الشاشة الحالية هي شاشة Shorts
    bool isShortScreen = _selectedIndex == 1;

    return Scaffold(
      body: _screens[_selectedIndex],
      // إظهار شريط التنقل السفلي فقط إذا لم تكن في شاشة Shorts
      bottomNavigationBar: isShortScreen
          ? null
          : BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.play_circle_outline),
                  label: 'Shorts',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline, size: 40),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.subscriptions_outlined),
                  label: 'Subscription',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.video_library_outlined),
                  label: 'Library',
                ),
              ],
            ),
    );
  }
}