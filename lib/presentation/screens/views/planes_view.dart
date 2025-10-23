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
    return Scaffold(
      appBar: AppBar(title: const Text('Planes'), centerTitle: true),
      body: Stack(
        children: [
          /// 🌄 Fondo
          Positioned.fill(
            child: Image.asset('assets/images/Logo6.png', fit: BoxFit.cover),
          ),

          /// 📄 Contenido adaptable
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

                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: plans.map((plan) {
                                final isActive =
                                    myPlan != null && plan.id == myPlan.id;

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _CustomPlanes(
                                    isActive: isActive,
                                    textStyle: Theme.of(context).textTheme,
                                    plan: plan,
                                    status:
                                        (isActive && status != null) ? status : null,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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

class _CustomPlanes extends StatelessWidget {
  const _CustomPlanes({
    required this.textStyle,
    required this.plan,
    required this.isActive,
    this.status,
  });

  final Plan plan;
  final TextTheme textStyle;
  final bool isActive;
  final StatusPlan? status;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'es_CO',
      name: '',
      decimalDigits: 0,
    );

    double? progress;
    if (status != null) {
      final startDate = status!.startDate;
      final endDate = status!.expiresAt;
      final totalDays = endDate.difference(startDate).inDays;
      final usedDays = totalDays - status!.daysRemaining;
      progress = usedDays / totalDays;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: isActive
          ? CustomCardsType1(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.name, style: textStyle.titleLarge),
                    if (status != null)
                      Text(
                        'Se renueva en ${status!.daysRemaining} días',
                        style: textStyle.bodyLarge,
                      )
                    else
                      Text('Plan activo', style: textStyle.bodyLarge),

                    const SizedBox(height: 30),

                    if (status != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Asistencia', style: textStyle.titleLarge),
                        ],
                      ),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        color: AppColors.cafeNoir,
                        backgroundColor: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      const SizedBox(height: 10),
                    ],

                    Text(limpiarDescripcion(plan.description)),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )
          : CustomCardsType2(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Cabecera con nombre y precio
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(plan.name, style: textStyle.titleLarge),
                            Text(
                              'Perfecto para empezar',
                              style: textStyle.bodyLarge,
                            ),
                          ],
                        ),
                        Text(
                          '\$${currencyFormatter.format(int.parse(plan.price))}/mes',
                          style: textStyle.titleLarge,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// Descripción
                    Text(limpiarDescripcion(plan.description)),
                    const SizedBox(height: 20),

                    /// Botón seleccionar plan
                    Center(
                      child: GestureDetector(
                        onTap: () =>
                            context.push('/plans/reservation/${plan.id}'),
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
            ),
    );
  }

  String limpiarDescripcion(String raw) {
    final sinHtml = raw.replaceAll(RegExp(r'<[^>]*>'), '');
    return sinHtml.replaceAll(r'\n', '\n');
  }
}
