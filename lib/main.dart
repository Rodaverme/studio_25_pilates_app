import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/config/router/app_router.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';

import 'package:studio_25_pilates_app/infrastructure/datasource/auth_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/class_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/credit_card_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/instructor_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/level_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/merchants_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/plan_datasource_impl.dart';

import 'package:studio_25_pilates_app/infrastructure/datasource/room_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/auth_respository_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/class_respository_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/instructor_repository_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/level_repository_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/plan_respoitory_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/room_repository_impl.dart';

import 'package:studio_25_pilates_app/presentation/providers/cubits/auth/auth_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/class/class_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/class/instructor/instructor_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/class/level/level_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/class/room/room_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/logout/logout_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/notifications/notifications_bloc.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/payment/credit_card/credit_card_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/payment/credit_card/form_credit_card/form_credit_card_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/payment/merchants/merchants_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/payment/payment_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/plan/plan_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/auth_gate.dart';

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
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
        BlocProvider(
          create: (_) => InstructorCubit(
            InstructorRepositoryImpl(datasource: InstructorDatasourceImpl())
              ..getAllInstructor(),
          )..loadInstructors(),
        ),
        BlocProvider(
          create: (_) => LevelCubit(
            LevelRepositoryImpl(datasource: LevelDatasourceImpl())
              ..getAllLevels(),
          )..loadLevels(),
        ),

        BlocProvider(
          create: (_) => RoomCubit(
            RoomRepositoryImpl(datasource: RoomDatasourceImpl())..getAllRoom(),
          )..loadRooms(),
        ),
        BlocProvider(
          create: (context) =>
              PlanCubit(PlanRespoitoryImpl(PlanDatasourceImpl())),
        ),

        BlocProvider(create: (_) => PaymentCubit()),

        BlocProvider<ClassCubit>(
          create: (_) => ClassCubit(
            ClassRespositoryImpl(datasource: ClassDatasourceImpl()),
          ),
        ),
        BlocProvider(
          create: (_) =>
              CreditCardCubit(CreditCardDatasourceImpl())
                ..loadMyCard(),
                
        ),
        BlocProvider<LogoutCubit>(
          create: (context) => LogoutCubit(
            authCubit: context.read<AuthCubit>(),
            planCubit: context.read<PlanCubit>(),
            authRepository: AuthRespositoryImpl(
              datasource: AuthDatasourceImpl(), // tu datasource actual
            ),
          ),
        ),
        BlocProvider(create: (_) => FormsCreditCardCubit()),
        BlocProvider(
          create: (_) =>
              MerchantsCubit(MerchantsDatasourceImpl()..getTokenPermalink())
                ..loadMerchants(),
        ),
      ],
      child: AuthGate(child: const MainApp()), // 👈 envolvemos con un listener
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
