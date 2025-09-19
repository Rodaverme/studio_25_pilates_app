import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/domain/entities/credit_card.dart';
import 'package:studio_25_pilates_app/domain/entities/ocurrence.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/ocurrence/ocurrences_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/payment/credit_card/credit_card_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/payment/payment_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/payment/payment_state.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/reservation/reservation_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type1.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type2.dart';

class ReservationView extends StatelessWidget {
  final String classId;
  const ReservationView({super.key, required this.classId});
  @override
  Widget build(BuildContext context) {
    final creditCards = context.watch<CreditCardCubit>().state.creditCard;

    return BlocBuilder<OcurrencesCubit, OcurrencesState>(
      builder: (context, state) {
        if (state.status == OcurrenceStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == OcurrenceStatus.loaded) {
          final Ocurrence? classe = state.ocurrenceById;
          final textStyle = Theme.of(context).textTheme;
          final statePay = context.watch<PaymentCubit>().state;
          final currencyFormatter = NumberFormat.currency(
            locale: 'es_CO',
            name: '',
            decimalDigits: 0,
          );
          return Scaffold(
            appBar: AppBar(
              title: Text('Confirmar Reserva', style: textStyle.titleLarge),
            ),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/Logo6.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 👉 Resumen
                              _SumaryClass(
                                textStyle: textStyle,
                                ocurrence: classe!,
                              ),
                              const SizedBox(height: 40),
                              Text(
                                'Método de Pago',
                                style: textStyle.titleLarge,
                              ),
                              const SizedBox(height: 10),
                              PaymentMethodSelector(creditCards: creditCards),

                              const SizedBox(height: 20),

                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text('Políticas de Cancelación'),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text('Términos y condiciones'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      _TotalPay(
                        textStyle: textStyle,
                        statePay: statePay,
                        currencyFormatter: currencyFormatter,
                        ocurrence: classe,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state.status == OcurrenceStatus.error) {
          return Center(child: Text(state.errorMessage!));
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _TotalPay extends StatelessWidget {
  const _TotalPay({
    required this.textStyle,
    required this.statePay,
    required this.currencyFormatter,
    required this.ocurrence,
  });

  final TextTheme textStyle;
  final PaymentState statePay;
  final NumberFormat currencyFormatter;
  final Ocurrence ocurrence;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total a Pagar',
                style: textStyle.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                switch (statePay) {
                  PaymentSelected(method: final m) => switch (m.type) {
                    PaymentMethodType.credit => '1 Crédito',
                    PaymentMethodType.card =>
                      '\$${currencyFormatter.format(int.parse(ocurrence.price))}',
                    PaymentMethodType.newCard => 'Ingrese tarjeta',
                  },
                  _ => 'Selecciona un método',
                },
                style: textStyle.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          ReserveButton(ocurrence: ocurrence),
        ],
      ),
    );
  }
}

class _SumaryClass extends StatelessWidget {
  const _SumaryClass({required this.textStyle, required this.ocurrence});

  final TextTheme textStyle;
  final Ocurrence ocurrence;

  @override
  Widget build(BuildContext context) {
    final fechaFormateada = DateFormat(
      "d MMMM ",
      'es_ES',
    ).format(ocurrence.date);
    final horaInicio = DateFormat("HH:mm").format(ocurrence.startTime);
    final horaFinal = DateFormat("HH:mm").format(ocurrence.endTime);
    final duracion = ocurrence.endTime.difference(ocurrence.startTime);
    final horas = duracion.inHours;
    final minutos = duracion.inMinutes.remainder(60);
    final duracionFormateada =
        "${horas > 0 ? "$horas Hora " : ""}${minutos > 0 ? "$minutos minuntos" : ""}";

    return CustomCardsType1(
      height: 250,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Columna izquierda
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resumen de la Clase', style: textStyle.titleLarge),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ocurrence.classSession.nombre,
                        style: textStyle.titleMedium,
                      ),
                      Text(
                        ocurrence.classSession.instructor,
                        style: textStyle.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      Text('Fecha', style: textStyle.titleLarge),
                      Text(fechaFormateada, style: textStyle.titleMedium),
                      const SizedBox(height: 10),
                      Text('Duración', style: textStyle.titleLarge),
                      Text(duracionFormateada, style: textStyle.titleMedium),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Columna derecha
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: FilledButton(
                    onPressed: () {},
                    child: Text(
                      ocurrence.classSession.nivel,
                      style: textStyle.bodySmall,
                    ),
                  ),
                ),
                const SizedBox(height: 44),
                Text('Hora', style: textStyle.titleLarge),
                Text('$horaInicio - $horaFinal', style: textStyle.titleMedium),
                const SizedBox(height: 10),
                Text('Ubicación', style: textStyle.titleLarge),
                Text(ocurrence.classSession.sala, style: textStyle.titleMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodSelector extends StatelessWidget {
  final List<CreditCard> creditCards;
  const PaymentMethodSelector({super.key, required this.creditCards});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        PaymentMethod? selectedMethod;
        if (state is PaymentSelected) {
          selectedMethod = state.method;
        }

        return Column(
          children: [
            // 👉 Créditos de clase
            CustomCardsType2(
              height: 70,
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: RadioListTile<PaymentMethod>(
                  value: const PaymentMethod.credit(),
                  groupValue: selectedMethod,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<PaymentCubit>().selectMethod(value);
                    }
                  },
                  title: const Text('Créditos de clase'),
                  controlAffinity: ListTileControlAffinity.trailing,
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('15 disponibles', style: textStyle.titleMedium),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 👉 Tarjetas guardadas
            if (creditCards.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: creditCards.length,
                itemBuilder: (context, index) {
                  final card = creditCards[index];
                  return FadeInLeft(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CustomCardsType2(
                        height: 70,
                        width: double.maxFinite,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: RadioListTile<PaymentMethod>(
                            value: PaymentMethod.card(card),
                            groupValue: selectedMethod,
                            onChanged: (value) {
                              if (value != null) {
                                context.read<PaymentCubit>().selectMethod(
                                  value,
                                );
                              }
                            },
                            title: Text('${card.brand} •••• ${card.lastFour}'),
                            controlAffinity: ListTileControlAffinity.trailing,
                            subtitle: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: Text(
                                'Expira el ${card.expMonth}/${card.expYear}',
                                style: textStyle.titleMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 10),

            // 👉 Nueva tarjeta
            GestureDetector(
              onTap: () {
                context.push('/new_card');
              },
              child: CustomCardsType2(
                height: 60,
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Center(
                    child: Text(
                      'Agregar Nueva Tarjeta',
                      style: textStyle.titleLarge,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ReserveButton extends StatelessWidget {
  final Ocurrence ocurrence;

  const ReserveButton({super.key, required this.ocurrence});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReservationCubit, ReservationState>(
      listener: (context, state) {
        if (state.status == ReservationStatus.loaded) {
          // 👉 Navegamos solo cuando la reserva esté confirmada
          context.go('/Home/succesPay');
        } else if (state.status == ReservationStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al crear reserva: ${state.errorMessage} ❌'),
            ),
          );
        }
      },
      child: BlocBuilder<ReservationCubit, ReservationState>(
        builder: (context, state) {
          final isLoading = state.status == ReservationStatus.loading;

          return FilledButton(
            onPressed: isLoading
                ? null
                : () {
                    final paymentState = context.read<PaymentCubit>().state;

                    if (paymentState is PaymentSelected) {
                      final method = paymentState.method;
                      final paymentMethod = method.type.name;
                      final cardId = method.card?.id;

                      context.read<ReservationCubit>().createReservation(
                        ocurrenceId: ocurrence.id,
                        paymentMethod: paymentMethod,
                        cardId: cardId!,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Selecciona un método de pago antes de reservar ⚠️',
                          ),
                        ),
                      );
                    }
                  },
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.cafeNoir),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Reservar'),
          );
        },
      ),
    );
  }
}
