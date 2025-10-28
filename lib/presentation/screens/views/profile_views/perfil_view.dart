import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/notifications/notifications_bloc.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/auth/auth_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/logout/logout_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/stats/stats_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/plan/plan_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type1.dart';

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.watch<AuthCubit>().state.client;
    final stats = context.watch<StatsCubit>().state.stats;
    final planState = context.watch<PlanCubit>().state;
    final myPlan = planState.myPlan;
    final status = planState.statusPlan;

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
            /// 🌄 Fondo
            Positioned.fill(
              child: Image.asset('assets/images/Logo6.png', fit: BoxFit.cover),
            ),

            /// 📄 Contenido
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            
                            Column(
                              children: [
                                Text(
                                  client?.name ?? '',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  client?.email ?? '',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            /// 🪪 Información del Plan
                            if (myPlan == null)
                              Column(
                                children: [
                                  const Text(
                                    'No tienes un plan activo actualmente',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () => context.go('/plans'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.almendra,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                    ),
                                    child: const Text(
                                      'Ver Planes Disponibles',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              )
                            else
                              CustomCardsType1(
                                width: double.infinity,
                                height: 180,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        myPlan.name,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Inicio: ${DateFormat('dd/MM/yyyy').format(status?.startDate ?? DateTime.now())}',
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Estado: ${(status?.isActive ?? false) ? "Activo" : "Inactivo"}',
                                        style: TextStyle(
                                          color: (status?.isActive ?? false)
                                              ? Colors.green
                                              : Colors.redAccent,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Reservas disponibles: ${status?.reservationsRemaining ?? 0}',
                                      ),
                                      Text(
                                        'Invitaciones disponibles: ${status?.invitationsRemaining ?? 0}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            const SizedBox(height: 25),

                            /// 📊 Estadísticas mensuales
                            if (stats != null) ...[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'En el último mes',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 10),

                              /// 🔹 Cuadros mejor distribuidos
                              Wrap(
                                spacing: 10, // separación horizontal
                                runSpacing:
                                    10, // separación vertical (por si se desborda)
                                alignment: WrapAlignment.center,
                                children: [
                                  _StatCard(
                                    value: '${stats.totoalReservation }',
                                    label: 'Reservas',
                                  ),
                                  _StatCard(
                                    value: '${stats.totaltime }',
                                    label: 'Horas entrenadas',
                                  ),
                                  _StatCard(
                                    value: '${stats.attendeed }%',
                                    label: 'Asistencia',
                                  ),
                                  _StatCard(
                                    value: '${stats.streak }',
                                    label: 'Días de racha',
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 30),

                            /// ⚙️ Opciones inferiores
                            Column(
                              children: [
                                _PerfilOption(
                                  icon: Icons.person_2,
                                  label: 'Mi perfil',
                                  onTap: () =>
                                      context.push('/perfil/mi_perfil'),
                                ),
                                _PerfilOption(
                                  icon: Icons.credit_card,
                                  label: 'Mis tarjetas',
                                  onTap: () =>
                                      context.push('/perfil/mis_tarjetas'),
                                ),
                                _PerfilOption(
                                  icon: Icons.class_outlined,
                                  label: 'Mis clases',
                                  onTap: () =>
                                      context.push('/perfil/mis_classes'),
                                ),
                                _PerfilOption(
                                  icon: Icons.event_available_sharp,
                                  label: 'Mis reservas',
                                  onTap: () =>
                                      context.push('/perfil/mis_reservas'),
                                ),
                                _PerfilOption(
                                  icon: Icons.payments_outlined,
                                  label: 'Pagos y planes',
                                  onTap: () =>
                                      context.push('/perfil/mis_pagos'),
                                ),
                                _PerfilOption(
                                  icon: Icons.logout_outlined,
                                  label: 'Cerrar sesión',
                                  onTap: () {
                                    context.read<LogoutCubit>().logOut();
                                    context.read<NotificationsBloc>().add(
                                      ClearNotifications(),
                                    );
                                  },
                                ),
                              ],
                            ),

                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PerfilOption extends StatelessWidget {
  const _PerfilOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GestureDetector(
        onTap: onTap,
        child: CustomCardsType1(
          width: double.infinity,
          height: 70,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(icon, size: 40),
                const SizedBox(width: 12),
                Expanded(child: Text(label)),
                const Icon(Icons.arrow_forward_ios_outlined),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 100,
      child: CustomCardsType1(
        width: 90,
        height: 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
