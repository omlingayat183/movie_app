import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_state.dart';

class _User {
  final String name;
  final String email;
  final String password;
  final String language;

  _User({
    required this.name,
    required this.email,
    required this.password,
    required this.language,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'language': language,
      };

  static _User fromJson(Map<String, dynamic> json) {
    return _User(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      language: json['language'] as String,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  static const _usersKey = 'users';
  static const _currentUserKey = 'currentUserEmail';
  final SharedPreferences _prefs;

  AuthCubit(this._prefs) : super(AuthInitial()) {
   
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    final currentEmail = _prefs.getString(_currentUserKey);
    if (currentEmail != null && currentEmail.isNotEmpty) {
     
      final raw = _prefs.getStringList(_usersKey) ?? [];
      final existingUsers = raw
          .map((e) => _User.fromJson(json.decode(e) as Map<String, dynamic>))
          .toList();

      final match = existingUsers.firstWhere(
        (u) => u.email == currentEmail,
        orElse: () => _User(name: '', email: '', password: '', language: ''),
      );
      if (match.email.isNotEmpty) {
        
        emit(AuthAuthenticated(
          AuthUser(name: match.name, email: match.email, language: match.language),
        ));
        return;
      }
    }
   
    emit(AuthLoggedOut());
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String language,
  }) async {
    emit(AuthLoading());
    try {
      final raw = _prefs.getStringList(_usersKey) ?? [];
      final existingUsers = raw
          .map((e) => _User.fromJson(json.decode(e) as Map<String, dynamic>))
          .toList();

      final duplicate = existingUsers.any((u) => u.email == email.trim());
      if (duplicate) {
        emit(AuthError('Email already registered.'));
        return;
      }

      final newUser = _User(
        name: name.trim(),
        email: email.trim(),
        password: password,
        language: language,
      );
      existingUsers.add(newUser);

      final encodedList =
          existingUsers.map((u) => json.encode(u.toJson())).toList();
      await _prefs.setStringList(_usersKey, encodedList);

      
      await _prefs.setString(_currentUserKey, newUser.email);

     
      emit(AuthAuthenticated(
        AuthUser(name: newUser.name, email: newUser.email, language: newUser.language),
      ));
    } catch (e) {
      emit(AuthError('Registration failed: $e'));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final raw = _prefs.getStringList(_usersKey) ?? [];
      final existingUsers = raw
          .map((e) => _User.fromJson(json.decode(e) as Map<String, dynamic>))
          .toList();

      final match = existingUsers.firstWhere(
        (u) => u.email == email.trim() && u.password == password,
        orElse: () => _User(name: '', email: '', password: '', language: ''),
      );

      if (match.email.isEmpty) {
        emit(AuthError('Invalid email or password.'));
      } else {
        
        await _prefs.setString(_currentUserKey, match.email);

        emit(AuthAuthenticated(
          AuthUser(name: match.name, email: match.email, language: match.language),
        ));
      }
    } catch (e) {
      emit(AuthError('Login failed: $e'));
    }
  }

  void logout() {
    _prefs.remove(_currentUserKey);
    emit(AuthLoggedOut());
  }
}
