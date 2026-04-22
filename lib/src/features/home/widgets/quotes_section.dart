import 'package:azkar/src/features/home/widgets/page_title.dart';
import '../../../core/quotes_bloc/bloc.dart';
import '../../../core/utils/entrance_fader.dart';
import '../../../core/widgets/app_loader.dart';
import 'category_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuotesSection extends StatefulWidget {
  const QuotesSection({
    Key? key,
  }) : super(key: key);

  @override
  State<QuotesSection> createState() => _QuotesSectionState();
}

class _QuotesSectionState extends State<QuotesSection> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider<QuotesBloc>(
      create: (context) => QuotesBloc()..add(const LoadQuotes()),
      child: BlocBuilder<QuotesBloc, QuotesState>(
        builder: (context, state) {
          if (state is QuotesLoading) {
            return const Center(child: AppIndicator());
          } else if (state is QuotesLoadSuccess) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // (size.height * (Platform.isAndroid ? .04 : .06)).ph,
                  const PageTitle(title: 'أذكــار الـمـسـلـم'),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        // textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: theme.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                        onChanged: (value) => setState(() {
                          query = value;
                        }),
                        decoration: InputDecoration(
                            hintText: "بحث",
                            border: InputBorder.none,
                            suffixIcon: Icon(
                              Icons.search,
                              color: theme.primaryColor,
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: state.quotes
                          .where((element) => element.category!.contains(query))
                          .map((e) => EntranceFader(
                              delay: const Duration(milliseconds: 250),
                              duration: const Duration(milliseconds: 350),
                              offset: const Offset(0.0, 50.0),
                              child: CategoryCard(category: e)))
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is QuotesLoadFailed) {
            return Center(child: Text(state.exception.toString()));
          } else {
            return const Center();
          }
        },
      ),
    );
  }
}
