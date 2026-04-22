import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/pin_model.dart';
import '../models/surah_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import '../models/surahs_model.dart';

abstract class QuranDataSource {
  Future<Surahs> fetchSurahs();
  Future<PinModel?> setPin(PinModel pin);
  Future<PinModel?> getPin();
  Future<Surah> fetchSurah(
      {required int number,
      required String audioEdition,
      required String translationEdition});
  Future<List<Edition>> fetchEditions();
}

class QuranDataSourceImpl implements QuranDataSource {
  final http.Client client;

  QuranDataSourceImpl({required this.client});
  @override
  Future<Surahs> fetchSurahs() async {
    final metas =
        await rootBundle.loadString("assets/json/metas.json", cache: true);

    if (metas.isNotEmpty) {
      final Map<String, dynamic> decodedResponse = json.decode(metas);
      return Surahs.fromMap(decodedResponse);
    } else {
      throw OfflineException();
    }
  }

  @override
  Future<Surah> fetchSurah(
      {required int number,
      required String audioEdition,
      required String translationEdition}) async {
    final String editions =
        "editions/ar.asad,$audioEdition,$translationEdition";
    try {
      final response = await client.get(
        Uri.parse("http://api.alquran.cloud/v1/surah/$number/$editions"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedResponse = json.decode(response.body);
        if (decodedResponse.isEmpty) {
          throw ServerException(message: 'تحقق من الإنترنت');
        }
        return Surah.fromJson(decodedResponse);
      } else {
        throw ServerException(message: 'تحقق من الإنترنت');
      }
    } on Exception catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<Edition>> fetchEditions() async {
    final response = await client.get(
      Uri.parse("http://api.alquran.cloud/v1/edition"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List decodedResponse = json.decode(response.body)['data'];
      if (decodedResponse.isEmpty) {
        throw ServerException(message: 'لا يوجد تصنيفات');
      }
      return decodedResponse
          .map((edition) => Edition.fromJson(edition))
          .toList();
    } else {
      throw ServerException(message: 'لا يوجد تصنيفات');
    }
  }

  @override
  Future<PinModel?> setPin(PinModel pin) async {
    final sh = await SharedPreferences.getInstance();
    sh.setString("pin", jsonEncode(pin.toJson()));
    return pin;
  }

  @override
  Future<PinModel?> getPin() async {
    final sh = await SharedPreferences.getInstance();
    final pinString = sh.getString('pin');
    if (pinString == null) return null;
    final jsonPin = jsonDecode(pinString);
    return PinModel.fromJson(jsonPin);
  }
}
