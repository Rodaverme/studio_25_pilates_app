import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/domain/entities/entities.dart';
import 'package:studio_25_pilates_app/infrastructure/models/plan/status_plan.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/plan/plan_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type1.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type2.dart';

class PlanesView extends StatelessWidget {
  const PlanesView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Planes'),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/Logo6.png', fit: BoxFit.cover),
          ),
          BlocBuilder<PlanCubit, PlanState>(
            builder: (context, state) {
              if (state.status == PlanStatus.error) {
                return Center(child: Text("Error: ${state.errorMessage}"));
              }

              if (state.status == PlanStatus.loaded) {
                final plans = state.plans;
                final myPlan = state.myPlan;
                final status = state.statusPlan;

                if (plans.isEmpty) {
                  return const Center(child: Text("No hay planes disponibles"));
                }

                final currencyFormatter = NumberFormat.currency(
                  locale: 'es_CO',
                  name: '',
                  decimalDigits: 0,
                );

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (myPlan != null) ...[
                        Text(
                          'Plan Activo',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.cafeNoir,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _PlanActivoCard(
                          plan: myPlan,
                          status: status,
                          textStyle: textTheme,
                          formatter: currencyFormatter,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Planes Disponibles',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.cafeNoir,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      ...plans.map((plan) {
                        if (myPlan != null && plan.id == myPlan.id) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: _CustomPlanes(
                            textStyle: textTheme,
                            plan: plan,
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}

class _PlanActivoCard extends StatelessWidget {
  const _PlanActivoCard({
    required this.plan,
    required this.status,
    required this.textStyle,
    required this.formatter,
  });

  final Plan plan;
  final StatusPlan? status;
  final TextTheme textStyle;
  final NumberFormat formatter;

  @override
  Widget build(BuildContext context) {
    double? progress;
    int? asistenciaActual;
    int? asistenciaTotal;

    if (status != null) {
      final startDate = status!.startDate;
      final endDate = status!.expiresAt;
      final totalDays = endDate.difference(startDate).inDays;
      final usedDays = totalDays - status!.daysRemaining;
      progress = usedDays / totalDays;
      asistenciaActual = usedDays; // Puedes reemplazarlo con tu valor real
      asistenciaTotal = totalDays;
    }

    return CustomCardsType1(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(plan.name, style: textStyle.titleLarge),
            const SizedBox(height: 5),
            Text(
              '\$${formatter.format(int.parse(plan.price))} / mes',
              style: textStyle.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (status != null)
              Text(
                'Se renueva en ${status!.daysRemaining} días',
                style: textStyle.bodyLarge,
              ),
            const SizedBox(height: 20),

            /// Progreso de asistencia
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Asistencia', style: textStyle.titleMedium),
                Text(
                  '$asistenciaActual/$asistenciaTotal',
                  style: textStyle.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: progress ?? 0.0,
              minHeight: 10,
              color: AppColors.cafeNoir,
              backgroundColor: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 16),

            /// Descripción limpia
            Text(
              limpiarDescripcion(plan.description),
              style: textStyle.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomPlanes extends StatelessWidget {
  const _CustomPlanes({required this.textStyle, required this.plan});

  final Plan plan;
  final TextTheme textStyle;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'es_CO',
      name: '',
      decimalDigits: 0,
    );

    return CustomCardsType2(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Cabecera
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.name, style: textStyle.titleLarge),
                    Text('Perfecto para empezar', style: textStyle.bodyLarge),
                  ],
                ),
                Text(
                  '\$${currencyFormatter.format(int.parse(plan.price))}/mes',
                  style: textStyle.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(limpiarDescripcion(plan.description)),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () => context.push('/plans/reservation/${plan.id}'),
                child: Container(
                  height: 60,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.almendra,
                  ),
                  child: const Center(
                    child: Text(
                      'Seleccionar Plan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String limpiarDescripcion(String raw) {
  final sinHtml = raw.replaceAll(RegExp(r'<[^>]*>'), '');
  return sinHtml.replaceAll(r'\n', '\n');
}
