import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    child: Column(
                      children: [
                        const Spacer(),
                        const SizedBox(height: 20),
                        Text('Recupera tu cuenta', style: textStyle.titleLarge),
                        const SizedBox(height: 20),
                        TextFormField(
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecorations.authInputDecoration(
                            hintText: 'Correoelectrónico@dominio.com',
                            labelText: 'Ingrese su correo',
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              // TODO: Validar login y navegar al home
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
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
