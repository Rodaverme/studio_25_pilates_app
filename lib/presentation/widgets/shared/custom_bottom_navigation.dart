import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  
  const CustomBottomNavigation({super.key, });



  int getCurrentIndex( BuildContext context ) {
    final String location = GoRouterState.of(context).uri.toString();

    switch(location) {
      case '/home':
        return 0;
      
      case '/calendar':
        return 1;

      case '/plans':
        return 2;

      case '/notifications':
        return 3;
      case '/perfil':
        return 4;
        
      
      default:
        return 0;
    }
  }


  

  void onItemTapped(BuildContext context, int index) {
   
    switch (index) {
      case 0:
        context.go('/Home');
        break;

      case 1:
        context.go('/calendar');
        break;
      case 2:
        context.go('/plans');
        break;
      case 3:
        context.go('/notifications');
        break;
      case 4:
        context.go('/perfil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      
      type: BottomNavigationBarType.fixed,
      currentIndex: getCurrentIndex(context),
      onTap: (value) => onItemTapped(context, value),
      elevation: 0,
      backgroundColor: Color.fromRGBO(228, 214, 188, 1),

      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'inicio'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Calendario',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_border),
          label: 'Planes',
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
