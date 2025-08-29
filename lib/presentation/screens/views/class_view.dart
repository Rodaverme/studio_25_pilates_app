import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:studio_25_pilates_app/config/router/app_router.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/class/class_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type1.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type2.dart';

class ClassView extends StatelessWidget {
  static const name = 'class_screen';
  const ClassView({super.key, required this.classId});
  final String classId;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return BlocBuilder<ClassCubit, ClassState>(
      builder: (context, state) {
        if (state is ClassLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ClassByIdLoaded) {
          final PilatesClass clase = state.clase;

          final fechaFormateada = DateFormat("d MMMM ", 'es_ES').format(clase.fechaHora);
          final horaInicio = DateFormat("HH:mm").format(clase.fechaHora);
          final horaFinal = DateFormat("HH:mm").format(clase.fechaHora.add(clase.duracion));

          return Scaffold(
            appBar: AppBar(
              title: Text(clase.nombre),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomCardsType1(
                    width: 150,
                    height: 40,
                    child: Center(child: Text(clase.nivel)),
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
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                fechaFormateada,
                                style: textStyle.titleLarge?.copyWith(fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "$horaInicio - $horaFinal",
                                style: textStyle.titleLarge?.copyWith(fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                clase.sala,
                                style: textStyle.titleLarge?.copyWith(fontSize: 15),
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
                                Text('Lugares Disponibles', style: textStyle.titleLarge),
                                Text("${clase.cuposOcupados}/${clase.cupoMaximo}"),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: LinearProgressIndicator(
                                value: clase.cuposOcupados / clase.cupoMaximo,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Profesor'),
                            CustomCardsType2(
                              width: double.maxFinite,
                              height: 140,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Nombre profesor'),
                                      SizedBox(height: 10),
                                      Text('Mini bio del profesor'),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomCardsType1(
                                      width: 110,
                                      height: 30,
                                      child: const Center(child: Text('Ver Perfil')),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Beneficios
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Beneficios'),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                CustomCardsType1(
                                  height: 40,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12),
                                    child: Center(child: Text('Fuerza')),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                CustomCardsType1(
                                  height: 40,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12),
                                    child: Center(child: Text('Flexibilidad')),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                CustomCardsType1(
                                  height: 40,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12),
                                    child: Center(child: Text('Relajación')),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// Descripción
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Descripción'),
                            CustomCardsType1(
                              height: 50,
                              width: double.maxFinite,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Mini bio profesor'),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Qué traer
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Qué traer'),
                            CustomCardsType1(
                              height: 50,
                              width: double.maxFinite,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Agua'),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Precio
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Precio por clase'),
                            CustomCardsType1(
                              height: 50,
                              width: double.maxFinite,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('120.000'),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Botones acción
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              appRouter.push('/Home/class/$classId/reservation/$classId');
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 120,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: const Text('Reservar', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 150,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: const Text('Invitar Acompañante', style: TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                alignment: Alignment.center,
                                width: 120,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
                              ),
                            ],
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
        } else if (state is ClassError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
