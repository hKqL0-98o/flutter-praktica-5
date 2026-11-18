import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Карточка товара',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProductPage(),
    );
  }
}

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Практическая работа №7')),
      body: const Center(child: ProductCard()),
    );
  }
}

/// Карточка товара: Container с рамкой -> Column ->
/// заголовок, картинка, описание (Text в Container с отступами),
/// Row с ценой и рейтингом.
class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(border: Border.all()),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок товара
          Container(
            padding: const EdgeInsets.all(12),
            child: const Text(
              'Ноутбук для работы и учёбы',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          // Картинка товара
          Image.network(
            'https://picsum.photos/id/1/320/200',
            width: 320,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 320,
              height: 200,
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: const Text('Нет изображения'),
            ),
          ),

          // Описание (Text в Container с отступами)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            child: const Text(
              'Лёгкий ноутбук с 14-дюймовым экраном, процессором на 8 ядер '
              'и батареей, которой хватает на целый учебный день.',
              style: TextStyle(fontSize: 16),
            ),
          ),

          // Цена и рейтинг (два Text в Row)
          Container(
            padding: const EdgeInsets.all(12),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '59 990 ₽',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('★ 4.8', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
