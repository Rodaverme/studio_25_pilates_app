import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/ocurrence_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/reservation_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/infrastructure.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/cubits.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/ocurrence/ocurrences_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/reservation/reservation_cubit.dart';
import 'package:studio_25_pilates_app/presentation/screens/screens.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/calendar_view.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/class_view.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/home_view.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/notifications_views.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/payments_views/create_new_card_view.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/payments_views/reservation_succes_view.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/perfil_view.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/planes_view.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/payments_views/reservation_view.dart';

final appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ReservationCubit(ReservationDatasourceImpl()),
            ),

            BlocProvider(
              create: (_) =>
                  PlanCubit(PlanRespoitoryImpl(PlanDatasourceImpl())),
            ),
            BlocProvider(
              create: (_) => OcurrencesCubit(OcurrenceDatasourceImpl()),
            ),
            BlocProvider(create: (_) => FormsCreditCardCubit()),
            BlocProvider(
              create: (_) => CreditCardCubit(CreditCardDatasourceImpl()),
            ),

            BlocProvider(
              create: (_) =>
                  MerchantsCubit(MerchantsDatasourceImpl()..getTokenPermalink())
                    ..loadMerchants(),
            ),
          ],
          child: HomeScreen(childView: child),
        );
      },
      routes: [
        GoRoute(
          path: '/Home',
          builder: (context, state) {
            return const HomeView();
          },
          routes: [
            GoRoute(
              path: '/succesPay',
              builder: (context, state) {
                return const ReservationSuccessView();
              },
            ),
            GoRoute(
              name: ClassView.name,
              path: '/class/:id',
              builder: (context, state) {
                final classId = state.pathParameters['id']!;
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) =>
                          OcurrencesCubit(OcurrenceDatasourceImpl())
                            ..loadOcurrenceById(int.parse(classId)),
                    ),
                    BlocProvider(
                      create: (context) =>
                          ReservationCubit(ReservationDatasourceImpl())
                            ..loadCheckReservation(int.parse(classId)),
                    ),
                  ],
                  child: ClassView(classId: classId),
                );
              },
              routes: [
                GoRoute(
                  path: '/reservation/:id',
                  builder: (context, state) {
                    final classId = state.pathParameters['id']!;

                    return MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              OcurrencesCubit(OcurrenceDatasourceImpl())
                                ..loadOcurrenceById(int.parse(classId)),
                          child: ClassView(classId: classId),
                        ),
                        BlocProvider(create: (_) => PaymentCubit()),
                        BlocProvider(
                          create: (_) =>
                              TransactionCubit(TransactionsDatasourceImpl()),
                        ),
                        BlocProvider(
                          create: (_) =>
                              CreditCardCubit(CreditCardDatasourceImpl())
                                ..loadMyCard(),
                        ),
                        BlocProvider(
                          create: (context) =>
                              ReservationCubit(ReservationDatasourceImpl())
                                ..loadCheckReservation(int.parse(classId)),
                        ),
                      ],
                      child: ReservationView(
                        classId: classId,

                        type: ReservationType.classReservation,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        GoRoute(
          path: '/calendar',
          builder: (context, state) {
            return const CalendarView();
          },
        ),
        GoRoute(
          path: '/plans',
          builder: (context, state) {
            return const PlanesView();

            ///plans/reservation/:id
          },
          routes: [
            GoRoute(
              path: '/reservation/:id',
              builder: (context, state) {
                final planId = state.pathParameters['id']!;
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) =>
                          PlanCubit(PlanRespoitoryImpl(PlanDatasourceImpl()))
                            ..loadPlanById(int.parse(planId)),
                    ),
                    BlocProvider(create: (_) => PaymentCubit()),
                    BlocProvider(
                      create: (_) =>
                          CreditCardCubit(CreditCardDatasourceImpl())
                            ..loadMyCard(),
                    ),
                    BlocProvider(
                      create: (_) =>
                          ReservationCubit(ReservationDatasourceImpl()),
                    ),
                  ],
                  child: ReservationView(
                    type: ReservationType.planPurchase,
                    planId: planId,
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) {
            return const NotificationsViews();
          },
        ),
        GoRoute(
          path: '/perfil',
          builder: (context, state) {
            return const PerfilView();
          },
        ),
        GoRoute(
          path: '/new_card',
          builder: (context, state) => const CreateNewCardView(),
        ),
      ],
    ),

    GoRoute(path: '/', builder: (context, state) => LoginScreen()),
    GoRoute(
      path: '/resetPassword',
      builder: (context, state) => ResetPasswordScreen(),
    ),
    GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
  ],
);
