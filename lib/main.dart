import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/config/router/app_router.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/auth_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/auth_respository_impl.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/auth/auth_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/logout/logout_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/notifications/notifications_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationsBloc.initializeFCM();
  // RemoteMessage? initialMessage = await FirebaseMessaging.instance
  //     .getInitialMessage();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              NotificationsBloc()..handleRemoteMessageIfNotNull(RemoteMessage()),
        ),
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(
          create: (_) => LogoutCubit(
            authRepository: AuthRespositoryImpl(
              datasource: AuthDatasourceImpl(),
            ),
          ),
        ),
      ],
      child: const MainApp(),
    ),
  );
  
}

extension on NotificationsBloc {
  void handleRemoteMessageIfNotNull(RemoteMessage? message) {
    if (message != null) {
      handleRemoteMessage(message);
      // Aquí podrías guardar un estado para redirigir en el router
    }
  }
}

class MainApp extends StatelessWidget {
  
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
      // builder: (context, child) =>
      //     HandleNotificationInteractions(child: child!),
    );
  }
}

  // class HandleNotificationInteractions extends StatefulWidget {
  //   final Widget child;
  //   const HandleNotificationInteractions({super.key, required this.child});

  //   @override
  //   State<HandleNotificationInteractions> createState() =>
  //       _HandleNotificationInteractionsState();
  // }

  // class _HandleNotificationInteractionsState
  //     extends State<HandleNotificationInteractions> {
  //   Future<void> setupInteractedMessage() async {
  //     // Get any messages which caused the application to open from
  //     // a terminated state.
  //     RemoteMessage? initialMessage = await FirebaseMessaging.instance
  //         .getInitialMessage();

  //     // If the message also contains a data property with a "type" of "chat",
  //     // navigate to a chat screen5
  //     if (initialMessage != null) {
  //       _handleMessage(initialMessage);
  //     }

  //     // Also handle any interaction when the app is in the background via a
  //     // Stream listener
  //     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  //   }

  //   void _handleMessage(RemoteMessage message) {
  //     context.read<NotificationsBloc>().handleRemoteMessage(message);
  //     //TODO MANEJO POR SI QUIERO OBTERNER EL ID PARA NAVEGAR A OTRO LUGAR
  //     final messageId=message.messageId?.replaceAll(':', '').replaceAll('%', '');
  //     appRouter.push('/');
  //   }

  //   @override
  //   void initState() {
  //     super.initState();

  //     // Run code required to handle interacted messages in an async function
  //     // as initState() must not be async

  //     setupInteractedMessage();
  //   }

  //   @override
  //   Widget build(BuildContext context) {
  //     return widget.child;
  //   }
  // }
