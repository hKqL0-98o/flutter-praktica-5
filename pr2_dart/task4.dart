import 'dart:math';

class BankException implements Exception {
  final String message;

  BankException(this.message);

  @override
  String toString() => message;
}

class BankAccount {
  final String accountNumber;
  final String ownerName;
  double _balance = 0;

  BankAccount(this.ownerName) : accountNumber = _generateNumber();

  double get balance => _balance;

  // Случайный номер счёта из 10 цифр
  static String _generateNumber() {
    final random = Random();
    final buffer = StringBuffer();
    for (int i = 0; i < 10; i++) {
      buffer.write(random.nextInt(10));
    }
    return buffer.toString();
  }

  void deposit(double amount) {
    if (amount <= 0) {
      throw BankException('Сумма пополнения должна быть положительной');
    }
    _balance += amount;
  }

  void withdraw(double amount) {
    if (amount <= 0) {
      throw BankException('Сумма снятия должна быть положительной');
    }
    if (amount > _balance) {
      throw BankException('Недостаточно средств на счёте');
    }
    _balance -= amount;
  }

  void displayBalance() {
    print('Счёт $accountNumber ($ownerName): ${_balance.toStringAsFixed(2)}');
  }
}

class Bank {
  final List<BankAccount> accounts = [];

  BankAccount addAccount(String ownerName) {
    BankAccount account;
    // Генерируем номер, пока он не окажется уникальным
    do {
      account = BankAccount(ownerName);
    } while (findAccount(account.accountNumber) != null);
    accounts.add(account);
    return account;
  }

  BankAccount? findAccount(String accountNumber) {
    for (final account in accounts) {
      if (account.accountNumber == accountNumber) {
        return account;
      }
    }
    return null;
  }

  void transfer(String fromAccountNumber, String toAccountNumber, double amount) {
    final from = findAccount(fromAccountNumber);
    final to = findAccount(toAccountNumber);

    if (from == null) {
      throw BankException('Счёт отправителя не найден: $fromAccountNumber');
    }
    if (to == null) {
      throw BankException('Счёт получателя не найден: $toAccountNumber');
    }
    if (from == to) {
      throw BankException('Нельзя переводить деньги на тот же счёт');
    }

    // Если снять нельзя, withdraw выбросит ошибку, и пополнения не будет
    from.withdraw(amount);
    to.deposit(amount);
  }
}

void tryAction(String title, void Function() action) {
  try {
    action();
    print('$title: успешно');
  } on BankException catch (e) {
    print('$title: ошибка - $e');
  }
}

void main() {
  final bank = Bank();
  final anna = bank.addAccount('Анна');
  final boris = bank.addAccount('Борис');

  print('--- Новые счета ---');
  anna.displayBalance();
  boris.displayBalance();

  print('');
  print('--- Операции ---');
  tryAction('Пополнение Анны на 1000', () => anna.deposit(1000));
  tryAction('Пополнение на -50', () => anna.deposit(-50));
  tryAction('Снятие 300 у Анны', () => anna.withdraw(300));
  tryAction('Снятие 5000 у Анны', () => anna.withdraw(5000));

  print('');
  print('--- Переводы ---');
  tryAction('Перевод Анна -> Борис 200',
      () => bank.transfer(anna.accountNumber, boris.accountNumber, 200));
  tryAction('Перевод Анна -> Борис 9999',
      () => bank.transfer(anna.accountNumber, boris.accountNumber, 9999));
  tryAction('Перевод на несуществующий счёт',
      () => bank.transfer(anna.accountNumber, '0000000000', 10));

  print('');
  print('--- Итоговые балансы ---');
  anna.displayBalance();
  boris.displayBalance();

  final found = bank.findAccount('1111111111');
  print('Поиск счёта 1111111111: ${found == null ? 'не найден (null)' : found.ownerName}');
}
