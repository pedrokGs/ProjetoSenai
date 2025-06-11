import 'package:biblioteca/services/streak_service.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  int selectedIndex;
  CustomBottomNavBar({super.key, required this.selectedIndex});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      backgroundColor: Theme.of(context).colorScheme.primary,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Color(0xFF834d40),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Procurar',
          backgroundColor: Color(0xFF834d40),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chats',
          backgroundColor: Color(0xFF834d40),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_fire_department),
          label: 'Ofensiva',
          backgroundColor: Color(0xFF834d40),
        ),
      ],
      currentIndex: widget.selectedIndex, //New
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;

      switch (widget.selectedIndex) {
        case 0:
          Navigator.pushNamed(context, '/home');
          break;
        case 1:
          Navigator.pushNamed(context, '/pesquisar');
          break;
        case 2:
          Navigator.pushNamed(context, '/chatroom');
        case 3:
          navigateToStreak();
      }
    });
  }

  void navigateToStreak() async {
    final streak = await StreakService().getStreak();
    if (streak <= 1) {
      Navigator.pushNamed(context, '/ofensiva');
    } else {
      Navigator.pushNamed(context, '/ofensivamainpage');
    }
  }
}
