import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:travell_app/models/user_model.dart';
import 'package:travell_app/router/app_routes.dart';
import 'package:travell_app/services/database_service.dart';
import 'package:travell_app/session/app_session.dart';
import 'package:travell_app/theme/app_assets.dart';
import 'package:travell_app/theme/app_colors.dart';
import 'package:travell_app/widgets/button_style_default.dart';
import 'package:travell_app/widgets/redirect_text_button.dart';
import 'package:travell_app/widgets/travel_input_field.dart';
import 'package:travell_app/widgets/travel_password_field.dart';

class RegisterScren extends StatefulWidget {
  const RegisterScren({super.key});

  @override
  State<RegisterScren> createState() => _RegisterScrenState();
}

class _RegisterScrenState extends State<RegisterScren> {
  final TextEditingController _controllerTextName = TextEditingController();
  final TextEditingController _controllerTextEmail = TextEditingController();
  final TextEditingController _controllerIntPhone = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final _key = GlobalKey<FormState>();
  String? messageOnScreen;
  bool _checkBox = false;

  final DatabaseService _databaseService = DatabaseService();

  /// Valida los campos ingresados y registra un nuevo usuario en Firebase Auth y Firestore
  Future<void> registerValidate() async {
    // 1. Verificamos que el formulario cumpla con las validaciones (no campos vacios, email util, etc)
    if (_key.currentState?.validate() ?? false) {
      // 2. Comprobamos si el usuario aceptó los terminos obligatorios
      if (_checkBox) {
        try {
          // 3. Crear credenciales del usuario con Auth
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                email: _controllerTextEmail.text.trim(),
                password: _controllerPassword.text.trim(),
              );

          // 4. Instanciar el modelo del usuario con el nuevo UID
          UserModel newUser = UserModel(
            uid: userCredential.user?.uid ?? '',
            name: _controllerTextName.text.trim(),
            email: _controllerTextEmail.text.trim(),
            password: _controllerPassword.text.trim(),
            phone: _controllerIntPhone.text.trim(),
            profileImage: AppAssets.boy_1,
          );

          // 5. Almacenamos el documento en Firestore
          await _databaseService.saveUserData(newUser);
          
          // 6. Guardamos los datos de forma global para usar este mismo nombre al iniciar
          currentUserModel = newUser;

          if (mounted) {
            context.push(AppRoutes.verification, extra: newUser.email.trim());
          }
        } on FirebaseAuthException catch (e) {
          if (mounted) {
            setState(() {
              messageOnScreen = e.message;
            });
          }
        }
      } else {
        setState(() {
          messageOnScreen = 'Acepta los términos';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // GestureDetector atrapa toques en areas estáticas para ocultar el teclado desplegado
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const _RegisterHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    _RegisterForm(
                      formKey: _key,
                      nameController: _controllerTextName,
                      emailController: _controllerTextEmail,
                      phoneController: _controllerIntPhone,
                      passwordController: _controllerPassword,
                      acceptedTerms: _checkBox,
                      messageOnScreen: messageOnScreen,
                      onTermsChanged: (value) => setState(() => _checkBox = value),
                      onInputChanged: () => setState(() => messageOnScreen = null),
                    ),
                    const SizedBox(height: 40),
                    _RegisterActions(
                      onRegister: registerValidate,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pantalla superior que muestra el avatar/imagen de la app y un saludo en el formulario
class _RegisterHeader extends StatelessWidget {
  const _RegisterHeader();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Center(
            child: Image.asset(
              'assets/image_screen.png',
              height: size.height * 0.3,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned(
          top: size.height * 0.260,
          left: 0,
          right: 0,
          child: Center(
            child: Column(
              children: [
                Text(
                  'Empezemos',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 40),
                ),
                const SizedBox(height: 15),
                Text(
                  'Crea una cuenta gratuita',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Contenedor de formulario Form y text fields que reciben validación
class _RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool acceptedTerms;
  final String? messageOnScreen;
  final ValueChanged<bool> onTermsChanged;
  final VoidCallback onInputChanged;

  const _RegisterForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.acceptedTerms,
    this.messageOnScreen,
    required this.onTermsChanged,
    required this.onInputChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              TravelInputField(
                text: 'Nombre',
                image: AppAssets.user,
                controller: nameController,
                type: TextInputType.name,
                onChanged: onInputChanged,
              ),
              const SizedBox(height: 30),
              TravelInputField(
                text: 'Correo',
                image: AppAssets.mail,
                controller: emailController,
                type: TextInputType.emailAddress,
                onChanged: onInputChanged,
              ),
              const SizedBox(height: 30),
              TravelInputField(
                text: 'Número',
                image: AppAssets.mobile,
                controller: phoneController,
                type: TextInputType.phone,
                onChanged: onInputChanged,
              ),
              const SizedBox(height: 30),
              TravelPasswordField(
                controller: passwordController,
                onChanged: onInputChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Muestra error de la pantalla o de firebase si existe
        if (messageOnScreen != null)
          Text(
            messageOnScreen!,
            style: GoogleFonts.poppins(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        const SizedBox(height: 10),
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: acceptedTerms,
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                side: const BorderSide(color: AppColors.black50, width: 2),
                onChanged: (bool? newValue) => onTermsChanged(newValue ?? false),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Acepto los',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.tertiary,
              ),
            ),
            const SizedBox(width: 3),
            GestureDetector(
              onTap: () => debugPrint('Usuario: Términos'),
              child: Text(
                'Términos',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 3),
            Text(
              'y',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.tertiary,
              ),
            ),
            const SizedBox(width: 3),
            GestureDetector(
              onTap: () => debugPrint('Usuario: Condiciones'),
              child: Text(
                'Condiciones',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Este widget envuelve el botón de registro y el redirigir al login
class _RegisterActions extends StatelessWidget {
  final VoidCallback onRegister;

  const _RegisterActions({required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ButtonStyleDefalt(text: 'Crear cuenta', onTap: onRegister),
        const SizedBox(height: 20),
        const RedirectTextButton(
          text: 'Ya eres miembro?',
          textLink: 'Inicia sesión',
          isReturn: true,
        ),
      ],
    );
  }
}
