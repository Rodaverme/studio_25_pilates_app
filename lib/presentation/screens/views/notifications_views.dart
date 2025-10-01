import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // 👈 para formatear la fecha
import 'package:studio_25_pilates_app/domain/entities/push_message.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/notifications_datasource_impl.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/notifications/notifications_bloc.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type2.dart';

class NotificationsViews extends StatefulWidget {
  const NotificationsViews({super.key});

  @override
  State<NotificationsViews> createState() => _NotificationsViewsState();
}

class _NotificationsViewsState extends State<NotificationsViews> {
  @override
  void initState() {
    super.initState();
    // 👉 Cargar las notificaciones guardadas en backend
    context.read<NotificationsBloc>().add(LoadNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/Logo6.png', fit: BoxFit.cover),
          ),
          const _NotificationView(),
        ],
      ),
    );
  }
}

class _NotificationView extends StatelessWidget {
  const _NotificationView();

  @override
  Widget build(BuildContext context) {
    final notifications = context
        .watch<NotificationsBloc>()
        .state
        .notifications;

    if (context.watch<NotificationsBloc>().state.statusNotification ==
        NotificationsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (notifications.isEmpty) {
      return const Center(child: Text("No hay notificaciones"));
    }

    // 👉 Agrupamos las notificaciones por fecha (dd/MM/yyyy)
    final grouped = <String, List<PushMessage>>{};
    final formatter = DateFormat('dd/MM/yyyy');

    for (var n in notifications) {
      final dateKey = formatter.format(n.sentDate);
      grouped.putIfAbsent(dateKey, () => []).add(n);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: ListView(
        children: grouped.entries.map((entry) {
          final date = entry.key;
          final notifs = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👉 Encabezado de fecha
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  date,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 👉 Lista de notificaciones de esa fecha
              ...notifs.map(
                (n) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ShowNotification(notification: n),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class ShowNotification extends StatelessWidget {
  const ShowNotification({super.key, required this.notification});

  final PushMessage notification;

  @override
  Widget build(BuildContext context) {
    return CustomCardsType2(
      width: double.maxFinite,
      child: ListTile(
        title: Text(notification.title),
        subtitle: Text(notification.body),
        leading: notification.imageUrl != null
            ? Image.network(notification.imageUrl!)
            : null,
        trailing: notification.isRead
            ? const Icon(Icons.mark_email_read, color: Colors.green)
            : const Icon(Icons.mark_email_unread, color: Colors.blue),
        onTap: () async {
          await NotificationsDatasourceImpl().markAsRead(
            int.parse(notification.messageId),
          );
          if (context.mounted) {
            context.read<NotificationsBloc>().add(LoadNotifications());
          }
        },
      ),
    );
  }
}
