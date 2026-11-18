import 'dart:io';

void main() {
  stdout.write('Введите строку: ');
  String word = stdin.readLineSync()?.trim() ?? '';

  if (word.isEmpty) {
    print('Ошибка: строка пустая');
    return;
  }

  const vowels = 'aeiouy';
  int count = 0;

  for (int i = 0; i < word.length; i++) {
    if (vowels.contains(word[i].toLowerCase())) {
      count++;
    }
  }

  print('Слово: $word');
  print('Гласных букв: $count');
}
