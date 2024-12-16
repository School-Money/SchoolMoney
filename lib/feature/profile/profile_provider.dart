import 'package:flutter/material.dart';
import 'package:school_money/feature/profile/profile_service.dart';
import 'model/profile.dart';
import 'dart:typed_data';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  Profile? _profile;
  Uint8List? _avatar;
  bool _isLoading = false;

  Profile? get profile => _profile;
  bool get isLoading => _isLoading;
  Uint8List? get avatar => _avatar;

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      _profile = await _profileService.getProfileInfo();
      _avatar = await _profileService.getProfileImage();
    } catch (e) {
      // nothing
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
