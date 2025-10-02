import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:studio_25_pilates_app/domain/entities/ocurrence.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/reservation/reservation_cubit.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';

class MyReservations extends StatelessWidget {
  const MyReservations({super.key});

  // ✅ Clasifica la fecha en secciones
  String _getSectionTitle(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    final difference = today.difference(target).inDays;

    // ✅ primero validar si es hoy
    if (target == today) return "Hoy";

    // ✅ si es en el futuro (mañana en adelante)
    if (target.isAfter(today)) return "Próximos";

    // ✅ fechas pasadas
    if (difference == 1) return "Ayer";
    if (difference > 1 && difference < 7) return "Esta semana";
    if (difference >= 7 && difference < 30) return "Este mes";
    if (difference >= 30 && difference < 365) return "Este año";

    return DateFormat('dd/MM/yyyy').format(date);
  }

  // ✅ Define prioridad para ordenar secciones
  int _getSectionPriority(String title) {
    switch (title) {
      case "Hoy":
        return 0;
      case "Próximos":
        return 1;
      case "Ayer":
        return 2;
      case "Esta semana":
        return 3;
      case "Este mes":
        return 4;
      case "Este año":
        return 5;
      default:
        return 6;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Mis reservas')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/Logo6.png', fit: BoxFit.cover),
          ),
          BlocBuilder<ReservationCubit, ReservationState>(
            builder: (context, state) {
              if (state.status == ReservationStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == ReservationStatus.loaded) {
                final reservations = state.reservations;

                if (reservations.isEmpty) {
                  return const Center(
                    child: Text("No tienes reservas activas"),
                  );
                }

                // ✅ Agrupar reservas por sección
                final grouped = <String, List<dynamic>>{};
                final sectionDates = <String, DateTime>{};

                for (final reservation in reservations) {
                  final date = reservation.ocurrence?.startTime;
                  final sectionTitle = _getSectionTitle(date!);

                  grouped.putIfAbsent(sectionTitle, () => []);
                  grouped[sectionTitle]!.add(reservation);

                  // guardamos la fecha más relevante para ordenar secciones
                  if (!sectionDates.containsKey(sectionTitle) ||
                      date.isAfter(sectionDates[sectionTitle]!)) {
                    sectionDates[sectionTitle] = date;
                  }
                }

                // ✅ Ordenar secciones según prioridad y fecha
                final sectionTitles = sectionDates.keys.toList()
                  ..sort((a, b) {
                    final prioA = _getSectionPriority(a);
                    final prioB = _getSectionPriority(b);

                    if (prioA != prioB) return prioA.compareTo(prioB);

                    // si tienen la misma prioridad, ordenar por fecha ascendente
                    return sectionDates[a]!.compareTo(sectionDates[b]!);
                  });

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: sectionTitles.length,
                  itemBuilder: (context, sectionIndex) {
                    final sectionTitle = sectionTitles[sectionIndex];
                    final sectionReservations = grouped[sectionTitle]!;

                    // ✅ Ordenar reservas dentro de cada sección
                    sectionReservations.sort((a, b) {
                      final dateA = a.ocurrence.startTime;
                      final dateB = b.ocurrence.startTime;
                      return dateA.compareTo(dateB);
                    });

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 👇 Título del grupo
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            sectionTitle,
                            style: textStyle.titleLarge?.copyWith(
                              color: AppColors.almendra,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // 👇 Reservas dentro de este grupo
                        ...sectionReservations.map((reservation) {
                          final ocurrence = reservation.ocurrence;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ReservedHistory(
                              ocurrence: ocurrence,
                              textStyle: textStyle,
                              onTap: () {
                                context.push('/invite/${reservation.id}');
                              },
                              instructor: ocurrence.classSession.instructor,
                              level: ocurrence.classSession.nivel,
                            ),
                          );
                        }),
                      ],
                    );
                  },
                );
              }

              if (state.status == ReservationStatus.error) {
                return Center(
                  child: Text(
                    state.errorMessage ?? "Error desconocido",
                    style: textStyle.bodyMedium?.copyWith(
                      color: AppColors.cafeNoir,
                    ),
                  ),
                );
              }

              return const Center(child: Text("Cargando reservas..."));
            },
          ),
        ],
      ),
    );
  }
}

class ReservedHistory extends StatelessWidget {
  const ReservedHistory({
    super.key,
    required this.textStyle,
    required this.onTap,
    required this.ocurrence,
    required this.instructor,
    required this.level,
  });

  final TextTheme textStyle;
  final void Function()? onTap;
  final Ocurrence ocurrence;
  final String instructor;
  final String level;

  @override
  Widget build(BuildContext context) {
    final horaInicio = DateFormat("HH:mm").format(ocurrence.startTime);
    final horaFinal = DateFormat("HH:mm").format(ocurrence.endTime);
    final date = DateFormat("d MMMM yyyy", 'es').format(ocurrence.date);

    final bool isInPlan = ocurrence.isInPlan;

    // 🔎 Lógica para saber si puede invitar
    final now = DateTime.now();
    final start = ocurrence.startTime;
    final isToday =
        start.year == now.year &&
        start.month == now.month &&
        start.day == now.day;
    final isFuture = start.isAfter(now);

    final canInvite = (isToday && start.isAfter(now)) || isFuture;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 170,
            decoration: BoxDecoration(
              color: AppColors.piedra.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isInPlan ? Colors.amber : AppColors.arena,
                width: isInPlan ? 3 : 1,
              ),
            ),
            child: Row(
              children: [
                /// 👉 Parte izquierda (info de la clase)
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            ocurrence.classSession!.nombre,
                            style: textStyle.titleLarge?.copyWith(
                              color: AppColors.almendra,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          instructor,
                          style: textStyle.titleLarge?.copyWith(
                            color: AppColors.almendra,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$date ',
                          style: textStyle.titleLarge?.copyWith(
                            color: AppColors.almendra,
                          ),
                        ),
                        Text(
                          '$horaInicio - $horaFinal',
                          style: textStyle.titleLarge?.copyWith(
                            color: AppColors.almendra,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// 👉 Parte derecha (botones)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 30,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilledButton(
                          onPressed: () {},
                          child: Text(level, style: textStyle.bodySmall),
                        ),

                        // 🔎 Condicional para Invitar o Eliminar
                        canInvite
                            ? ElevatedButton(
                                onPressed: onTap,
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    AppColors.almendra,
                                  ),
                                ),
                                child: Text(
                                  'Invitar',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// 👉 Estrella de destacado si está en plan
          if (isInPlan)
            const Positioned(
              top: 8,
              right: 8,
              child: Icon(Icons.star, color: Colors.amber, size: 30),
            ),
        ],
      ),
    );
  }
}
