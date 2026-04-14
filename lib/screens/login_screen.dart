import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:travell_app/router/app_routes.dart';
import 'package:travell_app/services/database_service.dart';
import 'package:travell_app/session/app_session.dart';
import 'package:travell_app/theme/app_assets.dart';
import 'package:travell_app/theme/app_colors.dart';
import 'package:travell_app/widgets/button_style_default.dart';
import 'package:travell_app/widgets/redirect_text_button.dart';
import 'package:travell_app/widgets/travel_input_field.dart';
import 'package:travell_app/widgets/travel_password_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controllerTextEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final _key = GlobalKey<FormState>();
  String? messageOnScreen;
  bool _rememberMe = false;

  /// Método para validar los campos e iniciar sesión con Firebase Authentication
  Future<void> loginValidate() async {
    if (_key.currentState?.validate() ?? false) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: _controllerTextEmail.text.trim(),
              password: _controllerPassword.text.trim(),
            );

        if (mounted) {
          currentUserCredential = userCredential;
          
          // Se recupera la información de la base de datos de Firestore para la sesión
          final userModel = await DatabaseService().getUserDataOnce(userCredential.user!.uid);
          currentUserModel = userModel;

          context.go(AppRoutes.home);
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          setState(() {
            messageOnScreen = e.message;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // GestureDetector permite ocultar el teclado al hacer tap en un área sin textfield
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const _LoginHeader(),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    _LoginForm(
                      formKey: _key,
                      emailController: _controllerTextEmail,
                      passwordController: _controllerPassword,
                      rememberMe: _rememberMe,
                      messageOnScreen: messageOnScreen,
                      onRememberMeChanged: (value) => setState(() => _rememberMe = value),
                      onInputChanged: () => setState(() => messageOnScreen = null),
                    ),
                    const SizedBox(height: 30),
                    _LoginActions(
                      onLogin: loginValidate,
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Controla la parte visual superior del inicio de sesión (imagen y texto de bienvenida)
class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Center(
            child: Image.asset(
              'assets/image_screen.png',
              height: size.height * 0.3,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned(
          top: size.height * 0.275,
          left: 0,
          right: 0,
          child: Center(
            child: Column(
              children: [
                Text(
                  'Bienvenido',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 40),
                ),
                const SizedBox(height: 15),
                Text(
                  'Inicie sesión para acceder a su cuenta',
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

/// Contiene exclusivamente el formulario de entrada de datos (email, password y checkbox)
class _LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool rememberMe;
  final String? messageOnScreen;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onInputChanged;

  const _LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.rememberMe,
    this.messageOnScreen,
    required this.onRememberMeChanged,
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
                text: 'Correo',
                image: AppAssets.mail,
                controller: emailController,
                type: TextInputType.emailAddress,
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
        // Muestra error de autenticacion devuelto por Firebase (si existe)
        if (messageOnScreen != null)
          Text(
            messageOnScreen!, // El operador "!" está bien aqui porque el condicional if comprobó nulo antes
            style: GoogleFonts.poppins(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: rememberMe,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    side: const BorderSide(color: AppColors.black50, width: 2),
                    onChanged: (bool? newValue) => onRememberMeChanged(newValue ?? false),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Recordarme',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.tertiary,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => debugPrint('Usuario: Cambiar Contraseña'),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Text(
                  'Cambiar contraseña',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Widget agrupador de acciones secundarias: Botón iniciar sesión y boton de redirigir a registro
class _LoginActions extends StatelessWidget {
  final VoidCallback onLogin;

  const _LoginActions({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: size.height * 0.05),
        ButtonStyleDefalt(text: 'Iniciar sesión', onTap: onLogin),
        const SizedBox(height: 20),
        const RedirectTextButton(
          text: 'Nuevo miembro?',
          textLink: 'Registrate ahora',
        ),
      ],
    );
  }
}
