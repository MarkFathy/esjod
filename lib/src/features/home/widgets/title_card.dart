import '../../../core/utils/entrance_fader.dart';
import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget {
  final Widget title;
  const TitleCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final dSize = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.only(
          left: 10,
        ),
        child: Container(
          padding: EdgeInsets.all(dSize.width * 0.07),
          width: dSize.width * 0.55,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/title-card.png'),
            fit: BoxFit.fitWidth,
          )),
          alignment: Alignment.centerLeft,
          child: EntranceFader(
              delay: const Duration(milliseconds: 100),
              duration: const Duration(milliseconds: 350),
              offset: const Offset(0.0, 32.0),
              child: title),
        ));
  }
}
