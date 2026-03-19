import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uzii_shop/models/user_profile_model.dart';
import 'package:uzii_shop/services/profile_storage_service.dart';

enum ProfileStatus { idle, loading, success, error }

class ProfileProvider extends ChangeNotifier {
  final ProfileStorageService _storage = ProfileStorageService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserProfile? _profile;
  ProfileStatus _status = ProfileStatus.idle;

  UserProfile? get profile => _profile;
  ProfileStatus get status => _status;
  bool get isLoading => _status == ProfileStatus.loading;

  // Load profile
  Future<void> loadProfile() async {
    _setStatus(ProfileStatus.loading);
    try {
      // Try loading from local storage first
      UserProfile? savedProfile = await _storage.loadProfile();

      if (savedProfile != null) {
        _profile = savedProfile;
      } else {
        // Fall back to Firebase Auth data
        final user = _auth.currentUser;
        if (user != null) {
          _profile = UserProfile(
            uid: user.uid,
            fullName: user.displayName ?? 'UziiShop User',
            email: user.email ?? '',
            phone: user.phoneNumber ?? '',
            photoUrl: user.photoURL ?? '',
          );
          await _storage.saveProfile(_profile!);
        }
      }
      _setStatus(ProfileStatus.success);
    } catch (e) {
      _setStatus(ProfileStatus.error);
    }
  }

  // Update profile
  Future<bool> updateProfile({
    required String fullName,
    required String phone,
  }) async {
    _setStatus(ProfileStatus.loading);
    try {
      // Update Firebase display name
      await _auth.currentUser?.updateDisplayName(fullName);

      // Update local profile
      _profile = _profile?.copyWith(
        fullName: fullName,
        phone: phone,
      );

      if (_profile != null) {
        await _storage.saveProfile(_profile!);
      }
      _setStatus(ProfileStatus.success);
      return true;
    } catch (e) {
      _setStatus(ProfileStatus.error);
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    await _storage.clearProfile();
    _profile = null;
    _setStatus(ProfileStatus.idle);
  }

  void _setStatus(ProfileStatus status) {
    _status = status;
    notifyListeners();
  }
}