import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/auth_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/auth_respository_impl.dart';

import 'package:studio_25_pilates_app/presentation/providers/cubits/forms/forms_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/register/register_cubit.dart';
import 'package:studio_25_pilates_app/presentation/utils/input_decorations.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('Registrate'), centerTitle: true),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => FormsCubit()),
          BlocProvider(
            create: (context) => RegisterCubit(
              authRespository: AuthRespositoryImpl(
                datasource: AuthDatasourceImpl(),
              ),
            ),
          ),
        ],
        child: SafeArea(
          child: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                context.go('/');
              }

              if (state is RegisterError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
              // TODO: implement listener
            },
            builder: (context, state) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
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

                              _RegisterForm(
                                isLoading: state is RegisterLoading,
                              ),

                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Volver al'),
                                  TextButton(
                                    onPressed: () {
                                      context.go('/Home');
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
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({required this.isLoading});

  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    final formsCubit = context.watch<FormsCubit>();
    final username = formsCubit.state.username;
    final password = formsCubit.state.password;
    final confirmedPassword = formsCubit.state.confirmedPassword;
    final email = formsCubit.state.email;
    return Form(
      child: Column(
        children: [
          //Campo de nombre
          TextFormField(
            onChanged: formsCubit.usernameChange,
            keyboardType: TextInputType.text,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'Nombre',
              labelText: 'Ingrese su nombre',
              errorText: username.errorMessage,
            ),
          ),
          SizedBox(height: 20),
          //Campo de email
          TextFormField(
            onChanged: formsCubit.emailChange,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'Correoelectrónico@dominio.com',
              labelText: 'Ingrese su correo',
              errorText: email.errorMessage,
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            onChanged: formsCubit.passwordChange,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecorations.authInputDecoration(
              hintText: '*********',
              labelText: 'Ingrese su contraseña',
              errorText: password.errorMessage,
            ),
          ),
            SizedBox(height: 20),
          TextFormField(
            onChanged: formsCubit.confirmedPasswordChange,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecorations.authInputDecoration(
              hintText: '*********',
              labelText: 'Confirmar contraseña',
              errorText: confirmedPassword.errorMessage,
            ),
          ),
          SizedBox(height: 60),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (!username.isValid ||
                    !email.isValid ||
                    !password.isValid ||
                    !confirmedPassword.isValid
                    ) {
                  return;
                }
                context.read<RegisterCubit>().register(
                  username.value,
                  email.value,
                  password.value,
                  confirmedPassword.value
                  
                );
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
