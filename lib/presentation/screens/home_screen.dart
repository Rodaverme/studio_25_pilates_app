import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/notifications_datasource_impl.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/notifications/notifications_bloc.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/cubits.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/ocurrence/ocurrences_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/reservation/reservation_cubit.dart';
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
    final reservedCubit = context.read<ReservationCubit>().loadReservations();
    final notificationCubit = context.read<NotificationsBloc>();
    // final sendToken = await NotificationsDatasourceImpl().sendToken(
    //   TokenService.getToken().toString(),
    // );

    try {
      await Future.wait(
        [
              planCubit.loadPlans(),
              planCubit.loadMyPlan(),
              planCubit.loadStatusPlan(),
              ocurrenceCubit.loadOcurrence(DateTime.now(), DateTime.now()),
              notificationCubit.add(LoadNotifications()),

              reservedCubit,
            ]
            as Iterable<Future>,
      );

      notificationCubit;

      final fmctoken = await FirebaseMessaging.instance.getToken();

      if (fmctoken != null) {
        await NotificationsDatasourceImpl().sendToken(fmctoken);
        print('📲 Token de notificación enviado: $fmctoken');
      } else {
        print('⚠️ No se pudo obtener el token de FCM');
      }

      print('Envio exitoso');
    } catch (_) {}

    if (mounted) {
      setState(() => _isLoading = false);
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
