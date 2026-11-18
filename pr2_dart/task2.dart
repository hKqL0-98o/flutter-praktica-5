import 'dart:math' show pi;

abstract class Shape {
  // Явный обычный конструктор нужен, чтобы Circle и Rectangle могли наследоваться
  Shape();

  double area();

  // Создаёт Circle или Rectangle по данным JSON
  factory Shape.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    switch (type) {
      case 'circle':
        return Circle(Shape._readNumber(json, 'radius'));
      case 'rectangle':
        return Rectangle(
          Shape._readNumber(json, 'width'),
          Shape._readNumber(json, 'height'),
        );
      default:
        throw FormatException('Неизвестный тип фигуры: $type');
    }
  }

  static double _readNumber(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! num) {
      throw FormatException('Поле "$key" отсутствует или не является числом');
    }
    return value.toDouble();
  }
}

class Circle extends Shape {
  final double radius;

  Circle(this.radius);

  @override
  double area() => pi * radius * radius;
}

class Rectangle extends Shape {
  final double width;
  final double height;

  Rectangle(this.width, this.height);

  @override
  double area() => width * height;
}

void main() {
  final jsons = <Map<String, dynamic>>[
    {'type': 'circle', 'radius': 5},
    {'type': 'rectangle', 'width': 4, 'height': 6},
    {'type': 'triangle', 'side': 3},
    {'type': 'circle'},
  ];

  for (final json in jsons) {
    try {
      final shape = Shape.fromJson(json);
      final name = shape is Circle ? 'Круг' : 'Прямоугольник';
      print('$name: площадь = ${shape.area().toStringAsFixed(2)}');
    } on FormatException catch (e) {
      print('Ошибка: ${e.message}');
    }
  }
}
