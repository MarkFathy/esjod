import 'package:carousel_slider/carousel_slider.dart';
import '../bloc/bloc.dart';
import '../../../core/utils/entrance_fader.dart';
import '../../../core/widgets/app_loader.dart';
import 'name_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NamesSection extends StatefulWidget {
  const NamesSection({
    Key? key,
  }) : super(key: key);

  @override
  State<NamesSection> createState() => _NamesSectionState();
}

class _NamesSectionState extends State<NamesSection> {
  @override
  Widget build(BuildContext context) {
    final dSize = MediaQuery.of(context).size;
    return BlocProvider<NamesBloc>(
      create: (context) => NamesBloc()..add(const LoadNames()),
      child: BlocBuilder<NamesBloc, NamesState>(
        builder: (context, state) {
          if (state is NamesLoading) {
            return const Center(child: AppIndicator());
          } else if (state is NamesLoadSuccess) {
            return Container(
                // color: whiteColor,
                height: dSize.height * 0.2,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                child: CarouselSlider.builder(
                    itemCount: state.names.length,
                    itemBuilder: (context, index, realIndex) => EntranceFader(
                        delay: const Duration(milliseconds: 100),
                        duration: const Duration(milliseconds: 350),
                        offset: const Offset(0.0, 50.0),
                        child: NameCard(
                          name: state.names[index],
                          index: index,
                        )),
                    options: CarouselOptions(
                      height: dSize.height * .25,
                      aspectRatio: 16 / 9,
                      viewportFraction: .7,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      reverse: false,
                      autoPlay: true,
                      // autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollPhysics:
                          const ScrollPhysics(parent: BouncingScrollPhysics()),
                      enlargeFactor: 0.3,
                      onPageChanged: (index, reason) {},
                      scrollDirection: Axis.horizontal,
                    )));
          } else if (state is NamesLoadFailed) {
            return Center(child: Text(state.exception.toString()));
          } else {
            return const Center();
          }
        },
      ),
    );
  }
}
