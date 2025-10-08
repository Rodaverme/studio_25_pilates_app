import 'package:studio_25_pilates_app/domain/entities/push_message.dart';
import 'package:studio_25_pilates_app/domain/repositories/notifications_repository.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/notifications_datasource_impl.dart';

class NotificationRepositoryImpl extends NotificationsRepository {
  final NotificationsDatasourceImpl datasource;

  NotificationRepositoryImpl({required this.datasource});
  @override
  Future<void> sendToken(String token) {
    return datasource.sendToken(token);
  }

  @override
  Future<List<PushMessage>> getAllNotification() {
    return datasource.getAllNotification();
  }
  
  @override
  Future<void> markAsRead(int pushMessageId) {
    return datasource.markAsRead(pushMessageId);
  }
}
