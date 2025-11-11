import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;

  const NavBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Get.offAllNamed('/home');
            break;

          case 1:
            Get.offAllNamed('/goals');
            break;
          case 2:
            Get.offAllNamed('/schedule');
       
          case 3:
            Get.offAllNamed('/dashboard');
            break;
             case 4:
            Get.offAllNamed('/profile');
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

        BottomNavigationBarItem(
          icon: Icon(Icons.track_changes),
          label: 'Goals',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),

      ],
    );
  }
}

// Usage:
// bottomNavigationBar: NavBar(currentIndex: 0), // for home
// bottomNavigationBar: NavBar(currentIndex: 1), // for dashboard
// bottomNavigationBar: NavBar(currentIndex: 2), // for goals
// bottomNavigationBar: NavBar(currentIndex: 3), // for profile
