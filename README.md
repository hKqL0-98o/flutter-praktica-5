# flutter praktica 5

Практические работы по дисциплине «Мобильная разработка» (Dart / Flutter).

Студентка: Галина Стукова, группа ИСИП-308.

| Папка | Работа | Содержание |
|-------|--------|------------|
| `pr1_dart/` | Практическая работа №1 | Основы Dart: переменные и типы, FizzBuzz, подсчёт гласных, калькулятор, калькулятор матриц |
| `pr2_dart/` | Практическая работа №2 | ООП в Dart: MathProcessor, фигуры, PasswordValidator, банковская система, RPG-персонажи |
| `pr7_flutter/` | Практическая работа №7 | Flutter: карточка товара (Text, Image, Container, Row, Column) |

В каждой папке `pr1_dart` и `pr2_dart` лежат файлы `task1.dart` ... `task5.dart` и скриншоты результатов.

## Запуск

Dart-задачи:

```
dart run pr1_dart/task1.dart
```

Карточка товара (нужен установленный Flutter SDK):

```
cd pr7_flutter
flutter create .
flutter run
```

Команда `flutter create .` добавляет платформенные папки (android, ios, web и т. д.); код приложения находится в `pr7_flutter/lib/main.dart` и не перезаписывается.
