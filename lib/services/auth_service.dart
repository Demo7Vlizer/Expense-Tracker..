class AuthService {
  static const String predefinedEmail = 'user@example.com';
  static const String predefinedPassword = 'password123';

  static bool login(String email, String password) {
    return email == predefinedEmail && password == predefinedPassword;
  }
}
