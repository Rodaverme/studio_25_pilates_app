import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/invitation/form_invitation_cubit.dart';
import 'package:studio_25_pilates_app/presentation/utils/input_decorations.dart';

class GuestView extends StatelessWidget {
  const GuestView({super.key, this.classId});
  final String? classId;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return BlocProvider(
      create: (_) => FormInvitationCubit(),
      child: BlocListener<FormInvitationCubit, FormsInvitationState>(
        listener: (context, state) {
          if (state.formStauts == FormInvitationStauts.validating) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Validando datos...")));
          }
          if (state.formStauts == FormInvitationStauts.posting) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Enviando invitación...")),
            );
          }
          if (state.formStauts == FormInvitationStauts.valid) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("✅ Invitación enviada"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Invita a un acompañante', style: textStyle.titleLarge),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/Logo6.png',
                  fit: BoxFit.cover,
                ),
              ),
              BlocBuilder<FormInvitationCubit, FormsInvitationState>(
                builder: (context, state) {
                  final cubit = context.read<FormInvitationCubit>();
                  final name = FormInvitationCubit().state.username;
                  final identification =
                      FormInvitationCubit().state.identificationInvitation;
                  final email = FormInvitationCubit().state.email;
                  final phone = FormInvitationCubit().state.phone;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: SizedBox(
                      height: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          Form(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                // Nombre
                                TextFormField(
                                  onChanged: cubit.usernameChange,
                                  decoration:
                                      InputDecorations.authInputDecoration(
                                        hintText: 'Ingrese nombre',
                                        labelText: 'Nombre',
                                        errorText: name.errorMessage,
                                      ).copyWith(
                                        icon: const Icon(
                                          Icons.person,
                                          size: 30,
                                          color: AppColors.cafeNoir,
                                        ),
                                      ),
                                ),
                                const SizedBox(height: 20),
                      
                                // Identificación
                                TextFormField(
                                  onChanged: cubit.identificationChange,
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      InputDecorations.authInputDecoration(
                                        hintText: 'Cédula',
                                        labelText: 'Número de identidad',
                                        errorText: identification.errorMessage,
                                      ).copyWith(
                                        icon: const Icon(
                                          Icons.perm_identity,
                                          size: 30,
                                          color: AppColors.cafeNoir,
                                        ),
                                      ),
                                ),
                                const SizedBox(height: 20),
                      
                                // Email (opcional)
                                TextFormField(
                                  onChanged: cubit.emailChange,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration:
                                      InputDecorations.authInputDecoration(
                                        hintText: 'example@dominio.com',
                                        labelText:
                                            'Correo electrónico (opcional)',
                                        errorText: email.errorMessage,
                                      ).copyWith(
                                        icon: const Icon(
                                          Icons.email,
                                          color: AppColors.cafeNoir,
                                          size: 30,
                                        ),
                                      ),
                                ),
                                const SizedBox(height: 20),
                      
                                // Teléfono (opcional)
                                TextFormField(
                                  onChanged: cubit.phoneChange,
                                  keyboardType: TextInputType.phone,
                                  decoration:
                                      InputDecorations.authInputDecoration(
                                        hintText: 'Celular',
                                        labelText: 'Número de celular (opcional)',
                                        errorText: phone.errorMessage,
                                      ).copyWith(
                                        icon: const Icon(
                                          Icons.phone_android_rounded,
                                          color: AppColors.cafeNoir,
                                          size: 30,
                                        ),
                                      ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                      
                          /// Botón Invitar
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: state.isValid
                                  ? () {
                                      cubit.onSubmit();
                                    }
                                  : null,
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  state.isValid
                                      ? AppColors.almendra
                                      : AppColors.arena,
                                ),
                                padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 20),
                                ),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              child:
                                  state.formStauts == FormInvitationStauts.posting
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Invitar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
