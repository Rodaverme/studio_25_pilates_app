import 'package:studio_25_pilates_app/domain/entities/push_message.dart';

abstract class NotificationsRepository {
  Future<void>sendToken(String token);
  Future<List<PushMessage>>getAllNotification();
  Future<void>markAsRead(int pushMessageId);
   
 }