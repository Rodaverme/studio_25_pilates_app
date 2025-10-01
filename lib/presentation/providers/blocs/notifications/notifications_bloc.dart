// import 'dart:io';

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studio_25_pilates_app/domain/entities/push_message.dart';
import 'package:studio_25_pilates_app/firebase_options.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/notifications_datasource_impl.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsDatasourceImpl datasource;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc(this.datasource) : super(const NotificationsState()) {
    on<NotificationStatusChanged>(_notificationStatusChanged);
    on<NotificationRecived>(_notificationReciveChanged);
    on<LoadNotifications>(_onLoadNotifications);
    on<ClearNotifications>((event, emit) {
      emit(state.copyWith(notifications: []));
    });

    //Verificar estado de las notificaciones
    _initialStatusCheck();
    //Listener para notificaciones en foreground
    _onForegroundMessage();
  }

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  //Metodo que notifica el evento de cambio del estado
  Future<void> _notificationStatusChanged(
    NotificationStatusChanged event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(state.copyWith(status: event.status));

    _getFCMToken();
  }

  void _notificationReciveChanged(
    NotificationRecived event,
    Emitter<NotificationsState> emit,
  ) {
    emit(
      state.copyWith(notifications: [event.message, ...state.notifications]),
    );
  }

  //metodo que muestra el estado inicial
  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationStatusChanged(settings.authorizationStatus));
  }

  // metodo que  obtiene el token si el estado es autorizado
  void _getFCMToken() async {
    if (state.status != AuthorizationStatus.authorized) return;
    final token = await messaging.getToken();
    print(' Este es el token de notificacion $token');
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      emit(state.copyWith(statusNotification: NotificationsStatus.loading));
      final remoteNotifications = await datasource.getAllNotification();

      // 👉 Combinar: backend + las que ya estaban (sin duplicar)
      final all = [
        ...remoteNotifications,
        ...state.notifications.where(
          (n) => !remoteNotifications.any((r) => r.messageId == n.messageId),
        ),
      ];

      emit(
        state.copyWith(
          notifications: all,
          statusNotification: NotificationsStatus.loaded,
        ),
      );
    } catch (e) {
      print("❌ Error cargando notificaciones: $e");
    }
  }

  void handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;
    final notification = PushMessage(
      messageId:
          message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
          ? message.notification!.android?.imageUrl
          : message.notification!.apple?.imageUrl,
      readAt: null,
    );

    add(NotificationRecived(message: notification));

    add(LoadNotifications());
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  //permiso requeridos y usados para el FMC
  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    add(NotificationStatusChanged(settings.authorizationStatus));
  }

  PushMessage? getMessageById(String pushMessageId) {
    final exist = state.notifications.any(
      (element) => element.messageId == pushMessageId,
    );
    if (!exist) return null;
    return state.notifications.firstWhere(
      (element) => element.messageId == pushMessageId,
    );
  }
}
