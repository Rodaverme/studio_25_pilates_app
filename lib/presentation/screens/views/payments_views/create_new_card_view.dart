import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/payment/credit_card/credit_card_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/payment/credit_card/form_credit_card/form_credit_card_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/payment/merchants/merchants_cubit.dart';
import 'package:studio_25_pilates_app/presentation/utils/input_decorations.dart';

class CreateNewCardView extends StatelessWidget {
  const CreateNewCardView({super.key});

  @override
  Widget build(BuildContext context) {
    final formsCreditCardCubit = context.watch<FormsCreditCardCubit>();
    final creditCard = formsCreditCardCubit.state.formCreditCard;
    final dateExpired = formsCreditCardCubit.state.dateExpired;
    final securityCode = formsCreditCardCubit.state.securityCode;
    final owner = formsCreditCardCubit.state.ownerCard;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Tarjeta', style: textStyle.titleLarge),
        centerTitle: true,
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              TextFormField(
                onChanged: formsCreditCardCubit.ownerCardChange,
                autocorrect: false,
                keyboardType: TextInputType.text,
                decoration:
                    InputDecorations.authInputDecoration(
                      hintText: 'Ingrese nombre',
                      labelText: 'Nombre del propietario',
                      errorText: owner.errorMessage,
                    ).copyWith(
                      icon: Icon(
                        Icons.person,
                        size: 30,
                        color: AppColors.cafeNoir,
                      ),
                    ),
              ),
              SizedBox(height: 20),

              /// Número de tarjeta
              TextFormField(
                onChanged: formsCreditCardCubit.creditCardChange,
                autocorrect: false,
                keyboardType: TextInputType.number,
                decoration:
                    InputDecorations.authInputDecoration(
                      hintText: '0000 0000 0000 0000',
                      labelText: 'Número de tarjeta de crédito',
                      errorText: creditCard.errorMessage,
                    ).copyWith(
                      icon: Icon(
                        Icons.credit_card,
                        size: 30,
                        color: AppColors.cafeNoir,
                      ),
                    ),
              ),

              const SizedBox(height: 20),

              /// Fecha y CVV
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: formsCreditCardCubit.dateExpiredChange,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecorations.authInputDecoration(
                            hintText: 'MM/AA',
                            labelText: 'Fecha de vencimiento',
                            errorText: dateExpired.errorMessage,
                          ).copyWith(
                            icon: Icon(
                              Icons.date_range_outlined,
                              color: AppColors.cafeNoir,
                              size: 30,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      onChanged: formsCreditCardCubit.securityCodeChange,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecorations.authInputDecoration(
                            hintText: 'CVV',
                            labelText: 'Código de seguridad',
                            errorText: securityCode.errorMessage,
                          ).copyWith(
                            icon: Icon(
                              Icons.security,
                              color: AppColors.cafeNoir,
                              size: 30,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                '🔒 Tu información está protegida. Los datos de tu tarjeta se guardan de forma segura y nunca serán compartidos con terceros. Usa únicamente tarjetas personales y verifica que los datos sean correctos antes de continuar.',
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: textStyle.bodySmall,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final merch = context
                        .read<MerchantsCubit>()
                        .state
                        .merchants;

                    final isFormValid =
                        owner.isValid &&
                        creditCard.isValid &&
                        dateExpired.isValid &&
                        securityCode.isValid;

                    final isMerchantsValid = merch != null;

                    return (isFormValid && isMerchantsValid)
                        ? () async {
                            formsCreditCardCubit.onSubmit();
                            print(
                              'el tipo de tarjeta es ${creditCard.cardTypeLabel}',
                            );

                            

                            final input = dateExpired.value;
                            final parts = input.split("/");
                            
                            // if (parts.length != 2) return; // seguridad

                            final expMonth = parts[0];
                            print(expMonth);
                            final expYear = parts[1];
                            print (expYear);

                            context.read<CreditCardCubit>().saveMyCard(
                              number: creditCard.value,
                              cvc: securityCode.value,
                              expMonth: expMonth,
                              expYear: expYear,
                              acceptPersonalAuth:
                              merch.presignedPersonalDataAuth,
                              cardHolder: owner.value,
                              acceptToken: merch.presignedAcceptance,
                            );
                          }
                        : null;
                  }(),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.cafeNoir),
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 20),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  child: Text('Guardar Tarjeta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
