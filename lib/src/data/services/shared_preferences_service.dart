

// import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_size_converter/src/data/model/user_profile.dart';

class SharedPreferencesService extends ChangeNotifier {
  
  /// Singleton-Instanz of SharedPreferencesService
  static final SharedPreferencesService _instance = SharedPreferencesService._internal();
  SharedPreferencesService._internal();
  factory SharedPreferencesService() => _instance;

  late SharedPreferences _prefs;

  UserProfile? _currentProfile;

  UserProfile? get currentProfile => _currentProfile;

  /// initialize the SharedPreferences instance and load the user profile
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await loadProfile();
  }

  /// Load the user profile from SharedPreferences
  Future<void> loadProfile() async {
    try {
      final String? jsonString = _prefs.getString('user_profile');
      if (jsonString != null) {
        _currentProfile = UserProfile.fromJson(jsonString);
        log("Profil erfolgreich geladen.");
      } else {
        log("Kein Profil gefunden.");
      }
      notifyListeners();
    } catch (e) {
      log("Fehler beim Laden des Profils: $e");
    }
  }

  /// Save the user profile to SharedPreferences
  Future<void> saveProfile(UserProfile profile) async {
    try {
      profile.updatedAt = DateTime.now();
      if (profile.createdAt == null) profile.createdAt = DateTime.now();

      final String jsonString = profile.toJson();
      await _prefs.setString('user_profile', jsonString);
      
      _currentProfile = profile;
      log("Profil gespeichert: $jsonString");
      
      notifyListeners();
    } catch (e) {
      log("Fehler beim Speichern des Profils: $e");
      throw Exception("Speichern fehlgeschlagen");
    }
  }

  /// Clear the user profile from SharedPreferences
  Future<void> clearProfile() async {
    await _prefs.remove('user_profile');
    _currentProfile = null;
    notifyListeners();
  }




}