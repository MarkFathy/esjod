import '../../core/utils/entrance_fader.dart';
import '../../core/utils/nav.dart';
import '../home/home_screen.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  static const routeName = '/intro';

  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  go() async {
    await Future.delayed(const Duration(seconds: 3))
        .then((value) => NV.nextScreenReplace(context, const HomeScreen()));
  }

  @override
  void initState() {
    super.initState();
    go();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: EntranceFader(
                delay: const Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 350),
                offset: const Offset(0.0, -30.0),
                child: Image.asset(
                  'assets/images/frame-t.png',
                  fit: BoxFit.cover,
                ),
              )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: EntranceFader(
              delay: const Duration(milliseconds: 100),
              duration: const Duration(milliseconds: 350),
              offset: const Offset(32.0, 0.0),
              child: Image.asset(
                'assets/images/frame-b.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size.width * 0.15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EntranceFader(
                  delay: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 350),
                  offset: const Offset(0.0, 32.0),
                  child: EntranceFader(
                    duration: const Duration(milliseconds: 200),
                    offset: const Offset(0.0, 0.0),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
