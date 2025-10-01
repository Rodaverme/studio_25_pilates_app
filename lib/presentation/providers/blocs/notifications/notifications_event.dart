part of 'notifications_bloc.dart';

sealed class NotificationsEvent  {
  const NotificationsEvent();

  
}

class LoadNotifications extends NotificationsEvent {}
class ClearNotifications extends NotificationsEvent {}


class NotificationStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;
  NotificationStatusChanged(this.status);
  
}

class NotificationRecived extends NotificationsEvent{
  final PushMessage message;
  NotificationRecived({required this.message});
 }
