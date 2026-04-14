import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:travell_app/models/user_model.dart';
import 'package:travell_app/router/app_routes.dart';
import 'package:travell_app/services/auth_service.dart';
import 'package:travell_app/services/database_service.dart';
import 'package:travell_app/theme/app_assets.dart';
import 'package:travell_app/theme/app_colors.dart';
import 'package:travell_app/widgets/button_style_default.dart';
import 'package:travell_app/widgets/account_info_style.dart';

class ProfileScreen extends StatefulWidget {
  final String? name;
  final String email;
  final String password;
  final String phone;

  const ProfileScreen({
    super.key,
    this.name,
    this.email = '',
    this.password = '',
    this.phone = '',
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DatabaseService _db = DatabaseService();
  Stream<UserModel?>? _userStream;
  bool _isCreatingDoc = false;

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  void _initializeStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userStream = _db.getUserData(user.uid);
    }
  }

  /// Crea un documento de perfil si el usuario no tiene datos previos en Firestore
  Future<void> _handleMissingDoc(User authUser) async {
    if (_isCreatingDoc) return;
    _isCreatingDoc = true;

    final fallbackUser = UserModel(
      uid: authUser.uid,
      name: widget.name ?? '',
      email: widget.email.isNotEmpty ? widget.email : (authUser.email ?? ''),
      password: widget.password.isNotEmpty
          ? widget.password
          : (authUser.refreshToken ?? ''),
      phone: widget.phone.isNotEmpty
          ? widget.phone
          : (authUser.phoneNumber ?? ''),
      profileImage: AppAssets.randomAvatar,
    );

    await _db.saveUserData(fallbackUser);
    _isCreatingDoc = false;
  }

  /// Cierra sesión en FirebaseAuth y redirige a pantalla de login
  void _signOut() async {
    AuthService.lastLoginPassword = null;
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  /// Muestra el BottomSheet para que el usuario pueda cambiar su avatar
  void _showAvatarPicker(BuildContext context, String uid) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _AvatarPickerSheet(uid: uid, db: _db),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || _userStream == null) {
      return const Scaffold(
        body: Center(child: Text('No hay sesión activa. Inicia sesión.')),
      );
    }

    return StreamBuilder<UserModel?>(
      stream: _userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Error al conectar con el servidor')),
          );
        }

        final userData = snapshot.data;

        if (userData == null) {
          // Si no existe perfil en la BD local de Firestore, lo creamos
          _handleMissingDoc(user);
          return const _ProfileLoadingScreen();
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.quaternary,
            actions: [
              IconButton(
                onPressed: () => context.push(AppRoutes.mestedSettingsPage),
                icon: const Icon(
                  CupertinoIcons.settings_solid,
                  color: AppColors.black50,
                ),
              ),
            ],
          ),
          body: _ProfileContent(
            userData: userData,
            onAvatarTap: () => _showAvatarPicker(context, user.uid),
            onSignOut: _signOut,
          ),
        );
      },
    );
  }
}

/// Pantalla temporal que se muestra mientras se prepara el perfil de usuario por 1ra vez
class _ProfileLoadingScreen extends StatelessWidget {
  const _ProfileLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Preparando perfil...'),
          ],
        ),
      ),
    );
  }
}

/// Contenedor principal de la pantalla de perfil, mantiene el build más organizado
class _ProfileContent extends StatelessWidget {
  final UserModel userData;
  final VoidCallback onAvatarTap;
  final VoidCallback onSignOut;

  const _ProfileContent({
    required this.userData,
    required this.onAvatarTap,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final avatarPath = userData.profileImage.isNotEmpty
        ? userData.profileImage
        : AppAssets.boy_2;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _ProfileAvatar(
              avatarPath: avatarPath,
              onTap: onAvatarTap,
            ),
            const SizedBox(height: 10),
            Text(
              userData.name,
              style: GoogleFonts.poppins(
                  fontSize: 30, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Text(
              'Tus datos:',
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 35),
            _ProfileInfoSection(user: userData),
            const SizedBox(height: 30),
            ButtonStyleDefalt(
              text: 'Cerrar sesión',
              onTap: onSignOut,
              isSecondStyle: true,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget visual para mostrar la imagen de usuario actual y un botón lapiz
class _ProfileAvatar extends StatelessWidget {
  final String avatarPath;
  final VoidCallback onTap;

  const _ProfileAvatar({
    required this.avatarPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipOval(
              child: Image.asset(
                avatarPath,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  AppAssets.boy_2,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black50,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  CupertinoIcons.pencil,
                  color: AppColors.quaternary,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Este widget apila todos los datos del usuario usando el estilo propio AccountInfoStyle
class _ProfileInfoSection extends StatelessWidget {
  final UserModel user;

  const _ProfileInfoSection({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AccountInfoStyle(
            text: 'Correo', info: user.email, image: AppAssets.mail),
        const SizedBox(height: 15),
        AccountInfoStyle(
            text: 'Teléfono', info: user.phone, image: AppAssets.mobile),
        const SizedBox(height: 15),
        AccountInfoStyle(
          key: const Key('profile_password'),
          text: 'Contraseña',
          info: (AuthService.lastLoginPassword ?? user.password).isNotEmpty
              ? (AuthService.lastLoginPassword ?? user.password)
              : '••••••',
          image: AppAssets.secure,
          image2: AppAssets.eye1,
          image3: AppAssets.eye2,
          secondIcon: true,
          initialObscureText: true,
        ),
      ],
    );
  }
}

/// Despliega una lista/cuadro de avatares disponibles en los assets al presionarlo
class _AvatarPickerSheet extends StatelessWidget {
  final String uid;
  final DatabaseService db;

  const _AvatarPickerSheet({
    required this.uid,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.quaternary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Elige tu avatar',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.tertiary,
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.95,
            ),
            itemCount: AppAssets.avatarList.length,
            itemBuilder: (context, index) {
              final path = AppAssets.avatarList[index];
              return GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  await db.updateProfileImage(uid, path);
                },
                child: ClipOval(
                  child: Image.asset(
                    path,
                    fit: BoxFit.cover,
                    width: 80,
                    height: 80,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
