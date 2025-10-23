import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/notifications_datasource_impl.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/notifications/notifications_bloc.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/cubits.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/ocurrence/ocurrences_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/reservation/reservation_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/stats/stats_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:studio_25_pilates_app/presentation/widgets/shared/full_screen_loader.dart';

class HomeScreen extends StatefulWidget {
  static const name = 'home-screen';
  final Widget childView;

  const HomeScreen({super.key, required this.childView});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final planCubit = context.read<PlanCubit>();
    final ocurrenceCubit = context.read<OcurrencesCubit>();
    final reservationCubit = context.read<ReservationCubit>();
    final notificationCubit = context.read<NotificationsBloc>();
    final stats = context.read<StatsCubit>();
    final authCubit = context.read<AuthCubit>();

    try {
      await Future.wait([
        planCubit.loadPlans(),
        planCubit.loadMyPlan(),
        planCubit.loadStatusPlan(),
        stats.loadStats(DateTime(2025, 1, 1), DateTime.now()),
        ocurrenceCubit.loadOcurrence(DateTime.now(), DateTime.now()),
        reservationCubit.loadReservations(),
        // 👇 Las notificaciones no devuelven Future, así que se llaman aparte
        Future(() => notificationCubit.add(LoadNotifications())),
      ]);

      final fmctoken = await FirebaseMessaging.instance.getToken();
      if (fmctoken != null) {
        await NotificationsDatasourceImpl().sendToken(fmctoken);
      }
    } catch (e) {
      // ✅ Si el error sugiere token inválido, cerramos sesión y redirigimos al login
      if (e.toString().contains('Token not provided')) {
        authCubit.logout();

        if (mounted) {
          // 🔹 Forzamos redirección inmediata al login
          context.go('/');
        }
        return; // importante para no seguir ejecutando
      }
    }

    // ✅ Solo si todo salió bien
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _isLoading
            ? Center(child: Center(child: FullScreenLoader()))
            : widget.childView,
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
