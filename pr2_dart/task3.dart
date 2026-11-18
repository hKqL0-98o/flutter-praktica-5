class PasswordValidator {
  // Константные требования к паролю
  static const int minLength = 8;
  static const bool requireDigit = true;

  // Возвращает текст ошибки или null, если пароль подходит
  static String? check(String password) {
    if (password.length < minLength) {
      return 'пароль короче $minLength символов';
    }
    if (requireDigit && !password.contains(RegExp(r'[0-9]'))) {
      return 'в пароле нет ни одной цифры';
    }
    return null;
  }

  // Статический метод проверки: true, если пароль подходит
  static bool validate(String password) {
    return check(password) == null;
  }
}

void main() {
  final passwords = ['abc1', 'abcdefgh', 'password1', 'Flutter2024'];

  for (final password in passwords) {
    final error = PasswordValidator.check(password);
    if (PasswordValidator.validate(password)) {
      print('"$password" - пароль подходит');
    } else {
      print('"$password" - не подходит: $error');
    }
  }
}
