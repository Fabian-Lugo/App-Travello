import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travell_app/theme/app_assets.dart';
import 'package:travell_app/theme/app_colors.dart';
import 'package:travell_app/widgets/account_info_style.dart';
import 'package:travell_app/widgets/button_style_default.dart';

class ProfileContent extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String password;
  const ProfileContent({
    super.key,
    required this.name,
    required this.email,
    this.phone = '999888777',
    this.password = 'example123',
  });

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.quaternary,
        actions: [ 
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: Icon(CupertinoIcons.settings_solid, color: AppColors.black50),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
        child: Column(
          children: [
            Center(
              child: ClipOval(
                child: Image.asset(
                  AppAssets.boy_2, 
                  width: 150, 
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(widget.name,
              style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Text('Masculino',
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 35),
            AccountInfoStyle(text: 'Correo', info: widget.email, image: AppAssets.mail),
            const SizedBox(height: 15),
            AccountInfoStyle(text: 'Telefono', info: widget.phone, image: AppAssets.mobile),
            const SizedBox(height: 15),
            AccountInfoStyle(text: 'Contraseña', info: widget.password, image: AppAssets.secure, image2: AppAssets.eye1, image3: AppAssets.eye2, secondIcon: true),
            const SizedBox(height: 30),
            ButtonStyleDefalt(text: 'Cerrar sesión', onTap: () => debugPrint('Usuario: Cerrar sesión'), isSecondStyle: true,)
          ],
        ),
      ),
    );
  }
}