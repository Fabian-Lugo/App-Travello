import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:travell_app/router/app_routes.dart';
import 'package:travell_app/theme/app_colors.dart';
import 'package:travell_app/widgets/button_style_default.dart';

class VerificationRegisterScreen extends StatefulWidget {
  final String email;

  const VerificationRegisterScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerificationRegisterScreen> createState() =>
      _VerificationRegisterScreenState();
}

class _VerificationRegisterScreenState
    extends State<VerificationRegisterScreen> {
  /// Redirige al usuario a la pantalla de inicio de sesión
  void _changePage() {
    context.go(AppRoutes.login);
  }

  /// Regresa a la pantalla anterior, o a la de registro si no hay historial
  void _backPage() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.register);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
              child: Column(
                children: [
                  const _VerificationHeader(),
                  const SizedBox(height: 20),
                  _VerificationMessage(email: widget.email),
                  const SizedBox(height: 10),
                  _VerificationActions(
                    onChangePage: _changePage,
                    onBackPage: _backPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget privado que contiene el título principal de la pantalla
class _VerificationHeader extends StatelessWidget {
  const _VerificationHeader();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Casi finalizamos',
        textAlign: TextAlign.left,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 35,
        ),
      ),
    );
  }
}

/// Widget privado que encapsula el mensaje de verificación y el correo mostrado
class _VerificationMessage extends StatelessWidget {
  final String email;

  const _VerificationMessage({
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '¡Casi listo! Revisa tu bandeja de entrada. Te enviamos un correo',
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(fontSize: 18),
          ),
        ),
        Row(
          children: [
            Text(
              'de verificación a ',
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            Flexible(
              child: Text(
                email,
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: AppColors.primary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Align(
          alignment: Alignment.centerLeft,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '¿Verificaste tu ',
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
                TextSpan(
                  text: 'cuenta?',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget privado para agrupar los botones de acción de la pantalla de verificación
class _VerificationActions extends StatelessWidget {
  final VoidCallback onChangePage;
  final VoidCallback onBackPage;

  const _VerificationActions({
    required this.onChangePage,
    required this.onBackPage,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        ButtonStyleDefalt(
          text: 'Iniciar sesion',
          onTap: onChangePage,
        ),
        SizedBox(height: height * 0.4),
        Row(
          children: [
             GestureDetector(
                onTap: onBackPage,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFF222222),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}