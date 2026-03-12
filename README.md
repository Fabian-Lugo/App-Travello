# Travello

**Travello** es una aplicación Flutter para planificar y gestionar viajes. Incluye flujo de onboarding, login, registro, pantalla principal con pestañas (Inicio / Perfil), configuración con cambio de tema claro/oscuro y preparación para autenticación con Firebase.

---

## Tecnologías

| Tecnología     | Uso |
|----------------|-----|
| **Flutter**    | Framework multiplataforma (iOS, Android, Web) |
| **Dart**       | Lenguaje (SDK ^3.11.0) |
| **Google Fonts** | Tipografía Poppins |
| **Firebase**   | Dependencias incluidas (Core, Auth, Firestore) para uso futuro |
| **flutter_native_splash** | Splash nativo con color primario |

---

## Estructura del proyecto

```
lib/
├── main.dart                 # Punto de entrada, rutas y tema
├── models/
│   └── user_model.dart       # Modelo usuario (email, password)
├── screens/
│   ├── custom_splash_screen.dart
│   ├── slider_screen.dart    # Onboarding
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── verification_register.dart
│   ├── home_screen.dart      # Tabs Inicio / Perfil
│   └── settings_screen.dart
├── theme/
│   ├── app_colors.dart       # Paleta y colores tema oscuro
│   ├── app_assets.dart       # Rutas de iconos y avatares
│   └── theme_provider.dart   # Estado global tema claro/oscuro
├── utils/
│   └── input_style.dart      # Estilos de campos de texto
└── widgets/
    ├── button_style_default.dart
    ├── slide_item.dart / slide_dot.dart
    ├── home_content.dart / profile_content.dart
    └── account_info_style.dart
```

---

## Requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.11+
- (Opcional) Firebase CLI y FlutterFire para cuando se integre Auth/Firestore

---

## Instalación y ejecución

```bash
# Clonar / entrar al proyecto
cd travell-app

# Dependencias
flutter pub get

# Ejecutar
flutter run
```

---

## Rutas

| Ruta | Pantalla | Argumentos |
|------|----------|------------|
| `/` | Splash → redirige a `/slide` | — |
| `/slide` | Onboarding (3 slides) | — |
| `/login` | Login | — |
| `/register` | Registro | — |
| `/verification` | Post-registro (revisar correo) | `email` (String) |
| `/home` | Home (Inicio / Perfil) | `email` (String?) |
| `/settings` | Configuración (tema, eliminar cuenta) | — |

---

## Funcionalidades actuales

- **Onboarding:** 3 pantallas con PageView e indicadores.
- **Login:** Validación contra lista local de usuarios; recordar sesión; enlaces a registro y cambiar contraseña.
- **Registro:** Formulario (nombre, correo, teléfono, contraseña), términos y condiciones; navegación a verificación o login.
- **Home:** BottomNavigationBar (Inicio / Perfil); contenido por pestaña.
- **Perfil:** Datos de usuario, opción de configuración.
- **Configuración:** Toggle tema claro/oscuro (solo Home, Perfil y Settings); opción “Eliminar cuenta”.
- **Tema oscuro:** Estado global (`appNightMode`); fondos y textos coherentes; botones y textos en rojo se mantienen.

---

## Validación de usuarios

- **Actualmente:** La app valida contra una **lista en memoria** en `login_screen.dart` (`List<UserModel>`). Si el correo y la contraseña coinciden con algún elemento, se navega a `/home` con el email como argumento. No hay persistencia ni backend.
- **Próximo paso:** Integrar **Firebase Authentication** (y opcionalmente Firestore para perfil). Ver documento de arquitectura para el plan detallado.

---

## Documentación adicional

- **[ARQUITECTURA.md](docs/ARQUITECTURA.md)** — Arquitectura, flujos, validación actual y plan de migración a Firebase.

---

## Recursos

- [Flutter](https://docs.flutter.dev/)
- [Firebase para Flutter](https://firebase.google.com/docs/flutter/setup)
- [Google Fonts (Flutter)](https://pub.dev/packages/google_fonts)
