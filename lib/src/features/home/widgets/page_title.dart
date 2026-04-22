import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            border: Border(
          right: BorderSide(color: theme.primaryColor, width: 8),
        )),
        child: Text(
          title,
          style: theme.textTheme.headlineLarge!
              .copyWith(fontWeight: FontWeight.w900, color: theme.primaryColor),
        ),
      ),
    );
  }
}
