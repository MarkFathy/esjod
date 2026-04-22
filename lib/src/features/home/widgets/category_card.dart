import 'package:azkar/src/core/utils/core_theme.dart';

import '../../../core/models/category_model.dart';
import '../../../core/utils/entrance_fader.dart';
import '../../../core/utils/nav.dart';
import '../../quotes/quotes_screen.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;

  const CategoryCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
        onTap: () {
          NV.nextScreen(context, QuotesScreen(category: category));
        },
        child: EntranceFader(
            duration: const Duration(milliseconds: 300),
            delay: const Duration(milliseconds: 100),
            offset: const Offset(50.0, 0.0),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      category.category!,
                      style: theme.textTheme.titleLarge!
                          .copyWith(color: whiteColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: whiteColor,
                  )
                ],
              ),
            )));
  }
}
