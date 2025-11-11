import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studio_25_pilates_app/domain/entities/push_message.dart';
import 'package:studio_25_pilates_app/firebase_options.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/notifications_datasource_impl.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

/// 👇 Manejo de mensajes en segundo plano
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsDatasourceImpl datasource;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;

  NotificationsBloc(this.datasource) : super(const NotificationsState()) {
    on<NotificationStatusChanged>(_notificationStatusChanged);
    on<NotificationRecived>(_notificationReciveChanged);
    on<LoadNotifications>(_onLoadNotifications);
    on<ClearNotifications>((event, emit) {
      emit(state.copyWith(notifications: []));
    });

    // Verificar estado inicial
    _initialStatusCheck();

    // Escuchar mensajes cuando la app está abierta
    _onForegroundMessage();
  }

  /// Inicializa Firebase si aún no está inicializado
  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  /// Cambia el estado de autorización y obtiene token si procede
  Future<void> _notificationStatusChanged(
    NotificationStatusChanged event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(state.copyWith(status: event.status));
    _getFCMToken();
  }

  /// Recibe una notificación y la agrega localmente (ya no se usa en foreground)
  void _notificationReciveChanged(
    NotificationRecived event,
    Emitter<NotificationsState> emit,
  ) {
    emit(
      state.copyWith(notifications: [event.message, ...state.notifications]),
    );
  }

  /// Verifica el estado de permisos inicial
  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationStatusChanged(settings.authorizationStatus));
  }

  /// Obtiene el token de notificación FCM
  void _getFCMToken() async {
    if (state.status != AuthorizationStatus.authorized) return;
    final token = await messaging.getToken();
    print(' Este es el token de notificacion $token');
  }

  /// Carga todas las notificaciones del backend
  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      emit(state.copyWith(statusNotification: NotificationsStatus.loading));

      final remoteNotifications = await datasource.getAllNotification();

      // Filtramos las locales que no estén en backend
      final localOnly = state.notifications
          .where((n) => !n.fromBackend)
          .where(
            (n) => !remoteNotifications.any((r) => r.messageId == n.messageId),
          )
          .toList();

      final all = [...remoteNotifications, ...localOnly];

      emit(
        state.copyWith(
          notifications: all,
          statusNotification: NotificationsStatus.loaded,
        ),
      );
    } catch (e) {
      emit(state.copyWith(statusNotification: NotificationsStatus.error));
    }
  }

  /// Manejo de mensajes entrantes (foreground o background)
  void handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;

    // Evitar errores si el Bloc ya fue cerrado
    if (isClosed) return;

    // 👇 Ya NO agregamos la notificación manualmente.
    // Solo recargamos desde backend (así evitamos duplicados)
    add(LoadNotifications());
  }

  /// Escucha notificaciones en foreground
  void _onForegroundMessage() {
    _foregroundSubscription = FirebaseMessaging.onMessage.listen((message) {
      handleRemoteMessage(message);
    });
  }

  /// Solicita permisos para recibir notificaciones
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

  /// Obtiene una notificación específica por ID
  PushMessage? getMessageById(String pushMessageId) {
    final exist = state.notifications.any(
      (element) => element.messageId == pushMessageId,
    );
    if (!exist) return null;
    return state.notifications.firstWhere(
      (element) => element.messageId == pushMessageId,
    );
  }

  /// Cancela el listener de FCM al cerrar el Bloc
  @override
  Future<void> close() {
    _foregroundSubscription?.cancel();
    return super.close();
  }
}
