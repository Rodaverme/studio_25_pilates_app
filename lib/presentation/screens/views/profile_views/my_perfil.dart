import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/auth/auth_cubit.dart';

class MyPerfil extends StatefulWidget {
  const MyPerfil({super.key});

  @override
  State<MyPerfil> createState() => _MyPerfilState();
}

class _MyPerfilState extends State<MyPerfil> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _documentNumberController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _pathologyController = TextEditingController();
  final _birthdateController = TextEditingController();

  String? _selectedDocumentType;
  String? _selectedPersonType;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();

    // Cargar datos del usuario y tipos
    final authCubit = context.read<AuthCubit>();
    authCubit.getCurrentClient();
    authCubit.loadDocumentTypes();
    authCubit.loadGenderTypes();
    authCubit.loadOrganizationTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          final client = state.client;

          // Mientras carga datos
          if (state.isLoading && client == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // Rellenar datos cuando estén disponibles
          if (client != null && _nameController.text.isEmpty) {
            _nameController.text = client.name ?? '';
            _emailController.text = client.email ?? '';
            _phoneController.text = client.phone ?? '';
            _documentNumberController.text = client.documentNumber ?? '';
            _businessNameController.text = client.businessName ?? '';
            _pathologyController.text = client.pathology ?? '';
            _birthdateController.text =
                client.birthdate?.toString().split('T').first ?? '';

            // 👇 Fuerza conversión a String si llegan como int
            _selectedDocumentType = client.documentType?.toString();
            _selectedGender = client.gender?.toString();
            _selectedPersonType = client.personType?.toString();
          }

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/Logo6.png',
                  fit: BoxFit.cover,
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Campo obligatorio' : null,
                      ),
                      const SizedBox(height: 16),

                      // Email (solo lectura)
                      TextFormField(
                        controller: _emailController,
                        readOnly: false,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Teléfono
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Teléfono',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      // Tipo de documento
                      DropdownButtonFormField<String>(
                        value: _selectedDocumentType,
                        decoration: const InputDecoration(
                          labelText: 'Tipo de documento',
                          border: OutlineInputBorder(),
                        ),
                        items: state.documentTypes.entries
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.key,
                                child: Text(e.value),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedDocumentType = value),
                      ),
                      const SizedBox(height: 16),

                      // Número de documento
                      TextFormField(
                        controller: _documentNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Número de documento',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      // Tipo de persona
                      DropdownButtonFormField<String>(
                        value: _selectedPersonType,
                        decoration: const InputDecoration(
                          labelText: 'Tipo de persona',
                          border: OutlineInputBorder(),
                        ),
                        items: state.organizationTypes.entries
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.key,
                                child: Text(e.value),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedPersonType = value),
                      ),
                      const SizedBox(height: 16),

                      // Género
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: const InputDecoration(
                          labelText: 'Género',
                          border: OutlineInputBorder(),
                        ),
                        items: state.genderTypes.entries
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.key,
                                child: Text(e.value),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedGender = value),
                      ),
                      const SizedBox(height: 16),

                      // Fecha de nacimiento
                      TextFormField(
                        controller: _birthdateController,
                        decoration: const InputDecoration(
                          labelText: 'Fecha de nacimiento (YYYY-MM-DD)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                      const SizedBox(height: 16),

                      // Razón social
                      TextFormField(
                        controller: _businessNameController,
                        decoration: const InputDecoration(
                          labelText: 'Razón social',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Patología
                      TextFormField(
                        controller: _pathologyController,
                        decoration: const InputDecoration(
                          labelText: 'Patología y/o condición',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 24),

                      // Botón guardar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      final payload = {
                                        "name": _nameController.text,
                                        "email": _emailController.text,
                                        "avatar_url": "", // no se cambia
                                        "language": "es",
                                        "birthdate": _birthdateController.text,
                                        "gender":
                                            _selectedGender?.toString() ?? "1",
                                        "phone": _phoneController.text,
                                        "document_type":
                                            _selectedDocumentType?.toString() ??
                                            "3",
                                        "document_number":
                                            _documentNumberController.text,
                                        "business_name":
                                            _businessNameController.text,
                                        "pathology": _pathologyController.text,
                                        "person_type":
                                            _selectedPersonType?.toString() ??
                                            "2",
                                      };

                                      print("📤 Payload a enviar:");
                                      print(payload);

                                      context.read<AuthCubit>().updateUser(
                                        name: payload["name"]!,
                                        email: payload["email"]!,
                                        avatarUrl: payload["avatar_url"]!,
                                        language: payload["language"]!,
                                        birthdate: payload["birthdate"]!,
                                        gender: payload["gender"]!,
                                        phone: payload["phone"]!,
                                        documentType: payload["document_type"]!,
                                        documentNumber:
                                            payload["document_number"]!,
                                        businessName: payload["business_name"]!,
                                        pathology: payload["pathology"]!,
                                        personType: payload["person_type"]!,
                                      );

                                        ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Se Actualizo su perfil con exito',
                                          ),
                                        ),
                                      );

                                    } catch (e, stack) {
                                      print("❌ Error al guardar perfil: $e");
                                      print(stack);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Error al guardar perfil: $e',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                          child: state.isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Guardar cambios'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
