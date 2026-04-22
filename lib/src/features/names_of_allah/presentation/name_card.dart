import 'dart:math';
import '../../../core/models/name_model.dart';
import 'package:flutter/material.dart';

class NameCard extends StatefulWidget {
  final NameModel name;
  final int index;

  const NameCard({Key? key, required this.name, required this.index})
      : super(key: key);

  @override
  State<NameCard> createState() => _NameCardState();
}

class _NameCardState extends State<NameCard> {
  late final CardWidget frontWidget;
  late final CardWidget backWidget;

  bool _isShowingFront = true;

  Widget switcherWidget() {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: _isShowingFront ? 0.0 : pi),
      duration: const Duration(seconds: 1),
      curve: Curves.linearToEaseOut,
      builder: (context, double value, child) {
        final isShowingBack = value > pi / 2.0;
        final toDisplay = isShowingBack ? backWidget : frontWidget;
        return Transform(
          transform: Matrix4.identity()
            ..scale(0.9, 0.9)
            ..rotateY(value),
          alignment: Alignment.center,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isShowingBack ? pi : 0.0),
            child: toDisplay,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    frontWidget = CardWidget(
      front: true,
      index: widget.index,
      key: ValueKey(widget.name.name),
      name: widget.name.name!,
      onTapped: () {
        setState(() => _isShowingFront = false);
      },
    );

    backWidget = CardWidget(
      front: false,
      index: widget.index,
      key: ValueKey(widget.name.text),
      name: widget.name.text!,
      onTapped: () {
        setState(() => _isShowingFront = true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return switcherWidget();
  }
}

class CardWidget extends StatelessWidget {
  final String name;
  final int index;
  final bool front;
  final VoidCallback onTapped;

  const CardWidget(
      {Key? key,
      required this.name,
      required this.onTapped,
      required this.front,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return GestureDetector(
        onTap: onTapped,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: theme.cardColor,
              border: Border.all(color: theme.colorScheme.secondary),
              borderRadius: front
                  ? const BorderRadius.only(
                      topLeft: Radius.elliptical(100, 50),
                      bottomRight: Radius.elliptical(100, 50))
                  : const BorderRadius.only(
                      topRight: Radius.elliptical(100, 50),
                      bottomLeft: Radius.elliptical(100, 50))),
          width: size.width * 0.7,
          child: front
              ? Center(
                  child: Text(
                    name,
                    textScaler: const TextScaler.linear(1.6),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.w900,
                        color: theme.primaryColor,
                        // shadows: const [BoxShadow(offset: Offset(1.7, 2.9))],
                        fontFamily: "ArslanWessam"),
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      name,
                      style: theme.textTheme.titleMedium!
                          .copyWith(fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                ),
        ));
  }
}
