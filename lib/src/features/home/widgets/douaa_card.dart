import 'dart:convert';

import 'package:azkar/src/core/models/category_model.dart';
import 'package:azkar/src/core/utils/entrance_fader.dart';
import 'package:azkar/src/core/widgets/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DouaaCard extends StatelessWidget {
  const DouaaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    Future<QuoteModel?> getQuote() async {
      final List<CategoryModel> list =
          await rootBundle.loadString("assets/json/azkar.json").then((data) {
        List<dynamic>? response = json.decode(data);
        final List<CategoryModel> res =
            response!.map((e) => CategoryModel.fromJson(e)).toList();
        return res;
      }).catchError((error) {
        debugPrint(error.toString());
        throw error;
      });
      if (list.isEmpty) return null;
      list.shuffle();
      final cat = list.first;
      cat.array!.shuffle();
      final quote = cat.array!.first;
      return quote;
    }

    return EntranceFader(
      offset: const Offset(90, 0),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Material(
          borderRadius: BorderRadius.circular(8),
          color: theme.cardColor,
          elevation: 3,
          child: SizedBox(
            height: size.height * .15,
            child: Center(
              child: SingleChildScrollView(
                child: FutureBuilder(
                    future: getQuote(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            snapshot.data!.text!
                                .replaceAll(RegExp(r'\s+'), ' '),
                            style: theme.textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.w900,
                                color: theme.primaryColor,
                                wordSpacing: .2,
                                fontFamily: '',
                                letterSpacing: .3),

                            textAlign: TextAlign.center,

                            // overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }
                      return const AppIndicator();
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
