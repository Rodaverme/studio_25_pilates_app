import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/domain/entities/check_reservation.dart';
import 'package:studio_25_pilates_app/domain/entities/ocurrence.dart';
import 'package:studio_25_pilates_app/domain/entities/reservation.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/ocurrence/ocurrences_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/reservation/reservation_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type1.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type2.dart';

class ClassView extends StatelessWidget {
  static const name = 'class_screen';
  const ClassView({super.key, required this.classId});
  final String classId;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return BlocBuilder<OcurrencesCubit, OcurrencesState>(
      builder: (context, occState) {
        if (occState.status == OcurrenceStatus.loading) {
         
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (occState.status == OcurrenceStatus.error) {
          return Scaffold(
            body: Center(
              child: Text(occState.errorMessage ?? 'Error desconocido'),
            ),
          );
        }

        if (occState.status == OcurrenceStatus.loaded &&
            occState.ocurrenceById != null) {
          final Ocurrence ocurrence = occState.ocurrenceById!;

          final fechaFormateada = DateFormat(
            "d MMMM ",
            'es_ES',
          ).format(ocurrence.date);
          final horaInicio = DateFormat("HH:mm").format(ocurrence.startTime);

          final currencyFormatter = NumberFormat.currency(
            locale: 'es_CO',
            name: '',
            decimalDigits: 0,
          );

          return BlocBuilder<ReservationCubit, ReservationState>(
            builder: (context, resState) {
              if (resState.status == ReservationStatus.loading) {
                context.read<ReservationCubit>().loadReservations();
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (resState.status == ReservationStatus.error) {
                return Scaffold(
                  body: Center(child: Text('Error cargando clase $classId')),
                );
              }

              // Datos de la reserva
              final check = resState.checkReservation;
              final isSameOcurrence = ocurrence.id == check?.occurrenceId;

              final canReserve = (isSameOcurrence && check != null)
                  ? check.canReserve
                  : true;

              final invitationRemaining = check?.invitationRemaining;

              final reservedCount = check?.reserved ?? 0;
              final capacity = check?.available ?? 0;
              final progress = capacity > 0 ? reservedCount / capacity : 0.0;
              final capacity1 = check?.capacity;
              final available = check?.available;

              // 🔎 Buscar la reserva asociada a esta ocurrencia
              final matchingList = resState.reservations
                  .where((r) => r.ocurrence?.id == ocurrence.id)
                  .toList();

              final Reservation? matchingReservation = matchingList.isNotEmpty
                  ? matchingList.first
                  : null;

              final String? reservationId = matchingReservation?.id.toString();
              print('Este es el reservation ID $reservationId');
              print('Este es el ocurrence id $classId');

              String formatDuration(double minutes) {
                final int totalMinutes = minutes.round(); // redondeamos
                final int hours = totalMinutes ~/ 60;
                final int mins = totalMinutes % 60;

                if (hours > 0 && mins > 0) {
                  return "${hours}h ${mins}min";
                } else if (hours > 0) {
                  return "${hours}h";
                } else {
                  return "${mins}min";
                }
              }

              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    ocurrence.classSession!.nombre,
                    style: textStyle.titleLarge,
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FilledButton(
                        onPressed: () {},
                        child: Text(
                          ocurrence.classSession!.nivel,
                          style: textStyle.bodySmall,
                        ),
                      ),
                    ),
                  ],
                ),
                body: Stack(
                  children: [
                    /// Fondo
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/Logo6.png',
                        fit: BoxFit.cover,
                      ),
                    ),

                    /// Contenido
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  /// Info Card (fecha, hora, sala)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 20,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Inicio",
                                                style: textStyle.bodySmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              Text(
                                                fechaFormateada,
                                                style: textStyle.titleLarge
                                                    ?.copyWith(fontSize: 15),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                horaInicio,
                                                style: textStyle.titleLarge
                                                    ?.copyWith(fontSize: 15),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Duración",
                                                style: textStyle.bodySmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              Text(
                                                formatDuration(
                                                  ocurrence.duracion,
                                                ),
                                                style: textStyle.titleLarge
                                                    ?.copyWith(fontSize: 15),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Ubicación",
                                                style: textStyle.bodySmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              Text(
                                                ocurrence.classSession!.sala,
                                                style: textStyle.titleLarge
                                                    ?.copyWith(fontSize: 15),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  /// Progreso (lugares disponibles)
                                  DescriptionClass(
                                    textStyle: textStyle,
                                    ocurrence: ocurrence,
                                    currencyFormatter: currencyFormatter,
                                    check: check!,
                                  ),

                                  const SizedBox(height: 20),

                                  /// Profesor
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 35,
                                      ),
                                      child: Text(
                                        'Profesor',
                                        style: textStyle.titleLarge,
                                      ),
                                    ),
                                  ),
                                  InstructorDescription(
                                    ocurrence: ocurrence,
                                    textStyle: textStyle,
                                  ),

                                  const SizedBox(height: 20),

                                  PlacesAvailable(
                                    textStyle: textStyle,
                                    reservedCount: available!,
                                    capacity: capacity1!,
                                    progress: progress,
                                  ),
                                  const SizedBox(height: 20),

                                  /// Botón Reservar / Invitar
                                  SubmitButton(
                                    canInvite: check.canInvite,
                                    canReserve: canReserve,
                                    classId: classId,
                                    reservationId:
                                        reservationId, // 👈 se pasa acá
                                    textStyle: textStyle,
                                    invitationReserved: invitationRemaining!,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }

        return const Scaffold(
          body: Center(child: Text("No se encontró la clase")),
        );
      },
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.canReserve,
    required this.classId,
    required this.reservationId,
    required this.textStyle,
    required this.invitationReserved,
    required this.canInvite,
  });

  final bool canInvite;
  final bool canReserve;
  final String classId;
  final String? reservationId; // 👈 ahora puede ser null
  final TextTheme textStyle;
  final int invitationReserved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: FilledButton(
        onPressed: () {
          if (canReserve) {
            context.push('/Home/class/$classId/reservation/$classId');
          } else {
            if (canInvite) return;

            if (reservationId != null && reservationId!.isNotEmpty) {
              context.push('/invite/$reservationId');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("No se encontró la reserva para esta clase"),
                ),
              );
            }
          }
        },
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(AppColors.cafeNoir),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 20),
          ),
          fixedSize: const WidgetStatePropertyAll(Size(300, 60)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        child: Text(
          canReserve ? 'Reservar' : 'Invitar acompañante',
          style: textStyle.titleLarge?.copyWith(color: AppColors.piedra),
        ),
      ),
    );
  }
}

