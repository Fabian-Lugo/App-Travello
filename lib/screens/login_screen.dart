import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travell_app/models/user_model.dart';
import 'package:travell_app/theme/app_assets.dart';
import 'package:travell_app/theme/app_colors.dart';
import 'package:travell_app/utils/input_style.dart';
import 'package:travell_app/widgets/button_style_default.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerText = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final _key = GlobalKey<FormState>();
  String? messageOnScreen;
  bool _obscureText = true;
  bool _rememberMe = false;

  final List<UserModel> users = [
    UserModel(user: 'user1@test.com', password: 'test123'),
    UserModel(user: 'user2@test.com', password: 'test123'),
    UserModel(user: 'User3@test.com', password: 'test123'),
  ];

  void _seePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  
  void loginValidate() {
    if (_key.currentState!.validate()) {
        bool? isValidUser = users.any((u) =>
          u.user == _controllerText.text.trim() &&
          u.password == _controllerPassword.text.trim());

        setState(() {
          if (isValidUser) {
            messageOnScreen = null;
            Navigator.pushNamed(
              context, '/home',
              arguments: _controllerText.text.trim(),
            );
          } else {
            messageOnScreen = 'Credenciales incorrecta';
          }
        });
    }
  }

  void registerForm() {
    _controllerText.clear();
    _controllerPassword.clear();
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    child: Center(
                      child: Image.asset(
                        'assets/image_screen.png',
                        height: size.height * 0.3,
                        fit: .contain,
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
                          Text('Bienvenido',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 40),
                          ),
                          const SizedBox(height: 15),
                          Text('Inicie sesión para acceder a su cuenta',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                        ],
                      )
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    Form(
                      key: _key,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _controllerText,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              if (messageOnScreen != null) {
                                setState(() {
                                  messageOnScreen = null;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Ingresa tu correo',
                              labelStyle: GoogleFonts.poppins(color: AppColors.black50),
                              filled: true,
                              fillColor: AppColors.gray,
                              enabledBorder: InputStyles.customBorder(),
                              focusedBorder: InputStyles.customBorder(),
                              errorBorder: InputStyles.customBorder(),
                              focusedErrorBorder: InputStyles.customBorder(),
                              suffixIcon: Align(
                                alignment: Alignment.centerRight,
                                widthFactor: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Image.asset(
                                    AppAssets.mail,
                                    width: 22,
                                    height: 22,
                                    color: AppColors.black50,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            validator: (value) => 
                            (value?.trim().isEmpty ?? true)
                            ? 'Ingresa tu correo'
                            : null,
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _controllerPassword,
                            keyboardType: TextInputType.text,
                            onChanged: (value) => setState(() {
                              messageOnScreen = null;
                            }),
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              labelStyle: GoogleFonts.poppins(color: AppColors.black50),
                              filled: true,
                              fillColor: AppColors.gray,
                              enabledBorder: InputStyles.customBorder(),
                              focusedBorder: InputStyles.customBorder(),
                              errorBorder: InputStyles.customBorder(),
                              focusedErrorBorder: InputStyles.customBorder(),
                              suffixIcon: Align(
                                alignment: Alignment.centerRight,
                                widthFactor: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: _controllerPassword.text.isNotEmpty
                                  ? GestureDetector(
                                    onTap: _seePassword,
                                    child: Image.asset(
                                      _obscureText ? AppAssets.eye2 : AppAssets.eye1,
                                      width: 22,
                                      height: 22,
                                      color: AppColors.black50,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                  : Image.asset(
                                      AppAssets.secure,
                                      width: 22,
                                      height: 22,
                                      color: AppColors.black50,
                                      fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            validator: (value) => 
                            (value?.trim().isEmpty ?? true)
                            ? 'Ingresa tu contraseña'
                            : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (messageOnScreen != null)
                      Text(messageOnScreen!,
                        style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 15, fontWeight: FontWeight.w600),
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
                                value: _rememberMe, 
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                side: const BorderSide(color: AppColors.black50, width: 2),
                                onChanged: (bool? newValue) =>
                                setState(() {
                                  _rememberMe = newValue!;
                                })
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Recordarme',
                              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.tertiary),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => debugPrint('Usuario: Cambiar Contraseña'),
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            child: Text('Cambiar contraseña',
                              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.primary),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 140),
                    ButtonStyleDefalt(text: 'Iniciar sesión', onTap: loginValidate),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text('Nuevo miembro?',
                              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.tertiary)
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: registerForm,
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Text('Registrate ahora',
                                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primary)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}