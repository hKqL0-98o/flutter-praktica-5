import 'dart:io';
import 'dart:math';

final Random random = Random();

abstract class Character {
  static const int maxHealth = 100;

  final String name;
  int health = maxHealth;
  int level;

  Character(this.name, {this.level = 1});

  // Возвращает урон
  int attack();

  // Уменьшает здоровье на damage
  void defend(int damage);

  bool isAlive() => health > 0;

  // Здоровье не опускается ниже 0
  void takeDamage(int damage) {
    health -= damage;
    if (health < 0) {
      health = 0;
    }
  }
}

class Warrior extends Character {
  Warrior(super.name, {super.level});

  @override
  int attack() => 15 + level * 2;

  // Защита: урон уменьшается на 20%
  @override
  void defend(int damage) {
    takeDamage((damage * 0.8).round());
  }
}

class Mage extends Character {
  Mage(super.name, {super.level});

  // После атаки маг лечит себя на 5 HP (но не выше максимума)
  @override
  int attack() {
    health = min(health + 5, Character.maxHealth);
    return 10 + level * 3;
  }

  // Защита: получает полный урон
  @override
  void defend(int damage) {
    takeDamage(damage);
  }
}

class Rogue extends Character {
  static const int baseDamage = 12;

  bool lastAttackWasCrit = false;

  Rogue(super.name, {super.level});

  // 20% шанс критического удара (урон x3)
  @override
  int attack() {
    lastAttackWasCrit = random.nextDouble() < 0.2;
    return lastAttackWasCrit ? baseDamage * 3 : baseDamage;
  }

  // Защита: 50% шанс уворота
  @override
  void defend(int damage) {
    if (random.nextBool()) {
      return;
    }
    takeDamage(damage);
  }
}

void hit(Character attacker, Character defender) {
  final healthBefore = defender.health;
  final damage = attacker.attack();
  defender.defend(damage);
  final received = healthBefore - defender.health;

  final crit = attacker is Rogue && attacker.lastAttackWasCrit ? ' КРИТ!' : '';
  final result = received == 0 && damage > 0
      ? 'увернулся'
      : 'получил урона: $received';
  print('${attacker.name} бьёт (урон $damage$crit) -> ${defender.name} $result. '
      'HP: ${attacker.name} ${attacker.health}, ${defender.name} ${defender.health}');
}

// Бой по очереди: сначала атакует first
void battle(Character first, Character second) {
  print('=== Бой: ${first.name} против ${second.name} ===');
  int round = 1;
  while (first.isAlive() && second.isAlive()) {
    print('Раунд $round');
    hit(first, second);
    if (second.isAlive()) {
      hit(second, first);
    }
    round++;
  }
  final winner = first.isAlive() ? first : second;
  print('Победитель: ${winner.name} (HP: ${winner.health})');
}

void main() {
  print('Выберите бой:');
  print('1 - Воин против Мага');
  print('2 - Маг против Разбойника');
  print('3 - Разбойник против Воина');
  stdout.write('Выбор: ');
  final choice = stdin.readLineSync()?.trim();

  final warrior = Warrior('Артур');
  final mage = Mage('Мерлин');
  final rogue = Rogue('Тень');

  switch (choice) {
    case '1':
      battle(warrior, mage);
      break;
    case '2':
      battle(mage, rogue);
      break;
    case '3':
      battle(rogue, warrior);
      break;
    default:
      print('Ошибка: нужно ввести 1, 2 или 3');
  }
}
