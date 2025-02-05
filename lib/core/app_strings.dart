class AppStrings {
  static const String male = 'Male';
  static const String female = 'Female';
  static const String other = 'Other';

  // Auth page
  static const String authPageTitle = 'Register Page';
  static const String emailLabel = 'Email';
  static const String emailPlaceholder = 'Enter your email';
  static const String firstNameLabel = 'First Name';
  static const String firstNamePlaceholder = 'Enter your first name';
  static const String lastNameLabel = 'Last Name';
  static const String lastNamePlaceholder = 'Enter your last name';
  static const String gender = 'Gender:';
  static const String passwordLabel = 'Password';
  static const String passwordPlaceholder = 'Enter your password';
  static const String signUp = 'Sign Up';
  static const String error = 'Error';
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String deleteUser = 'Delete User';
  static const String deleteUserMessage =
      'Are you sure you want to delete your account?';

  // Home page
  static String greetUser(String firstName, String lastName) =>
      'Hello $firstName $lastName, How are you today?';
  static const String allowLocation = 'Allow Location';
  static const String start = 'Start';
  static String notificationWillAppear(String hhmm) =>
      'The notification will appear at $hhmm';
  static const String notificationTitle = 'Notification Title';
  static const String notificationBody = 'Notification Body';
  static const String notificationPermissionTitle = 'Notification Permission';
  static const String notificationPermissionMessage =
      'Please enable notification permission to receive alerts.';
  static const String notificationPermissionConfirm = 'Settings';

  // Error messages
  static const String wrongEmailFormat = 'Please enter a valid email address';
  static const String wrongFirstNameFormat = 'Please enter a valid first name';
  static const String wrongLastNameFormat = 'Please enter a valid last name';
  static const String wrongPasswordError =
      'Password must contain at least 8 characters, including uppercase, lowercase letters and numbers';
  static const String invalidCredentials = 'Invalid email or password';
  static const String errorCreatingUser = 'Error creating user';
  static const String failedToDeleteUser = 'Failed to delete user';
  static const String failedToSignOut = 'Failed to sign out';
}
