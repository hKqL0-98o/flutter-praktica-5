import 'dart:io';

class Matrix {
  final List<List<double>> data;

  Matrix(this.data) {
    if (data.isEmpty || data[0].isEmpty) {
      throw FormatException('Матрица не может быть пустой');
    }
    for (final row in data) {
      if (row.length != data[0].length) {
        throw FormatException('Строки матрицы разной длины');
      }
    }
  }

  int get rows => data.length;
  int get cols => data[0].length;

  Matrix operator +(Matrix o) {
    _checkSame(o);
    return Matrix(List.generate(rows,
        (i) => List.generate(cols, (j) => data[i][j] + o.data[i][j])));
  }

  Matrix operator -(Matrix o) {
    _checkSame(o);
    return Matrix(List.generate(rows,
        (i) => List.generate(cols, (j) => data[i][j] - o.data[i][j])));
  }

  Matrix operator *(Matrix o) {
    if (cols != o.rows) {
      throw ArgumentError(
          'Нельзя умножить: столбцов в A ($cols) != строк в B (${o.rows})');
    }
    return Matrix(List.generate(rows, (i) => List.generate(o.cols, (j) {
          double sum = 0;
          for (int k = 0; k < cols; k++) {
            sum += data[i][k] * o.data[k][j];
          }
          return sum;
        })));
  }

  Matrix scale(double k) => Matrix(
      List.generate(rows, (i) => List.generate(cols, (j) => data[i][j] * k)));

  Matrix transpose() => Matrix(
      List.generate(cols, (i) => List.generate(rows, (j) => data[j][i])));

  double determinant() {
    if (rows != cols) {
      throw ArgumentError('Определитель есть только у квадратной матрицы');
    }
    return _det(data);
  }

  static double _det(List<List<double>> m) {
    int n = m.length;
    if (n == 1) return m[0][0];
    if (n == 2) return m[0][0] * m[1][1] - m[0][1] * m[1][0];
    double d = 0;
    for (int c = 0; c < n; c++) {
      var minor = [
        for (int i = 1; i < n; i++)
          [for (int j = 0; j < n; j++) if (j != c) m[i][j]]
      ];
      d += (c.isEven ? 1 : -1) * m[0][c] * _det(minor);
    }
    return d;
  }

  void _checkSame(Matrix o) {
    if (rows != o.rows || cols != o.cols) {
      throw ArgumentError(
          'Размеры не совпадают: ${rows}x$cols и ${o.rows}x${o.cols}');
    }
  }

  @override
  String toString() => data.map((r) => r.join('\t')).join('\n');
}

String ask(String prompt) {
  stdout.write(prompt);
  return stdin.readLineSync()?.trim() ?? '';
}

Matrix readMatrix(String name) {
  print('Матрица $name');
  int? r = int.tryParse(ask('  Строк: '));
  int? c = int.tryParse(ask('  Столбцов: '));
  if (r == null || c == null) throw FormatException('Размеры должны быть целыми числами');
  if (r <= 0 || c <= 0) throw FormatException('Размеры должны быть > 0');
  List<List<double>> rowsData = [];
  for (int i = 0; i < r; i++) {
    var parts = ask('  Строка ${i + 1} (через пробел): ')
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.length != c) {
      throw FormatException('Нужно ровно $c чисел, введено ${parts.length}');
    }
    rowsData.add(parts.map((s) {
      var v = double.tryParse(s.replaceAll(',', '.'));
      if (v == null) throw FormatException('"$s" - не число');
      return v;
    }).toList());
  }
  return Matrix(rowsData);
}

void main() {
  while (true) {
    print('\n1) A+B  2) A-B  3) A*число  4) A*B  5) Транспонировать A  6) Определитель A  0) Выход');
    stdout.write('Выбор: ');
    String? choice = stdin.readLineSync()?.trim();
    if (choice == null || choice == '0') break;

    try {
      switch (choice) {
        case '1':
          print(readMatrix('A') + readMatrix('B'));
          break;
        case '2':
          print(readMatrix('A') - readMatrix('B'));
          break;
        case '3':
          var a = readMatrix('A');
          double? k = double.tryParse(ask('Число: ').replaceAll(',', '.'));
          if (k == null) throw FormatException('Это не число');
          print(a.scale(k));
          break;
        case '4':
          print(readMatrix('A') * readMatrix('B'));
          break;
        case '5':
          print(readMatrix('A').transpose());
          break;
        case '6':
          print('Определитель = ${readMatrix('A').determinant()}');
          break;
        default:
          print('Нет такого пункта');
      }
    } on FormatException catch (e) {
      print('Ошибка ввода: ${e.message}');
    } on ArgumentError catch (e) {
      print('Ошибка: ${e.message}');
    }
  }
}


