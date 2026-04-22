import '../../core/models/category_model.dart';
import 'widgets/quote_card.dart';
import 'package:flutter/material.dart';

class QuotesScreen extends StatelessWidget {
  final CategoryModel category;

  const QuotesScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${category.category}'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: category.array!
            .map((element) => QuoteCard(
                  quote: element,
                ))
            .toList(),
      ),
    );
  }
}
