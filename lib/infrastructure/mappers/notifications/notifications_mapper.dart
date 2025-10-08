

import 'package:studio_25_pilates_app/domain/entities/push_message.dart';
import 'package:studio_25_pilates_app/infrastructure/models/notifications/notifications_response.dart';

class NotificationsMapper {
  static PushMessage notificationApitoEntity(NotificationsResponse notificacion) => PushMessage(
    body: notificacion.body,
    messageId: notificacion.id.toString(),
    title: notificacion.title,
    sentDate: notificacion.createdAt,
     readAt: notificacion.readAt != null 
          ? DateTime.tryParse(notificacion.readAt.toString()) 
          : null, // 👈 parseamos el readAt si existe
   

  );
}
