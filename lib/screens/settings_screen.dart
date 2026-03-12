import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.quaternary,
        title: Text(
          'Configuración ',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 20, color: AppColors.tertiary),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context), icon: Image.asset(AppAssets.arrowLeft, color: AppColors.black50, width: 20,)
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Tema',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.tertiary),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
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
                          nightMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          size: 22,
                          color: nightMode ? const Color(0xFF1A237E) : const Color(0xFFF9A825),
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
                      onChanged: (newValue) {
                        setState(() {
                          nightMode = newValue;
                        });
                      },
                      activeTrackColor: AppColors.primary.withOpacity(0.4),
                      activeThumbColor: AppColors.primary,
                      inactiveThumbColor: AppColors.black50,
                      inactiveTrackColor: AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => debugPrint('Usuario: Eliminar cuenta'),
              child: AccountInfoStyle(text: 'Cuenta', info: 'Eliminar cuenta', image: AppAssets.trash, isDelicade: true)
            ),
          ],
        ),
      )
    );
  }
}