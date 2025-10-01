import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/domain/entities/payment.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/payment/my_payments/my_payments_cubit.dart';


class MyPayments extends StatelessWidget {
  const MyPayments({super.key});

  // ✅ Clasifica la fecha en secciones
  String _getSectionTitle(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    final difference = today.difference(target).inDays;

    if (target == today) return "Hoy";
    if (target.isAfter(today)) return "Próximos";
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
      appBar: AppBar(title: const Text("Mis pagos")),
      body: BlocBuilder<MyPaymentsCubit, MyPaymentsState>(
        builder: (context, state) {
          if (state.status == MyPaymentsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == MyPaymentsStatus.loaded) {
            final payments = state.myPayments;

            if (payments.isEmpty) {
              return const Center(child: Text("No tienes pagos registrados"));
            }

            // ✅ Agrupar pagos por sección
            final grouped = <String, List<Payment>>{};
            final sectionDates = <String, DateTime>{};

            for (final payment in payments) {
              final date = payment.createdAt;
              final sectionTitle = _getSectionTitle(date);

              grouped.putIfAbsent(sectionTitle, () => []);
              grouped[sectionTitle]!.add(payment);

              if (!sectionDates.containsKey(sectionTitle) ||
                  date.isAfter(sectionDates[sectionTitle]!)) {
                sectionDates[sectionTitle] = date;
              }
            }

            // ✅ Ordenar secciones
            final sectionTitles = sectionDates.keys.toList()
              ..sort((a, b) {
                final prioA = _getSectionPriority(a);
                final prioB = _getSectionPriority(b);

                if (prioA != prioB) return prioA.compareTo(prioB);
                return sectionDates[a]!.compareTo(sectionDates[b]!);
              });

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemCount: sectionTitles.length,
              itemBuilder: (context, sectionIndex) {
                final sectionTitle = sectionTitles[sectionIndex];
                final sectionPayments = grouped[sectionTitle]!;

                // ✅ Ordenar pagos dentro de cada sección
                sectionPayments.sort(
                  (a, b) => a.createdAt.compareTo(b.createdAt),
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 👇 Título de sección
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

                    // 👇 Lista de pagos
                    ...sectionPayments.map((payment) {
                      return PaymentHistory(
                        payment: payment,
                        textStyle: textStyle,
                      );
                    }),
                  ],
                );
              },
            );
          }

          if (state.status == MyPaymentsStatus.error) {
            return Center(
              child: Text(
                state.errorMessage ?? "Error cargando pagos",
                style: textStyle.bodyMedium?.copyWith(
                  color: AppColors.cafeNoir,
                ),
              ),
            );
          }

          return const Center(child: Text("Cargando pagos..."));
        },
      ),
    );
  }
}

class PaymentHistory extends StatelessWidget {
  final Payment payment;
  final TextTheme textStyle;

  const PaymentHistory({
    super.key,
    required this.payment,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateFormat(
      "d MMM yyyy, HH:mm",
      'es',
    ).format(payment.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: AppColors.piedra.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: payment.status == "completed"
                ? Colors.green
                : Colors.redAccent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // 👉 Parte izquierda (info de pago)
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
                        payment.description,
                        style: textStyle.titleLarge?.copyWith(
                          color: AppColors.almendra,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Monto: ${payment.amount} ${payment.currency}",
                      style: textStyle.bodyMedium?.copyWith(
                        color: AppColors.almendra,
                      ),
                    ),
                    Text(
                      "Método: ${payment.method}",
                      style: textStyle.bodyMedium?.copyWith(
                        color: AppColors.almendra,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      date,
                      style: textStyle.bodySmall?.copyWith(
                        color: AppColors.almendra,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 👉 Parte derecha (estado)
            Expanded(
              flex: 1,
              child: Center(
                child: Chip(
                  label: Text(
                    payment.status.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: payment.status == "completed"
                      ? Colors.green
                      : Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
