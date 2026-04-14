import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:travell_app/router/app_routes.dart';
import 'package:travell_app/services/database_service.dart';
import 'package:travell_app/session/app_session.dart';
import 'package:travell_app/theme/app_colors.dart';

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({super.key});

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Removemos el splash nativo cuando se ha pintado el primer frame de Flutter
      FlutterNativeSplash.remove();
    });
    // Esperamos 2 segundos para mostrar nuestra pantalla personalizada antes de redirigir
    Future.delayed(const Duration(seconds: 2), _goToNext);
  }

  /// Verifica si el usuario ya inicio sesión para redirigirlo a Home 
  /// o de lo contrario enviarlo al tutorial (Slider).
  Future<void> _goToNext() async {
    if (!mounted) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Obtenemos los datos del usuario logueado antes de navegar al Inicio
      currentUserModel = await DatabaseService().getUserDataOnce(user.uid);
      if (mounted) {
        context.go(AppRoutes.home);
      }
    } else {
      context.go(AppRoutes.slider);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: const [
            Expanded(
              child: Center(
                child: _SplashLogo(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 32),
              child: _SplashFooter(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget privado que carga dinamicamente el logo principal con 
/// un ancho equivalente al 65% del ancho disponible (maxWidth * 0.65)
class _SplashLogo extends StatelessWidget {
  const _SplashLogo();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth * 0.65;
        return Image.asset(
          'assets/splash_logo.png',
          fit: BoxFit.contain,
          width: maxWidth,
        );
      },
    );
  }
}

/// Widget privado para el texto que aparece al final de la pantalla (footer)
class _SplashFooter extends StatelessWidget {
  const _SplashFooter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'developed with',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Flutter',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
