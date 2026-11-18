import 'dart:io';

double calculate(double a, String op, double b) {
  if (b == 0 && (op == '/' || op == '%')) {
    throw ArgumentError('Деление на ноль невозможно');
  }
  switch (op) {
    case '+': return a + b;
    case '-': return a - b;
    case '*': return a * b;
    case '/': return a / b;
    case '%': return a % b;
    default:  throw ArgumentError('Неизвестный оператор: $op');
  }
}

// Целые результаты выводим без ".0" (тернарный оператор)
Object show(double result) =>
    (result.isFinite && result == result.truncateToDouble())
        ? result.toInt()
        : result;

// Разбор выражения с учётом приоритета: * / % выше, чем + -, скобки выше всех
class ExprParser {
  final String s;
  int pos = 0;

  ExprParser(String text) : s = text.replaceAll(',', '.');

  double parse() {
    double v = _expr();
    _skipSpaces();
    if (pos < s.length) {
      throw FormatException('лишний символ "${s[pos]}"');
    }
    return v;
  }

  void _skipSpaces() {
    while (pos < s.length && s[pos] == ' ') {
      pos++;
    }
  }

  bool _eat(String c) {
    _skipSpaces();
    if (pos < s.length && s[pos] == c) {
      pos++;
      return true;
    }
    return false;
  }

  // сложение и вычитание (низкий приоритет)
  double _expr() {
    double v = _term();
    while (true) {
      if (_eat('+')) {
        v = calculate(v, '+', _term());
      } else if (_eat('-')) {
        v = calculate(v, '-', _term());
      } else {
        return v;
      }
    }
  }

  // умножение, деление, остаток (высокий приоритет)
  double _term() {
    double v = _factor();
    while (true) {
      if (_eat('*')) {
        v = calculate(v, '*', _factor());
      } else if (_eat('/')) {
        v = calculate(v, '/', _factor());
      } else if (_eat('%')) {
        v = calculate(v, '%', _factor());
      } else {
        return v;
      }
    }
  }

  // число, скобки или минус перед числом
  double _factor() {
    if (_eat('-')) return -_factor();
    if (_eat('(')) {
      double v = _expr();
      if (!_eat(')')) throw FormatException('нет закрывающей скобки');
      return v;
    }
    _skipSpaces();
    int start = pos;
    while (pos < s.length && '0123456789.'.contains(s[pos])) {
      pos++;
    }
    double? number = double.tryParse(s.substring(start, pos));
    if (number == null) throw FormatException('ожидалось число');
    return number;
  }
}

double? readNumber(String prompt) {
  stdout.write(prompt);
  String text = stdin.readLineSync()?.trim().replaceAll(',', '.') ?? '';
  return double.tryParse(text);
}

void main() {
  double? a = readNumber('Первое число: ');
  stdout.write('Оператор (+, -, *, /, %): ');
  String op = (stdin.readLineSync() ?? '').trim();
  double? b = readNumber('Второе число: ');

  if (a == null || b == null) {
    print('Ошибка: введено не число');
    return;
  }

  try {
    double result = calculate(a, op, b);
    print('$a $op $b = ${show(result)}');
  } on ArgumentError catch (e) {
    print('Ошибка: ${e.message}');
  }

  stdout.write('Выражение с приоритетом (Enter - пропустить): ');
  String expr = (stdin.readLineSync() ?? '').trim();
  if (expr.isNotEmpty) {
    try {
      print('$expr = ${show(ExprParser(expr).parse())}');
    } on FormatException catch (e) {
      print('Ошибка в выражении: ${e.message}');
    } on ArgumentError catch (e) {
      print('Ошибка: ${e.message}');
    }
  }
}
