import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/presentation/utils/input_decorations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Text('Bienvenida', style: textStyle.titleLarge),
                        const SizedBox(height: 8),
                        const Text('Inicia sesión para continuar'),
                        const SizedBox(height: 70),
                        Expanded(
                          child: Form(
                            child: Column(
                              children: [
                                TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecorations.authInputDecoration(
                                    hintText: 'Correoelectrónico@dominio.com',
                                    labelText: 'Ingrese su correo',
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  autocorrect: false,
                                  obscureText: true,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecorations.authInputDecoration(
                                    hintText: '*********',
                                    labelText: 'Ingrese su contraseña',
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
                                    child: const Text(
                                      'Continuar',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextButton(
                                  onPressed: () => context.push('/resetPassword'),
                                  child: const Text('¿Olvidaste tu contraseña?'),
                                ),
                                const Spacer(),
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
                                const SizedBox(height: 50),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
