import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _currentUserKey = 'current_user_name';
  static const String _currentUserTypeKey = 'current_user_type';
  
  static String? _currentUserName;
  static String? _currentUserType;

  // Set current user (call this when user logs in or during onboarding)
  static Future<void> setCurrentUser(String userName, {String userType = 'student'}) async {
    _currentUserName = userName;
    _currentUserType = userType;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserKey, userName);
      await prefs.setString(_currentUserTypeKey, userType);
    } catch (e) {
      print('Error saving current user: $e');
    }
  }

  // Get current user name
  static Future<String?> getCurrentUserName() async {
    if (_currentUserName != null) {
      return _currentUserName;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentUserName = prefs.getString(_currentUserKey);
      return _currentUserName;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Get current user type
  static Future<String?> getCurrentUserType() async {
    if (_currentUserType != null) {
      return _currentUserType;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentUserType = prefs.getString(_currentUserTypeKey);
      return _currentUserType;
    } catch (e) {
      print('Error getting current user type: $e');
      return null;
    }
  }

  // Clear current user (call when user logs out)
  static Future<void> clearCurrentUser() async {
    _currentUserName = null;
    _currentUserType = null;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserKey);
      await prefs.remove(_currentUserTypeKey);
    } catch (e) {
      print('Error clearing current user: $e');
    }
  }

  // Generate user-specific storage key
  static Future<String> getUserStorageKey(String baseKey) async {
    final userName = await getCurrentUserName();
    if (userName != null) {
      return '${baseKey}_$userName';
    }
    return baseKey; // Fallback to base key if no user
  }
} 