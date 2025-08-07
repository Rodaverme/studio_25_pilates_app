import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  const CustomBottomNavigation({super.key, required this.currentIndex});

  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home-screen/0');
        break;

      case 1:
        context.go('/home-screen/1');
        break;
      case 2:
        context.go('/home-screen/2');
        break;
      case 3:
        context.go('/home-screen/3');
        break;
      case 4:
        context.go('/home-screen/4');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (value) => onItemTapped(context, value),
      elevation: 0,

      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'inicio'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Calendario',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_border),
          label: 'Favoritos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_active_outlined),
          label: 'Notificaciones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2_outlined),
          label: 'Perfil',
        ),
      ],
    );
  }
}
