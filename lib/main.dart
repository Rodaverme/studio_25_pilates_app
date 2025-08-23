import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/config/router/app_router.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/auth_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/class_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/plan_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/auth_respository_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/class_respository_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/plan_respoitory_impl.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/auth/auth_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/class/class_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/logout/logout_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/notifications/notifications_bloc.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/plan/plan_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationsBloc.initializeFCM();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  RemoteMessage? initialMessage = await FirebaseMessaging.instance
      .getInitialMessage();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              NotificationsBloc()..handleRemoteMessageIfNotNull(initialMessage),
        ),
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(
          create: (_) => LogoutCubit(
            authRepository: AuthRespositoryImpl(
              datasource: AuthDatasourceImpl(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ClassCubit(
            ClassRespositoryImpl(datasource: ClassDatasourceImpl()),
          ),
        ),
        BlocProvider(
          create: (context) =>
              PlanCubit(PlanRespoitoryImpl(datasource: PlanDatasourceImpl())),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('es', ''), Locale('en', '')],
      theme: AppTheme().getTheme(),
      builder: (context, child) =>
          HandleNotificationInteractions(child: child!),
    );
  }
}

class HandleNotificationInteractions extends StatefulWidget {
  final Widget child;
  const HandleNotificationInteractions({super.key, required this.child});

  @override
  State<HandleNotificationInteractions> createState() =>
      _HandleNotificationInteractionsState();
}

class _HandleNotificationInteractionsState
    extends State<HandleNotificationInteractions> {
  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) _handleMessage(initialMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    context.read<NotificationsBloc>().handleRemoteMessage(message);

    // final messageId = message.messageId?.replaceAll(':', '').replaceAll('%', '');
    // // TODO: usar messageId para navegación condicional
    appRouter.go('/');
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

extension NotificationsBlocX on NotificationsBloc {
  void handleRemoteMessageIfNotNull(RemoteMessage? message) {
    if (message != null) {
      handleRemoteMessage(message);
    }
  }
}
