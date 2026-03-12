import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:travell_app/screens/custom_splash_screen.dart';
import 'package:travell_app/screens/home_screen.dart';
import 'package:travell_app/screens/login_screen.dart';
import 'package:travell_app/screens/register_screen.dart';
import 'package:travell_app/screens/settings_screen.dart';
import 'package:travell_app/screens/slider_screen.dart';
import 'package:travell_app/screens/verification_register.dart';
import 'package:travell_app/theme/app_colors.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travello',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.quaternary,
          secondary: AppColors.secondary,
          onSecondary: AppColors.quaternary,
          tertiary: AppColors.tertiary,
          onTertiary: AppColors.quaternary,
          surface: AppColors.quaternary,
          onSurface: AppColors.tertiary,
          surfaceContainerHighest: AppColors.secondary.withValues(alpha: 0.2),
          outline: AppColors.tertiary.withValues(alpha: 0.5),
          error: Colors.red.shade700,
          onError: AppColors.quaternary,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.quaternary,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.quaternary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.quaternary,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary),
          ),
          focusColor: AppColors.primary,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => CustomSplashScreen(),
        '/slide': (context) => SliderScreen(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/settings': (context) => SettingsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final String? email = settings.arguments as String?; // Capturamos el nombre
          return MaterialPageRoute(
            builder: (context) => HomeScreen(email: email), // Se lo pasamos al constructor
          );
        }
        if (settings.name == '/verification') {
          final email = settings.arguments as String; // Recibimos el string
          return MaterialPageRoute(
            builder: (context) => VerificationRegister(email: email),
          );
        }
        return null;
      },
    );
  }
}
