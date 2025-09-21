import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/domain/entities/check_reservation.dart';
import 'package:studio_25_pilates_app/domain/entities/ocurrence.dart';
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
          final horaFinal = DateFormat("HH:mm").format(ocurrence.endTime);

          final currencyFormatter = NumberFormat.currency(
            locale: 'es_CO',
            name: '',
            decimalDigits: 0,
          );

          return BlocBuilder<ReservationCubit, ReservationState>(
            builder: (context, resState) {
              if (resState.status == ReservationStatus.loading) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (resState.status == ReservationStatus.error) {
                return Scaffold(
                  body: Center(
                    child: Text('Error cargando reserva ${classId}'),
                  ),
                );
              }

              // Datos de la reserva
              final check = resState.checkReservation;
              final isSameOcurrence = ocurrence.id == check?.occurrenceId;

              final canReserve = (isSameOcurrence && check != null)
                  ? check.canReserve
                  : true;

              final reservedCount = check?.reserved ?? 0;
              final capacity = check?.capacity ?? 0;
              final progress = capacity > 0 ? reservedCount / capacity : 0.0;

              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    ocurrence.classSession.nombre,
                    style: textStyle.titleLarge,
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FilledButton(
                        onPressed: () {},
                        child: Text(
                          ocurrence.classSession.nivel,
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
                                          child: Text(
                                            fechaFormateada,
                                            style: textStyle.titleLarge
                                                ?.copyWith(fontSize: 15),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            "$horaInicio - $horaFinal",
                                            style: textStyle.titleLarge
                                                ?.copyWith(fontSize: 15),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            ocurrence.classSession.sala,
                                            style: textStyle.titleLarge
                                                ?.copyWith(fontSize: 15),
                                            overflow: TextOverflow.ellipsis,
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

                                  const SizedBox(height: 20),

                                  PlacesAvailable(
                                    textStyle: textStyle,
                                    reservedCount: reservedCount,
                                    capacity: capacity,
                                    progress: progress,
                                  ),
                                  const SizedBox(height: 20),

                                  /// Botón Reservar / Invitar
                                  SubmitButton(
                                    canReserve: canReserve,
                                    classId: classId,
                                    textStyle: textStyle,
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
    required this.textStyle,
  });

  final bool canReserve;
  final String classId;
  final TextTheme textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: FilledButton(
        onPressed: () {
          if (canReserve) {
            context.push('/Home/class/$classId/reservation/$classId');
          } else {
            context.push('/Home/class/$classId/invite/$classId');
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
                      ? '\$${currencyFormatter.format(int.parse(ocurrence.classSession.price))}'
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
                cleanHtml( ocurrence.classSession.descripcion,),
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
                    ocurrence.classSession.instructor,
                    style: textStyle.titleLarge?.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      ocurrence.classSession.bioInstructor,
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