class DescriptionClass extends StatelessWidget {
  const DescriptionClass({
    super.key,
    required this.textStyle,
    required this.ocurrence,
    required this.currencyFormatter,
    required this.check,
  });

  final TextTheme textStyle;
  final Ocurrence ocurrence;
  final NumberFormat currencyFormatter;
  final CheckReservation check;

  @override
  Widget build(BuildContext context) {
    String cleanHtml(String html) {
      final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
      return html.replaceAll(regex, '').trim();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Descripción', style: textStyle.titleLarge),
                Text(
                  !check.isInPlan
                      ? '\$${currencyFormatter.format(int.parse(ocurrence.classSession!.price))}'
                      : '',
                  style: textStyle.titleLarge?.copyWith(
                    color: AppColors.almendra,
                  ),
                ),
              ],
            ),
          ),
          CustomCardsType1(
            height: 150,
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                cleanHtml(ocurrence.classSession!.descripcion),
                style: textStyle.titleLarge?.copyWith(
                  color: AppColors.almendra,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InstructorDescription extends StatelessWidget {
  const InstructorDescription({
    super.key,
    required this.ocurrence,
    required this.textStyle,
  });

  final Ocurrence ocurrence;
  final TextTheme textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomCardsType2(
        width: double.maxFinite,
        height: 170,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ocurrence.classSession!.instructor,
                    style: textStyle.titleLarge?.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      ocurrence.classSession!.bioInstructor,
                      maxLines: 3,
                      style: textStyle.titleLarge?.copyWith(
                        color: AppColors.almendra,
                        height: 1.2,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FilledButton(
                  onPressed: () {},
                  style: const ButtonStyle().copyWith(
                    backgroundColor: const WidgetStatePropertyAll(
                      AppColors.cafeNoir,
                    ),
                  ),
                  child: Text(
                    'Ver Perfil',
                    style: textStyle.bodyMedium?.copyWith(
                      color: AppColors.piedra,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlacesAvailable extends StatelessWidget {
  const PlacesAvailable({
    super.key,
    required this.textStyle,
    required this.reservedCount,
    required this.capacity,
    required this.progress,
  });

  final TextTheme textStyle;
  final int reservedCount;
  final int capacity;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Lugares Disponibles', style: textStyle.titleLarge),
              Text("$reservedCount/$capacity"),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              color: AppColors.cafeNoir,
              backgroundColor: AppColors.piedra,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
