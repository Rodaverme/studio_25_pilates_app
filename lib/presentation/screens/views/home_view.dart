import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/domain/entities/entities.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/auth/auth_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/ocurrence/ocurrences_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/reservation/reservation_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type2.dart';
import 'package:studio_25_pilates_app/presentation/widgets/lessons.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<ReservationCubit>().loadReservations();
    context.read<OcurrencesCubit>().loadOcurrence(
      DateTime.now(),
      DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final client = context.watch<AuthCubit>().state.client;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/Logo6.png', fit: BoxFit.cover),
          ),
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Saludo
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Hola, ${client?.name}',
                        style: textStyle.titleLarge,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tarjetas Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        _InfoCard(label: 'Clases este mes', value: '12'),
                        SizedBox(width: 20),
                        _InfoCard(value: '4', label: 'racha'),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Próxima clase
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Mi Próxima Clase',
                        style: textStyle.titleLarge,
                      ),
                    ),
                    BlocBuilder<ReservationCubit, ReservationState>(
                      builder: (context, state) {
                        if (state.status == ReservationStatus.loading) {
                          print('Cargando');
                        }
                        if (state.status == ReservationStatus.error) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: CustomCardsType2(
                                height: 130,
                                width: double.maxFinite,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text('Ocurrio un problema 😞  )'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        final now = DateTime.now();
                        final upcoming =
                            state.reservations
                                .where(
                                  (r) => r.ocurrence.startTime.isAfter(now),
                                )
                                .toList()
                              ..sort(
                                (a, b) => a.ocurrence.startTime.compareTo(
                                  b.ocurrence.startTime,
                                ),
                              );

                        if (upcoming.isEmpty) {
                          return CustomCardsType2(
                            height: 130,
                            width: double.maxFinite,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text('No tienes reservas próximas '),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    context.go('/calendar');
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      AppColors.almendra,
                                    ),
                                  ),
                                  child: Text(
                                    'Empieza reservando tu primera clase',
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return _NextClass(
                          textStyle: textStyle,
                          clase: upcoming.first,
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Clases de Hoy'),
                    ),

                    // 🔹 Ahora ClassesCarousel maneja sus propios estados
                    const SizedBox(height: 380, child: ClassesCarousel()),

                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Acciones Rápidas'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text('Mis Clases'),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Calendario'),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Tarjetas'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NextClass extends StatelessWidget {
  const _NextClass({required this.textStyle, required this.clase});

  final TextTheme textStyle;
  final Reservation clase;

  @override
  Widget build(BuildContext context) {
    final start = clase.ocurrence.startTime;
    final horaInicio = DateFormat("HH:mm").format(start);

    // Obtenemos solo la parte de la fecha (año, mes, día) para comparar
    final today = DateTime.now();
    final isToday =
        start.year == today.year &&
        start.month == today.month &&
        start.day == today.day;

    // Texto de la fecha
    final fechaTexto = isToday
        ? "Hoy $horaInicio"
        : "${DateFormat('dd/MM/yyyy').format(start)} - $horaInicio";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.maxFinite,
        height: 130,
        decoration: BoxDecoration(
          color: AppColors.piedra,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.cafeNoir),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clase.ocurrence.classSession.nombre,
                      style: textStyle.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      clase.ocurrence.classSession.instructor,
                      style: textStyle.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      fechaTexto,
                      style: textStyle.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size.width;
    return SizedBox(
      width: size * 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: textStyle.titleLarge),
          Text(label, style: textStyle.bodyLarge),
        ],
      ),
    );
  }
}

class ClassesCarousel extends StatefulWidget {
  const ClassesCarousel({super.key});

  @override
  State<ClassesCarousel> createState() => _ClassesCarouselState();
}

class _ClassesCarouselState extends State<ClassesCarousel> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return BlocBuilder<OcurrencesCubit, OcurrencesState>(
      builder: (context, state) {
        if (state.status == OcurrenceStatus.loading) {
          const CircularProgressIndicator(strokeWidth: 4);
        }
        if (state.status == OcurrenceStatus.error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomCardsType2(
                height: 360,
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text('Hoy no hay clases programadas ')),
                  ],
                ),
              ),
            ),
          );
        }
        if (state.ocurrences.isEmpty) {
          const CircularProgressIndicator(strokeWidth: 4);
        }

        final pagesCount = (state.ocurrences.length / 2).ceil();

        return Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pagesCount,
                itemBuilder: (context, index) {
                  final first = index * 2;
                  final second = first + 1;

                  return Column(
                    children: [
                      LessonsToday(
                        ocurrence: state.ocurrences[first],
                        textStyle: textStyle,
                        onTap: () {
                          context.push(
                            '/Home/class/${state.ocurrences[first].id}',
                          );
                        },
                        instructor:
                            state.ocurrences[first].classSession.instructor,
                        level: state.ocurrences[first].classSession.nivel,
                      ),
                      const SizedBox(height: 12),
                      if (second < state.ocurrences.length)
                        LessonsToday(
                          ocurrence: state.ocurrences[second],
                          textStyle: textStyle,
                          onTap: () {
                            context.push(
                              '/Home/class/${state.ocurrences[second].id}',
                            );
                          },
                          instructor:
                              state.ocurrences[second].classSession.instructor,
                          level: state.ocurrences[second].classSession.nivel,
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            SmoothPageIndicator(
              controller: _pageController,
              count: pagesCount,
              effect: ExpandingDotsEffect(
                activeDotColor: AppColors.cafeNoir,
                dotHeight: 8,
                dotWidth: 8,
                spacing: 6,
              ),
            ),
          ],
        );
      },
    );
  }
}
