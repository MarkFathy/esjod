import 'dart:async';
import 'dart:convert';
import '../models/category_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'event.dart';

part 'state.dart';

class QuotesBloc extends Bloc<QuotesEvent, QuotesState> {
  List<CategoryModel> categories = [];

  QuotesBloc() : super(QuotesInitial()) {
    on<LoadQuotes>(_loadCategories);
  }

  FutureOr<void> _loadCategories(
      LoadQuotes event, Emitter<QuotesState> emit) async {
    if (categories.isNotEmpty) {
      emit(QuotesLoadSuccess(categories));
      return;
    }
    emit(QuotesLoading());
    categories =
        await rootBundle.loadString("assets/json/azkar.json").then((data) {
      List<dynamic>? response = json.decode(data);
      // debugPrint(response.toString());
      if (response == null) {
        emit(QuotesLoadFailed(Exception("Couldn't load categories")));
      }
      final List<CategoryModel> res =
          response!.map((e) => CategoryModel.fromJson(e)).toList();
      return res;
    }).catchError((error) {
      debugPrint(error.toString());
      throw error;
    });
    emit(QuotesLoadSuccess(categories));
  }
}
