import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/domain/entities/entities.dart';
import 'package:studio_25_pilates_app/infrastructure/models/plan/status_plan.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/plan/plan_cubit.dart';
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
          Positioned.fill(
            child: Image.asset('assets/images/Logo6.png', fit: BoxFit.cover),
          ),
    
          BlocBuilder<PlanCubit, PlanState>(
            builder: (context, state) {
              // if (state is PlanLoading) {
              //   return const Center(child: CircularProgressIndicator());
              // }
    
              if (state is PlanError) {
                return Center(child: Text("Error: ${state.message}"));
              }
    
              if (state is AllPlansLoaded) {
                final plans = state.plans;
                final myPlan = state.myPlan;
                final status = state.statusPlan;
                // final status = state.statusPlan;
    
                if (plans.isEmpty) {
                  return const Center(
                    child: Text("No hay planes disponibles"),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: plans.map((plan) {
                      final isActive = myPlan != null && plan.id == myPlan.id;
                      final clases = plan.classes?.map((c) => c.nombre).toList() ?? [];
                      print('Clases del plan ${plan.name}: $clases');
    
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _CustomPlanes(
                          isActive: isActive,
                          textStyle: Theme.of(context).textTheme,
                          plan: plan,
                          status: isActive ? status : null,
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
    
              return const Center(
                child: Text(""),
              );
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

      decimalDigits: 0, // 👈 así no muestra los decimales
    );

    double? progress;
    if (status != null) {
      final startDate = status!.startDate;
      final endDate = status!.expiresAt;

      final totalDays = endDate?.difference(startDate!).inDays;
      final usedDays = totalDays! - status!.daysRemaining;
      progress = usedDays / totalDays;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: isActive
          ? CustomCardsType1(
              width: double.maxFinite,
              height: 300,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Aquí va todo el contenido cuando está activo
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(plan.name, style: textStyle.titleLarge),
                        Text(
                          'se renueva en ${status?.daysRemaining},días',
                          style: textStyle.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          backgroundColor: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        SizedBox(height: 10),
                        Text(limpiarDescripcion(plan.description)),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : CustomCardsType2(
              width: double.maxFinite,
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Aquí va todo el contenido cuando NO está activo
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
                    const Text('Acceso a clases privadas'),
                    const Text('Reserva prioritaria'),
                    const Text('Cancelación Gratuita'),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        height: 60,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black,
                        ),
                        child: const Center(
                          child: Text(
                            'Seleccionar Plan',
                            style: TextStyle(color: Colors.white),
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
    // Eliminar etiquetas HTML como <p>, </p>, etc.
    final sinHtml = raw.replaceAll(RegExp(r'<[^>]*>'), '');
    // Reemplazar \n por saltos de línea reales
    return sinHtml.replaceAll(r'\n', '\n');
  }
}
