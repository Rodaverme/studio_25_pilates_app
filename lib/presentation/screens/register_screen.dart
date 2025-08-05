import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/presentation/utils/input_decorations.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('Registrate'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                SizedBox(height: 20),
                Text('Únete a nuestra comunidad', style: textStyle.titleLarge),
                SizedBox(height: 60),
                TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nombre',
                    labelText: 'Ingrese su nombre',
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecorations.authInputDecoration(
                    hintText: 'Correoelectrónico@dominio.com',
                    labelText: 'Ingrese su correo',
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecorations.authInputDecoration(
                    hintText: '*********',
                    labelText: 'Ingrese su contraseña',
                  ),
                ),
                SizedBox(height: 60),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      //TODO IMPLEMENTAR VALIDACION DE LOGIN Y NAVEGACION AL HOME_SCREEN
                    },
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 20),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(15),
                        ),
                      ),
                    ),
                    child: Text('Crear Cuenta', style: TextStyle(fontSize: 15)),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Volver al'),
                    TextButton(
                      onPressed: () {
                        context.go('/');
                      },
                      child: Text('Login'),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                Text('¿Aun no tienes cuenta?'),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Términos de servicio y Política de privacidad',
                    style: textStyle.titleMedium?.copyWith(fontSize: 16),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
