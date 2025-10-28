import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/guest_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/notifications_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/ocurrence_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/payment_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/reservation_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/stats_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/infrastructure.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/notifications/notifications_bloc.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/cubits.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/invitation/form_invitation_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/invitation/invitation/invitation_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/ocurrence/ocurrences_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/payment/my_payments/my_payments_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/reservation/reservation_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/stats/stats_cubit.dart';
import 'package:studio_25_pilates_app/presentation/screens/screens.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/calendar_view.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/class_view.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/guest_view.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/home_view.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/notifications_views.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/payments_views/create_new_card_view.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/payments_views/reservation_error_view.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/payments_views/reservation_succes_view.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/profile_views/my_cards.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/profile_views/my_classes.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/profile_views/my_pays.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/profile_views/my_perfil.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/profile_views/my_reservations.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/profile_views/perfil_view.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/planes_view.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/payments_views/reservation_view.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final isAuth = context.read<AuthCubit>().state.isAuthenticated;
    final loggingIn = state.matchedLocation == '/';
    final isRegister = state.matchedLocation == '/register';
    final isRecover = state.matchedLocation == '/resetPassword';

    if (!isAuth && !(loggingIn || isRegister || isRecover)) {
      // 🔹 No autenticado → solo puede entrar a login, register o recover
      return '/';
    }

    if (isAuth && (loggingIn || isRegister || isRecover)) {
      // 🔹 Ya autenticado → si va a login/register/recover lo mandamos al home
      return '/Home';
    }

    // 🔹 En cualquier otro caso → no redirige
    return null;
  },

  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => StatsCubit(StatsDatasourceImpl())),

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
            BlocProvider.value(value: context.read<AuthCubit>()),

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
              path: '/succesPay/:id',
              builder: (context, state) {
                final ocurrenceId = state.pathParameters['id']!;

                return ReservationSuccessView(occurrenceId: ocurrenceId);
              },
            ),
            GoRoute(
              path: '/errorPay/:id',
              builder: (context, state) {
                final ocurrenceId = state.pathParameters['id']!;
                return ReservationErrorView(ocurrenceId: ocurrenceId);
              },
            ),
            GoRoute(
              path: '/succesPayPlan/:id',
              builder: (context, state) {
                final planId = state.pathParameters['id']!;
                return ReservationSuccessView(planId: planId);
              },
            ),
            GoRoute(
              path: '/errorPayPlan/:id',
              builder: (context, state) {
                final planId = state.pathParameters['id']!;
                return ReservationErrorView(planId: planId);
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

                        BlocProvider(create: (_) => FormInvitationCubit()),
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
          path: '/invite/:id',
          builder: (context, state) {
            final classId = state.pathParameters['id'];

            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => FormInvitationCubit()),
                BlocProvider(
                  create: (context) => InvitationCubit(GuestDatasourceImpl()),
                ),
              ],
              child: GuestView(reservationId: classId),
            );
          },
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
            return BlocProvider(
              create: (context) =>
                  NotificationsBloc(NotificationsDatasourceImpl()),
              child: const NotificationsViews(),
            );
          },
        ),
        GoRoute(
          path: '/perfil',
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => MyPaymentsCubit(PaymentDatasourceImpl()),
                ),
              ],
              child: const PerfilView(),
            );
          },
          routes: [
            GoRoute(
              path: '/mis_tarjetas',
              builder: (context, state) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) =>
                        CreditCardCubit(CreditCardDatasourceImpl())
                          ..loadMyCard(),
                  ),
               BlocProvider(create: (_) => PaymentCubit()),
                ],
                child: const MyCards(),
              ),
            ),

            GoRoute(
              path: '/mis_classes',
              builder: (context, state) => const MyClasses(),
            ),
            GoRoute(
              path: '/mis_reservas',
              builder: (context, state) => const MyReservations(),
            ),
            GoRoute(
              path: '/mis_pagos',
              builder: (context, state) => BlocProvider(
                create: (context) =>
                    MyPaymentsCubit(PaymentDatasourceImpl())..loadpayments(),
                child: const MyPayments(),
              ),
            ),
            GoRoute(
              path: '/mi_perfil',
              builder: (context, state) => MyPerfil(),
            ),
          ],
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
