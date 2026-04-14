import 'package:firebase_auth/firebase_auth.dart';
import 'package:travell_app/models/user_model.dart';

UserCredential? currentUserCredential;
UserModel? currentUserModel;

/// Global access to the active user data (from login or register)
UserModel? get currentAppUser => currentUserModel;