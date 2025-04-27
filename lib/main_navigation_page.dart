import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_bustix_app/app/modules/beranda/views/beranda_view.dart';
import 'package:my_bustix_app/app/modules/home/views/home_view.dart';
import 'package:my_bustix_app/app/modules/profile/views/profile_view.dart';


class MainNavigationPage extends StatefulWidget {
  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    BerandaView(),  // kalau ada
    HomeView(),       // modul beranda/home
    ProfileView(),    // modul profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cari Tiket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
