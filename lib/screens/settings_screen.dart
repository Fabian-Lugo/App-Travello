import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:travell_app/services/database_service.dart';
import 'package:travell_app/theme/app_assets.dart';
import 'package:travell_app/theme/app_colors.dart';
import 'package:travell_app/widgets/account_info_style.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool nightMode = false;

  /// Método asíncrono para eliminar la cuenta del usuario de Firebase y Firestore
  Future<void> _deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    final db = DatabaseService();

    try {
      if (user != null) {
        // Elimina los datos primero
        await db.deleteUserData(user.uid);
      }
      // Luego borra el perfil de autenticación
      await user?.delete();
      if (mounted) {
        context.go('/login');
      }
    } on FirebaseException catch (e) {
      if (e.code == 'requires-recent-login') {
        debugPrint('El usuario necesita re-autenticarse');
      }
    }
  }

  /// Método para confirmar antes de eliminar la cuenta
  void _confirmDelete() {
    showDialog<void>(
      context: context,
      builder: (context) => _DeleteAccountDialog(
        onConfirm: () {
          Navigator.pop(context);
          _deleteAccount();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.quaternary,
        title: Text(
          'Configuración',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: AppColors.tertiary,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Image.asset(
            AppAssets.arrowLeft,
            color: AppColors.black50,
            width: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tema',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: AppColors.tertiary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _ThemeSettings(
              nightMode: nightMode,
              onChanged: (newValue) {
                setState(() {
                  nightMode = newValue;
                });
              },
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _confirmDelete,
              child: const AccountInfoStyle(
                text: 'Cuenta',
                info: 'Eliminar cuenta',
                image: AppAssets.trash,
                isDelicade: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget privado para el control (switch) del tema modo oscuro/claro
class _ThemeSettings extends StatelessWidget {
  final bool nightMode;
  final ValueChanged<bool> onChanged;

  const _ThemeSettings({
    required this.nightMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: AppColors.quaternary,
        border: Border.all(width: 0.5, color: AppColors.tertiary),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  nightMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  size: 22,
                  color: nightMode
                      ? const Color(0xFF1A237E)
                      : const Color(0xFFF9A825),
                ),
                const SizedBox(width: 10),
                Text(
                  nightMode ? 'Modo oscuro' : 'Modo claro',
                  style: GoogleFonts.poppins(
                    color: AppColors.tertiary,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Switch(
              value: nightMode,
              onChanged: onChanged,
              activeTrackColor: AppColors.primary.withOpacity(0.4),
              activeThumbColor: AppColors.primary,
              inactiveThumbColor: AppColors.black50,
              inactiveTrackColor: AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }
}

/// Modal de confirmación (dialog) extraido a un componente privado
class _DeleteAccountDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const _DeleteAccountDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        '¿Eliminar cuenta?',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: AppColors.tertiary,
        ),
      ),
      content: Text(
        'Se borrarán todos tus datos de forma permanente. '
        'Esta acción no se puede deshacer.\n\n'
        '¿Estás seguro de que deseas continuar?',
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: AppColors.tertiary,
          height: 1.4,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancelar',
            style: GoogleFonts.poppins(
              color: AppColors.tertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(
            'Eliminar cuenta',
            style: GoogleFonts.poppins(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}