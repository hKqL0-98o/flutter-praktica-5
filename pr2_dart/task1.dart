import 'dart:math';

class MathProcessor {
  final List<double> numbers;

  MathProcessor(this.numbers);

  // Принимает функцию-обработчик и возвращает НОВЫЙ список
  List<double> process(double Function(double) handler) {
    return numbers.map(handler).toList();
  }

  // Статический метод: список случайных чисел от 0 до max
  static List<double> getRandomNumbers(int count, {double max = 100}) {
    final random = Random();
    return List.generate(count, (_) => random.nextDouble() * max);
  }
}

double square(double x) => x * x;

String fmt(List<double> list) {
  return list.map((x) => x.toStringAsFixed(2)).toList().toString();
}

void main() {
  final processor = MathProcessor([1.0, 2.0, 3.0, 4.0, 5.0]);

  print('Исходный список: ${fmt(processor.numbers)}');
  print('Квадраты (обычная функция): ${fmt(processor.process(square))}');
  print('Умножение на 2 (лямбда): ${fmt(processor.process((x) => x * 2))}');
  print('Прибавить 10 (лямбда): ${fmt(processor.process((x) => x + 10))}');

  print('');
  final randomList = MathProcessor.getRandomNumbers(5);
  final randomProcessor = MathProcessor(randomList);
  print('Случайные числа: ${fmt(randomProcessor.numbers)}');
  print('Их квадраты: ${fmt(randomProcessor.process(square))}');
}
