
import 'package:fixbee_partner/ui/custom_widget/bottom_nav_bar.dart';
import 'package:fixbee_partner/ui/screens/home.dart';
import 'package:fixbee_partner/ui/screens/profile.dart';

import 'package:fixbee_partner/ui/screens/wallet_screen.dart';
import 'package:flutter/material.dart';

import 'history.dart';

class NavigationScreen extends StatefulWidget {

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

const List<Widget> pages = [
  const Home(),
  const HistoryScreen(),
  const WalletScreen(),
  const Profile(),

];

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(
        onPageSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: pages[_currentIndex],
    );
  }
}
