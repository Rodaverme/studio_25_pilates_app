import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/domain/entities/ocurrence.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/class/class_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/ocurrence/ocurrences_cubit.dart';
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
      builder: (context, state) {
        if (state.status == OcurrenceStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == ClassStatus.error) {
          return Scaffold(
            body: Center(
              child: Text(state.errorMessage ?? 'Error desconocido'),
            ),
          );
        }

        if (state.status == OcurrenceStatus.loaded &&
            state.ocurrenceById != null) {
          final ocurrences = state.ocurrenceById!;
          final Ocurrence ocurrence = ocurrences;

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
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/Logo6.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      /// Info Card
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                fechaFormateada,
                                style: textStyle.titleLarge?.copyWith(
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "$horaInicio - $horaFinal",
                                style: textStyle.titleLarge?.copyWith(
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                ocurrence.classSession.sala,
                                style: textStyle.titleLarge?.copyWith(
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// Progreso
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Lugares Disponibles',
                                  style: textStyle.titleLarge,
                                ),
                                Text(
                                  "${ocurrence.reservedCount}/${ocurrence.classSession.cupoMaximo}",
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: LinearProgressIndicator(
                                value:
                                    ocurrence.reservedCount /
                                    ocurrence.classSession.cupoMaximo,
                                minHeight: 10,
                                color: AppColors.cafeNoir,
                                backgroundColor: AppColors.piedra,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// Profesor
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: Text('Profesor', style: textStyle.titleLarge),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomCardsType2(
                          width: double.maxFinite,
                          height: 170,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ocurrence.classSession.instructor,
                                      style: textStyle.titleLarge?.copyWith(
                                        fontSize: 22,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
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
                                    style: ButtonStyle().copyWith(
                                      backgroundColor:
                                          const WidgetStatePropertyAll(
                                            AppColors.cafeNoir,
                                          ),
                                    ),
                                    child: Text(
                                      'Ver Perfil',
                                      style: TextStyle().copyWith(
                                        color: AppColors.piedra,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Beneficios
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Text(
                                'Beneficios',
                                style: textStyle.titleLarge,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                CustomCardsType2(
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Fuerza',
                                        style: textStyle.titleLarge?.copyWith(
                                          color: AppColors.almendra,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                CustomCardsType2(
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Flexibilidad',
                                        style: textStyle.titleLarge?.copyWith(
                                          color: AppColors.almendra,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                CustomCardsType2(
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Relajación',
                                        style: textStyle.titleLarge?.copyWith(
                                          color: AppColors.almendra,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Descripción
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Text(
                                'Descripción',
                                style: textStyle.titleLarge,
                              ),
                            ),
                            CustomCardsType1(
                              height: 50,
                              width: double.maxFinite,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Text(
                                  ocurrence.classSession.descripcion,
                                  style: textStyle.titleLarge?.copyWith(
                                    color: AppColors.almendra,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Qué traer
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Text(
                                'Qué traer',
                                style: textStyle.titleLarge,
                              ),
                            ),
                            CustomCardsType1(
                              height: 50,
                              width: double.maxFinite,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Text(
                                  'Agua',
                                  style: textStyle.titleLarge?.copyWith(
                                    color: AppColors.almendra,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Precio
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Precio por clase',
                              style: textStyle.titleLarge,
                            ),
                            CustomCardsType1(
                              height: 50,
                              width: double.maxFinite,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Text(
                                  '\$${currencyFormatter.format(int.parse(ocurrence.classSession.price))}',
                                  style: textStyle.titleLarge?.copyWith(
                                    color: AppColors.almendra,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Botones acción
                      Column(
                        children: [
                          FilledButton(
                            onPressed: () {
                              context.push(
                                '/Home/class/$classId/reservation/$classId',
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: const WidgetStatePropertyAll(
                                AppColors.cafeNoir,
                              ),
                              padding: const WidgetStatePropertyAll(
                                EdgeInsets.symmetric(vertical: 20),
                              ),
                              fixedSize: const WidgetStatePropertyAll(
                                Size(300, 60),
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            child: Text(
                              'Reservar',
                              style: textStyle.titleLarge?.copyWith(
                                color: AppColors.piedra,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const Scaffold(
          body: Center(child: Text("No se encontró la clase")),
        );
      },
    );
  }
}
