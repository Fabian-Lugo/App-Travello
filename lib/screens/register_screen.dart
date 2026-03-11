import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travell_app/models/user_model.dart';
import 'package:travell_app/theme/app_colors.dart';
import 'package:travell_app/utils/input_style.dart';
import 'package:travell_app/widgets/button_style_default.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _controllerTextName = TextEditingController();
  final TextEditingController _controllerTextEmail = TextEditingController();
  final TextEditingController _controllerIntPhoneNumber = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final _key = GlobalKey<FormState>();
  String? messageOnScreen;
  bool _obscureText = true;
  bool _checkBox = false;

  void _seePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  
  void loginValidate() {
    setState(() {
      if (_key.currentState!.validate()) {
        messageOnScreen = null;
        if (_controllerIntPhoneNumber.text.length < 9) {
          messageOnScreen = 'Numero incompleto';
        } else if (_controllerIntPhoneNumber.text.length > 9){
          messageOnScreen = 'Error numero mayor a 9 caracteres';
        } else if (_checkBox != true){
          messageOnScreen = 'Marca la casilla';
        } else {
          setState(() {
            Navigator.pushNamed(context, '/home');
          });
        }
      } else {
        messageOnScreen = 'Campos incompletos';
      }
    });
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
                          Text('Empezemos',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 40),
                          ),
                          const SizedBox(height: 15),
                          Text('Crea una cuenta gratuita',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                        ],
                      )
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    Form(
                      key: _key,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _controllerTextName,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              if (messageOnScreen != null) {
                                setState(() {
                                  messageOnScreen = null;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Nombre',
                              labelStyle: TextStyle(color: AppColors.black50),
                              filled: true,
                              fillColor: AppColors.gray,
                              enabledBorder: InputStyles.customBorder(),
                              focusedBorder: InputStyles.customBorder(),
                              errorBorder: InputStyles.customBorder(),
                              focusedErrorBorder: InputStyles.customBorder(),
                              suffixIcon: Icon(Icons.person_2_outlined, color: AppColors.black50,)
                            ),
                            validator: (value) => 
                            (value?.trim().isEmpty ?? true)
                            ? 'Completa el campo'
                            : null,
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _controllerTextEmail,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              if (messageOnScreen != null) {
                                setState(() {
                                  messageOnScreen = null;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Correo',
                              labelStyle: TextStyle(color: AppColors.black50),
                              filled: true,
                              fillColor: AppColors.gray,
                              enabledBorder: InputStyles.customBorder(),
                              focusedBorder: InputStyles.customBorder(),
                              errorBorder: InputStyles.customBorder(),
                              focusedErrorBorder: InputStyles.customBorder(),
                              suffixIcon: Icon(Icons.email_outlined, color: AppColors.black50,)
                            ),
                            validator: (value) => 
                            (value?.trim().isEmpty ?? true)
                            ? 'Completa el campo'
                            : null,
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _controllerIntPhoneNumber,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (messageOnScreen != null) {
                                setState(() {
                                  messageOnScreen = null;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Numero',
                              labelStyle: TextStyle(color: AppColors.black50),
                              filled: true,
                              fillColor: AppColors.gray,
                              enabledBorder: InputStyles.customBorder(),
                              focusedBorder: InputStyles.customBorder(),
                              errorBorder: InputStyles.customBorder(),
                              focusedErrorBorder: InputStyles.customBorder(),
                              suffixIcon: Icon(Icons.phone, color: AppColors.black50,)
                            ),
                            validator: (value) => 
                            (value?.trim().isEmpty ?? true)
                            ? 'Completa el campo'
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
                              labelStyle: TextStyle(color: AppColors.black50),
                              filled: true,
                              fillColor: AppColors.gray,
                              enabledBorder: InputStyles.customBorder(),
                              focusedBorder: InputStyles.customBorder(),
                              errorBorder: InputStyles.customBorder(),
                              focusedErrorBorder: InputStyles.customBorder(),
                              suffixIcon: _controllerPassword.text.isNotEmpty
                              ? IconButton(
                                onPressed: _seePassword, 
                                icon: Icon(_obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.black50,)
                              )
                              : Icon(Icons.lock_outline_rounded, color: AppColors.black50,)
                            ),
                            validator: (value) => 
                            (value?.trim().isEmpty ?? true)
                            ? 'Completa el campo'
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
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: _checkBox, 
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                side: const BorderSide(color: AppColors.black50, width: 2),
                                onChanged: (bool? newValue) =>
                                setState(() {
                                  _checkBox = newValue!;
                                })
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Acepto los',
                              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.tertiary),
                            ),
                            const SizedBox(width: 3),
                            GestureDetector(
                              onTap: () => debugPrint('Usuario: Terminos'),
                              child: Text('Terminos',
                                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.primary),
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'y',
                              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.tertiary),
                            ),
                            const SizedBox(width: 3),
                            GestureDetector(
                              onTap: () => debugPrint('Usuario: Condiciones'),
                              child: Text('Condiciones',
                                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    ButtonStyleDefalt(text: 'Crear cuenta', onTap: loginValidate),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text('Ya eres miembro?',
                              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.tertiary)
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/login'),
                              child: Text('Inicia sesión',
                                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primary)
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