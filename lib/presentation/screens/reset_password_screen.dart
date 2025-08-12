import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/forms/forms_cubit.dart';
import 'package:studio_25_pilates_app/presentation/utils/input_decorations.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nombre de la Aplicación'),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => FormsCubit(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _ResetPassword(textStyle: textStyle),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ResetPassword extends StatelessWidget {
  const _ResetPassword({required this.textStyle});

  final TextTheme textStyle;

  @override
  Widget build(BuildContext context) {
    final formsCubit = context.watch<FormsCubit>();
    final email = formsCubit.state.email;
    return Form(
      child: Column(
        children: [
          const Spacer(),
          const SizedBox(height: 20),
          Text('Recupera tu cuenta', style: textStyle.titleLarge),
          const SizedBox(height: 20),
          TextFormField(
            onChanged: formsCubit.emailChange,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'Correoelectrónico@dominio.com',
              labelText: 'Ingrese su correo',
              errorText: email.errorMessage
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                // TODO: Validar login y navegar al home
                if (email.isValid) {
                  //TODO ENVIAR CORREO PARA RECUPERAR CONTRASEÑA 
                  
                }
                  formsCubit.onSubmit();
              },
              style: ButtonStyle(
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 20),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              child: const Text('Continuar', style: TextStyle(fontSize: 15)),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Volver al'),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text('Login'),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Aun no tienes cuenta?'),
              TextButton(
                onPressed: () => context.push('/register'),
                child: Text(
                  'Registrate',
                  style: textStyle.titleMedium?.copyWith(fontSize: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
