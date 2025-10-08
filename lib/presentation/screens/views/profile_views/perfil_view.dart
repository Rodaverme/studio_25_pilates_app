import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/notifications/notifications_bloc.dart';

import 'package:studio_25_pilates_app/presentation/providers/cubits/auth/auth_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/logout/logout_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/stats/stats_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type1.dart';

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.watch<AuthCubit>().state.client;
    final stats = context.watch<StatsCubit>().state.stats;

    return BlocListener<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.read<AuthCubit>().logout();
          context.go('/');
        } else if (state is LogoutError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Perfil')),
        body: Stack(
          children: [
            /// 🌄 Fondo fijo
            Positioned.fill(
              child: Image.asset('assets/images/Logo6.png', fit: BoxFit.cover),
            ),

            /// 📌 Contenido con scroll (sin IntrinsicHeight ni ConstrainedBox)
            SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Información Cliente
                  Column(
                    children: [
                      Center(
                        child: Text(
                          client?.name ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Center(
                        child: Text(
                          client?.email ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Invitaciones
                  CustomCardsType1(
                    width: double.maxFinite,
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Icon(Icons.calendar_month_outlined, size: 50),
                          SizedBox(width: 20),
                          Text('Invitaciones'),
                          Spacer(),
                          Text('3'),
                          SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Estadísticas
                  Row(
                    children: [
                      CustomCardsType1(
                        width: 120,
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${stats?.totoalReservation ?? 0}'),
                            const Text('Reservas'),
                          ],
                        ),
                      ),
                      const Spacer(),
                      CustomCardsType1(
                        width: 120,
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${stats?.totalClasses ?? 0}'),
                            const Text('Clases'),
                          ],
                        ),
                      ),
                      const Spacer(),
                      CustomCardsType1(
                        width: 120,
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${stats?.totaltime ?? 0}'),
                            const Text('Horas'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _PerfilOptions(Icons.person_2, 'Mi perfil', () {
                    context.push('/perfil/mi_perfil');
                  }),
                  _PerfilOptions(Icons.class_outlined, 'Mis clases', () {
                    context.push('/perfil/mis_classes');
                  }),
                  _PerfilOptions(
                    Icons.event_available_sharp,
                    'Mis reservas',
                    () {
                      context.push('/perfil/mis_reservas');
                    },
                  ),
                  _PerfilOptions(Icons.payments_outlined, 'Pagos y Planes', () {
                    context.push('/perfil/mis_pagos');
                  }),
                  _PerfilOptions(Icons.logout_outlined, 'Cerrar Sesión', () {
                    context.read<LogoutCubit>().logOut();
                    context.read<NotificationsBloc>().add(ClearNotifications());
                  }),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PerfilOptions extends StatelessWidget {
  const _PerfilOptions(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: CustomCardsType1(
          width: double.maxFinite,
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(icon, size: 50),
                const SizedBox(width: 10),
                Text(label),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios_outlined),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
