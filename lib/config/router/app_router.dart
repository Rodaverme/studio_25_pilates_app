import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/class/class_cubit.dart';
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
        return HomeScreen(childView: child);
      },
      routes: [
        GoRoute(
          path: '/Home',
          builder: (context, state) {
            return const HomeView();
          },    
            ),
             GoRoute(
              name: ClassView.name,
              path: '/class/:id',
              builder: (context, state) {
                final classId = state.pathParameters['id']!;

                return BlocProvider.value(
                  value: context.read<ClassCubit>()..loadClasesById(classId),
                  child: ClassView(classId: classId),
                );
              },
              routes: [
                GoRoute(
                  path: '/reservation/:id',
                  builder: (context, state) {
                    final classId = state.pathParameters['id']!;

                    return BlocProvider.value(
                      value: context.read<ClassCubit>()
                        ..loadClasesById(classId),
                      child: ReservationView(classId: classId),
                    );
                  },
                ),
              GoRoute(
                  path: '/succesPay',
                  builder: (context, state) {
                    return const ReservationSuccessView();
                  },
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
          },
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

    // GoRoute(path: '/', builder: (context, state) => LoginScreen()),
    // GoRoute(
    //   path: '/resetPassword',
    //   builder: (context, state) => ResetPasswordScreen(),
    // ),
    // GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),

    // GoRoute(
    //   path: '/home-screen/:page',
    //   name: HomeScreen.name,
    //   builder: (context, state) {
    //     final pageIndex = int.parse(state.pathParameters['page'] ?? '0');
    //     return HomeScreen(pageIndex: pageIndex);
    //   },
    // ),
    // GoRoute(
    //   path: 'class/:id',
    //   name: ClassView.name,
    //   builder: (context, state) {
    //     return ClassView(movieId: state.pathParameters['id'] ?? 'no id');
    //   },
    // ),
  ],
);
