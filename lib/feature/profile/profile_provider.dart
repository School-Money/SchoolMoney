import 'package:flutter/material.dart';
import 'package:school_money/feature/profile/profile_service.dart';
import 'model/profile.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  Profile? _profile;
  bool _isLoading = false;

  Profile? get profile => _profile;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      _profile = await _profileService.getProfileInfo();
    } catch (e) {
      // nothing
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
