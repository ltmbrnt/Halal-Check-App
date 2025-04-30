// lib/main_navigation_screen.dart
import 'package:flutter/material.dart';
import '../product/library_categories_page.dart';
import '../scanner/scanner_page.dart';
import '../chatbot/chatbot_page.dart';
import '../profile/profile.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0; // Default to the first tab, which will be Library Categories Page

  final GlobalKey<ScannerPageState> _scannerKey = GlobalKey<ScannerPageState>();

  late final List<Widget> _screens = [
    const LibraryCategoriesPage(), // Main page is now the Library Categories Page
    ScannerPage(key: _scannerKey), // ScannerPage will be accessible from BottomNavigationBar
    const HomeScreen(), // Chatbot Page
    const ProfilePage(), // Profile Page
  ];

  final List<IconData> _icons = [
    Icons.menu_book, // Library icon
    Icons.qr_code_scanner, // Scan icon for ScannerPage
    Icons.chat, // Chatbot icon
    Icons.person, // Profile icon
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.lightGreen,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() => _currentIndex = index);

          // If "Scan" tab is clicked, navigate to ScannerPage and trigger scanning
          if (index == 1) {
            _scannerKey.currentState?.startScanning();
          }
        },
        items: List.generate(_icons.length, (index) {
          final bool isActive = _currentIndex == index;
          return BottomNavigationBarItem(
            icon: isActive
                ? Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.lightGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(_icons[index], color: Colors.white),
            )
                : Icon(_icons[index]),
            label: "",
          );
        }),
      ),
    );
  }
}



