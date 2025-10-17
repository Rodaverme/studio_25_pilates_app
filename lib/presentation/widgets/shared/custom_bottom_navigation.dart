import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/notifications/notifications_bloc.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  int getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    switch (location) {
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
    final notifications = context
        .watch<NotificationsBloc>()
        .state
        .notifications;

    // 👉 Solo las no leídas
    final int unreadCount = notifications.where((n) => !n.isRead).length;

    return BottomNavigationBar(
      
      selectedItemColor: AppColors.cafeNoir,
      selectedLabelStyle: TextStyle(color: AppColors.cafeNoir,fontWeight: FontWeight.bold),
      type: BottomNavigationBarType.fixed,
      currentIndex: getCurrentIndex(context),
      onTap: (value) => onItemTapped(context, value),
      elevation: 0,
      backgroundColor: const Color.fromRGBO(228, 214, 188, 1),

      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'inicio',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Calendario',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Planes',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_active),
              if (unreadCount >= 0) // 👈 Solo si hay no leídas
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$unreadCount', // 👈 Aquí va el número de no leídas
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          label: 'Mensajes',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_2_outlined),
          label: 'Perfil',
        ),
      ],
    );
  }
}
