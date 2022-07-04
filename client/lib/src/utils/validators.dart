class Validators {
  static final RegExp _emailRegExp = RegExp(
    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[\W]).{8,}$',
  );
  static final RegExp textOnlyRegExp = RegExp('[a-zA-Z ]');
  static final RegExp numberOnlyRegExp = RegExp('[0-9]');

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  static isValidPhoneNumber(String phoneNumber) {
    return numberOnlyRegExp.hasMatch(phoneNumber);
  }
}
