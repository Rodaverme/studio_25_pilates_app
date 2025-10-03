  import 'package:firebase_messaging/firebase_messaging.dart';
  import 'package:flutter_localizations/flutter_localizations.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:studio_25_pilates_app/config/router/app_router.dart';
  import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
  import 'package:studio_25_pilates_app/infrastructure/datasource/notifications_datasource_impl.dart';
  import 'package:studio_25_pilates_app/infrastructure/infrastructure.dart';
  import 'package:studio_25_pilates_app/presentation/providers/cubits/cubits.dart';
  import 'package:studio_25_pilates_app/presentation/providers/blocs/notifications/notifications_bloc.dart';

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await NotificationsBloc.initializeFCM();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    final authCubit = AuthCubit(AuthDatasourceImpl());
    await authCubit.checkAuthStatus();

    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                NotificationsBloc(NotificationsDatasourceImpl())
                  ..handleRemoteMessageIfNotNull(initialMessage),
          ),
          BlocProvider<AuthCubit>.value(value: authCubit), // ✅ usamos el mismo
          BlocProvider<LogoutCubit>(
            create: (context) => LogoutCubit(
              authCubit: context.read<AuthCubit>(),
              authRepository: AuthRespositoryImpl(
                datasource: AuthDatasourceImpl(), // tu datasource actual
              ),
            ),
          ),
          BlocProvider(create: (_) => FormsCreditCardCubit()),
        ],
        child: const MainApp(), // 👈 envolvemos con un listener
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
      message.messageId?.replaceAll(':', '').replaceAll('%', '');
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
