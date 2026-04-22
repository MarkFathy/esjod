import '../../../core/models/category_model.dart';
import '../../../core/utils/entrance_fader.dart';
import 'package:flutter/material.dart';

class QuoteCard extends StatelessWidget {
  final QuoteModel quote;

  const QuoteCard({Key? key, required this.quote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          minVerticalPadding: 5,
          title: EntranceFader(
            duration: const Duration(milliseconds: 300),
            delay: const Duration(milliseconds: 100),
            offset: const Offset(50.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/top-deco.png',
                    fit: BoxFit.cover,
                    width: size.width * .7,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16),
                    child: Text(
                      quote.text!,
                      // textScaleFactor: 1.2,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              fontFamily: "HafsSmart",
                              height: 1.7,
                              fontWeight: FontWeight.w900),
                    ),
                  ),
                  Image.asset(
                    'assets/images/bottom-deco.png',
                    fit: BoxFit.cover,
                    width: size.width * .7,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
