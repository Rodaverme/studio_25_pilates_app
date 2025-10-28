import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/domain/entities/credit_card.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/payment/credit_card/credit_card_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/payment/payment_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/payment/payment_state.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type2.dart';

class MyCards extends StatelessWidget {
  const MyCards({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Tarjetas'), centerTitle: true),
      body: Stack(
        children: [
          /// 🌄 Fondo de pantalla
          Positioned.fill(
            child: Image.asset(
              'assets/images/Logo6.png',
              fit: BoxFit.cover,
            ),
          ),

          /// 📄 Contenido principal
          BlocBuilder<CreditCardCubit, CreditCardState>(
            builder: (context, state) {
              // 🔹 Loading
              if (state.status == CreditCardStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              // 🔹 Error
              if (state.status == CreditCardStatus.error) {
                return Center(
                  child: Text(
                    'Error al cargar tus tarjetas:\n${state.errorMessage}',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              // 🔹 Lista vacía
              if (state.creditCard.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.credit_card_off,
                        size: 80,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 10),
                      const Text('No tienes tarjetas guardadas'),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => context.push('/new_card'),
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar nueva tarjeta'),
                      ),
                    ],
                  ),
                );
              }

              // 🔹 Si hay tarjetas cargadas
              return BlocBuilder<PaymentCubit, PaymentState>(
                builder: (context, payState) {
                  PaymentMethod? selectedMethod;
                  if (payState is PaymentSelected) {
                    selectedMethod = payState.method;
                  }

                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.builder(
                      itemCount: state.creditCard.length,
                      itemBuilder: (context, index) {
                        final CreditCard card = state.creditCard[index];
                        return FadeInLeft(
                          duration: const Duration(milliseconds: 250),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CustomCardsType2(
                              height: 80,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: RadioListTile<PaymentMethod>(
                                  value: PaymentMethod.card(card),
                                  groupValue: selectedMethod,
                                  onChanged: (value) {
                                    if (value != null) {
                                      context
                                          .read<PaymentCubit>()
                                          .selectMethod(value);
                                    }
                                  },
                                  title: Text(
                                    '${card.brand} •••• ${card.lastFour}',
                                    style: textStyle.titleMedium,
                                  ),
                                  subtitle: Text(
                                    'Expira ${card.expMonth}/${card.expYear}',
                                    style: textStyle.bodyMedium,
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/new_card'),
        label:  Text('Nueva Tarjeta',style: TextStyle(color: AppColors.piedra)),
        icon: const Icon(Icons.add_card,color: AppColors.piedra,),
        backgroundColor: AppColors.almendra,
      ),
    );
  }
}
