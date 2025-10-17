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
      appBar: AppBar(title: const Text("Transacciones")),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/Logo6.png', fit: BoxFit.cover),
          ),
          BlocBuilder<MyPaymentsCubit, MyPaymentsState>(
            builder: (context, state) {
              if (state.status == MyPaymentsStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == MyPaymentsStatus.loaded) {
                final payments = state.myPayments;

                if (payments.isEmpty) {
                  return const Center(
                    child: Text("No tienes pagos registrados"),
                  );
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
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
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
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: PaymentHistory(
                              payment: payment,
                              textStyle: textStyle,
                            ),
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
                    "No tienes pagos aún",
                    style: textStyle.bodyMedium?.copyWith(
                      color: AppColors.cafeNoir,
                    ),
                  ),
                );
              }

              return const Center(child: Text("Cargando pagos..."));
            },
          ),
        ],
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
    final currencyFormatter = NumberFormat.currency(
      locale: 'es_CO',
      name: '',
      decimalDigits: 0,
    );

    // Ícono según estado
    IconData statusIcon;
    Color statusColor;

    switch (payment.status) {
      case "completed":
        statusIcon = Icons.check_circle;
        statusColor = Colors.green;
        break;
      case "cancelled":
        statusIcon = Icons.cancel;
        statusColor = Colors.redAccent;
        break;
      default:
        statusIcon = Icons.warning_amber_rounded;
        statusColor = Colors.amber;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.piedra.withValues(alpha: 0.7),
          border: Border.all(color: AppColors.cafeNoir),
          borderRadius: BorderRadius.circular(15),
          // 🔸 Eliminado el borde de color
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟢 Icono de estado
            Padding(
              padding: const EdgeInsets.only(right: 12, top: 4),
              child: Icon(statusIcon, color: statusColor, size: 28),
            ),

            // 💳 Información del pago
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 👉 Lo que se compró
                  Text(
                    payment.plan != null
                        ? payment.plan!.name
                        : payment.reservation != null
                        ? '${payment.reservation!.ocurrence?.classSessionTitle}'
                        : 'Pago',
                    style: textStyle.titleMedium?.copyWith(
                      color: AppColors.almendra,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // 👉 Precio'\$${currencyFormatter.format(int.parse(context.read<OcurrencesCubit>().state.ocurrenceById!.price))}'
                  Text(
                    "Precio: \$${currencyFormatter.format(int.parse(payment.amount))} ${payment.currency}",
                    style: textStyle.bodyMedium?.copyWith(
                      color: AppColors.almendra,
                    ),
                  ),

                  // 👉 Método de pago
                  Text(
                    "Método: ${payment.method}",
                    style: textStyle.bodyMedium?.copyWith(
                      color: AppColors.almendra,
                    ),
                  ),

                  // 👉 Fecha
                  Text(
                    "Fecha: $date",
                    style: textStyle.bodyMedium?.copyWith(
                      color: AppColors.almendra,
                    ),
                  ),

                  // 👉 Referencia (más pequeña)
                  const SizedBox(height: 4),
                  Text(
                    "Ref: ${payment.description}",
                    style: textStyle.bodySmall?.copyWith(
                      color: AppColors.almendra.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),

                  // 👉 Estado (completed / cancelled / pending)
                  const SizedBox(height: 8),
                  Text(
                    payment.status.toUpperCase(),
                    style: textStyle.bodyMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
