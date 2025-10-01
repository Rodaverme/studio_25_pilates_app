part of 'notifications_bloc.dart';


enum NotificationsStatus { initial, loading, loaded, error }

class NotificationsState extends Equatable {
  final AuthorizationStatus status;
  final List<PushMessage> notifications;
  final List<PushMessage>? notificationes;
  final NotificationsStatus statusNotification;

  const NotificationsState({
    this.status = AuthorizationStatus.notDetermined,
    this.notifications = const [],
    this.notificationes = const [],
    this.statusNotification = NotificationsStatus.initial
  });

  NotificationsState copyWith({
    final AuthorizationStatus? status,
    final List<PushMessage>? notifications,
    final List<PushMessage>? notificationes,
    final NotificationsStatus? statusNotification
  }) => NotificationsState(
    status: status ?? this.status,
    notifications: notifications ?? this.notifications,
    notificationes: notificationes ?? this.notificationes,
    statusNotification: statusNotification ?? this.statusNotification
  );
  @override
  List<Object> get props => [status, notifications, ?notificationes,statusNotification];
}
