part of 'notifications_bloc.dart';

enum NotificationsStatus { initial, loading, loaded, error }

class NotificationsState extends Equatable {
  final AuthorizationStatus status;
  final List<PushMessage> notifications;
  final NotificationsStatus statusNotification;

  const NotificationsState({
    this.status = AuthorizationStatus.notDetermined,
    this.notifications = const [],
    this.statusNotification = NotificationsStatus.initial,
  });

  NotificationsState copyWith({
    AuthorizationStatus? status,
    List<PushMessage>? notifications,
    NotificationsStatus? statusNotification,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      statusNotification: statusNotification ?? this.statusNotification,
    );
  }

  @override
  List<Object> get props => [status, notifications, statusNotification];
}
