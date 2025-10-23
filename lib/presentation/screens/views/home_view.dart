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
import 'package:studio_25_pilates_app/presentation/providers/cubits/stats/stats_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type1.dart';
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
      body: LoadingWrapper(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('assets/images/Logo6.png', fit: BoxFit.cover),
            ),
            ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 👋 Saludo
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Hola, ${client?.name ?? ''}',
                          style: textStyle.titleLarge,
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('ESTUDIO'),
                          SizedBox(width: 10),
                          Image.asset(
                            'assets/images/Logo.png',
                            height: 70,
                            width: 70,
                          ),
                          SizedBox(width: 10),
                          Text('PILATES'),
                        ],
                      ),

                      // 📊 Tarjetas de estadísticas
                      const SizedBox(height: 10),

                      // 🧘‍♀️ Próxima clase
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Mi Próxima Clase',
                          style: textStyle.titleLarge,
                        ),
                      ),
                      BlocBuilder<ReservationCubit, ReservationState>(
                        builder: (context, state) {
                          if (state.status == ReservationStatus.error) {
                            return CustomCardsType1(
                              height: 130,
                              width: double.maxFinite,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Center(
                                    child: Text('No tienes reservas próximas'),
                                  ),
                                  FilledButton(
                                    onPressed: () => context.go('/calendar'),
                                    style: const ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        AppColors.almendra,
                                      ),
                                    ),
                                    child: const Text(
                                      'Empieza reservando tu primera clase',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final now = DateTime.now();
                          final upcoming =
                              state.reservations
                                  .where(
                                    (r) => r.ocurrence!.startTime.isAfter(now),
                                  )
                                  .toList()
                                ..sort(
                                  (a, b) => a.ocurrence!.startTime.compareTo(
                                    b.ocurrence!.startTime,
                                  ),
                                );

                          if (upcoming.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: CustomCardsType1(
                                height: 130,
                                width: double.maxFinite,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Center(
                                      child: Text('No tienes reservas próximas'),
                                    ),
                                    FilledButton(
                                      onPressed: () => context.go('/calendar'),
                                      style: const ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                          AppColors.almendra,
                                        ),
                                      ),
                                      child: const Text(
                                        'Empieza reservando tu primera clase',
                                      ),
                                    ),
                                  ],
                                ),
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Acciones Rápidas',
                          style: textStyle.titleLarge,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {context.go('/perfil/mis_classes');},
                              child: const Text('Mis Clases'),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                context.go('/calendar');
                              },
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

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Clases de Hoy',
                          style: textStyle.titleLarge,
                        ),
                      ),

                      const SizedBox(height: 380, child: ClassesCarousel()),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Wrapper global para manejar estado de carga unificado
class LoadingWrapper extends StatelessWidget {
  final Widget child;

  const LoadingWrapper({super.key, required this.child});

  bool _isLoading(BuildContext context) {
    final reservationLoading =
        context.watch<ReservationCubit>().state.status ==
        ReservationStatus.loading;
    final occLoading =
        context.watch<OcurrencesCubit>().state.status ==
        OcurrenceStatus.loading;
    final statsLoading =
        context.watch<StatsCubit>().state.status == StatsStatus.loading;

    return reservationLoading || occLoading || statsLoading;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _isLoading(context);
    if (!isLoading) return child;

    return Stack(
      fit: StackFit.expand,
      children: [
        // ✅ Fondo con la imagen
        Positioned.fill(
          child: Image.asset('assets/images/Logo6.png', fit: BoxFit.cover),
        ),
        // ✅ Indicador de carga centrado
        const Center(
          child: CircularProgressIndicator(
            color: AppColors.cafeNoir,
            strokeWidth: 3,
          ),
        ),
      ],
    );
  }
}

/// 🔹 Error card reutilizable
class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CustomCardsType2(
          height: 130,
          width: double.maxFinite,
          child: Center(child: Text(message)),
        ),
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
    final start = clase.ocurrence!.startTime;
    final horaInicio = DateFormat("HH:mm").format(start);

    final today = DateTime.now();
    final isToday =
        start.year == today.year &&
        start.month == today.month &&
        start.day == today.day;

    final fechaTexto = isToday
        ? "Hoy $horaInicio"
        : "${DateFormat('dd/MM/yyyy').format(start)} - $horaInicio";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.maxFinite,
        height: 170,
        decoration: BoxDecoration(
          color: AppColors.piedra,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.cafeNoir),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clase.ocurrence!.classSession!.nombre,
                      style: textStyle.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      clase.ocurrence!.classSession!.instructor,
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
                      child: Text(
                        clase.ocurrence!.classSession!.nivel,
                        style: textStyle.bodySmall,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.push('/Home/class/${clase.ocurrence?.id}');
                      },
                      child: const Text(
                        'Ver',
                        style: TextStyle(color: Colors.white),
                      ),
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
        if (state.status == OcurrenceStatus.error) {
          return _ErrorCard('Error al cargar las clases, inténtalo de nuevo.');
        }

        final now = DateTime.now();
        final reservationLimit = now.add(const Duration(minutes: 15));
        final validOcurrences = state.ocurrences
            .where((o) => o.startTime.isAfter(reservationLimit))
            .toList();

        if (validOcurrences.isEmpty) {
          return const Center(child: Text('No hay clases disponibles'));
        }

        final pagesCount = (validOcurrences.length / 2).ceil();

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
                        ocurrence: validOcurrences[first],
                        textStyle: textStyle,
                        onTap: () => context.push(
                          '/Home/class/${validOcurrences[first].id}',
                        ),
                        instructor:
                            validOcurrences[first].classSession!.instructor,
                        level: validOcurrences[first].classSession!.nivel,
                      ),
                      const SizedBox(height: 12),
                      if (second < validOcurrences.length)
                        LessonsToday(
                          ocurrence: validOcurrences[second],
                          textStyle: textStyle,
                          onTap: () => context.push(
                            '/Home/class/${validOcurrences[second].id}',
                          ),
                          instructor:
                              validOcurrences[second].classSession!.instructor,
                          level: validOcurrences[second].classSession!.nivel,
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
              effect: const ExpandingDotsEffect(
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
