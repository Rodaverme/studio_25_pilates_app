import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:studio_25_pilates_app/presentation/providers/blocs/register/register_cubit.dart';
import 'package:studio_25_pilates_app/presentation/utils/input_decorations.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('Registrate'), centerTitle: true),
      body: BlocProvider(
        create: (context) => RegisterCubit(),
        child: SafeArea(
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          SizedBox(height: 20),
                          Text(
                            'Únete a nuestra comunidad',
                            style: textStyle.titleLarge,
                          ),
                          SizedBox(height: 60),

                          _RegisterForm(),

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
                              style: textStyle.titleMedium?.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    final registerCubit = context.watch<RegisterCubit>();
    final username = registerCubit.state.username;
    final password = registerCubit.state.password;
    final email = registerCubit.state.email;
    return Form(
      child: Column(
        children: [
          //Campo de nombre
          TextFormField(
            onChanged: registerCubit.usernameChange,
            keyboardType: TextInputType.text,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'Nombre',
              labelText: 'Ingrese su nombre',
              errorText: username.errorMessage
            ),
          ),
          SizedBox(height: 20),
          //Campo de email
          TextFormField(
            onChanged: registerCubit.emailChange,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'Correoelectrónico@dominio.com',
              labelText: 'Ingrese su correo',
              errorText:  email.errorMessage
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            onChanged: registerCubit.passwordChange,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecorations.authInputDecoration(
              hintText: '*********',
              labelText: 'Ingrese su contraseña',
              errorText: password.errorMessage
            ),
          ),
          SizedBox(height: 60),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (username.isValid & email.isValid & password.isValid ) {
                  context.go('/');
                  
                }
                registerCubit.onSubmit();
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
        ],
      ),
    );
  }
}
