import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travell_app/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  final String? name;

  const HomeScreen({
    super.key,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _HomeContent(name: name),
          ),
        ),
      ],
    );
  }
}

/// Contenedor que agrupa los elementos estáticos principales de la pantalla Home
class _HomeContent extends StatelessWidget {
  final String? name;

  const _HomeContent({this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _WelcomeHeader(name: name),
        const SizedBox(height: 80),
        Image.asset('assets/welcome_image.png'),
        const SizedBox(height: 20),
        const _HomeStatusUpdate(),
      ],
    );
  }
}

/// Muestra un encabezado de bienvenida que se adapta si el nombre es muy largo
class _WelcomeHeader extends StatelessWidget {
  final String? name;

  const _WelcomeHeader({this.name});

  @override
  Widget build(BuildContext context) {
    // Si el nombre es largo, se divide en dos lineas para evitar desbordamientos
    return (name != null && name!.length > 6)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bienvenido',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 35),
                ),
              ),
              Text(
                name!,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 35,
                    color: AppColors.primary),
              ),
            ],
          )
        : Row(
            children: [
              Text(
                'Bienvenido ',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 35),
              ),
              if (name != null)
                Text(
                  name!,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 35,
                      color: AppColors.primary),
                ),
            ],
          );
  }
}

/// Widget informativo de estado, indicando que hay zonas de la app en desarrollo
class _HomeStatusUpdate extends StatelessWidget {
  const _HomeStatusUpdate();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Actualmente, la siguiente parte de "Actividad y Fragmentación del Hogar"\n está en desarrollo. La segunda parte estará disponible próximamente.',
        style: GoogleFonts.poppins(fontSize: 18),
      ),
    );
  }
}