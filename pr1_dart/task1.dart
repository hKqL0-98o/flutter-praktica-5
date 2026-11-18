String yesNo(bool value) => value ? 'да' : 'нет';

void main() {
  String name = 'Галина';
  int age = 18;
  double gpa = 4.5;
  bool isStudent = true;

  print('Имя: $name ${name.runtimeType}');
  print('Возраст: $age ${age.runtimeType}');
  print('Средний балл: $gpa ${gpa.runtimeType}');
  print('Студент: ${yesNo(isStudent)} ${isStudent.runtimeType}');
}
