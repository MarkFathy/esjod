import '../../data/models/surah_model.dart';
import 'package:equatable/equatable.dart';

class SurahEntity extends Equatable {
  final int? code;
  final String? status;
  final DataEntity? mainData;
  final DataEntity? translationData;
  final DataEntity? audioData;

  const SurahEntity(
      {this.code,
      this.status,
      this.mainData,
      this.translationData,
      this.audioData});

  @override
  List<Object?> get props => [code, audioData, translationData, status];
}

class DataEntity extends Equatable {
  final int? number;
  final String? name;
  final String? englishName;
  final String? englishNameTranslation;
  final String? revelationType;
  final int? numberOfAyahs;
  final List<Ayahs>? ayahs;
  final Edition? edition;

  const DataEntity(
      {this.number,
      this.name,
      this.englishName,
      this.englishNameTranslation,
      this.revelationType,
      this.numberOfAyahs,
      this.ayahs,
      this.edition});

  @override
  List<Object?> get props => [
        number,
        name,
        englishName,
        englishNameTranslation,
        revelationType,
        numberOfAyahs,
        ayahs,
        edition
      ];
}

class AyahsEntity extends Equatable {
  final int? number;
  final String? text;
  final String? audio;
  final List? audioSecondary;
  final int? numberInSurah;
  final int? juz;
  final int? manzil;
  final int? page;
  final int? ruku;
  final int? hizbQuarter;
  final bool? sajda;

  const AyahsEntity(
      {this.number,
      this.text,
      this.numberInSurah,
      this.audio,
      this.audioSecondary,
      this.juz,
      this.manzil,
      this.page,
      this.ruku,
      this.hizbQuarter,
      this.sajda});

  @override
  List<Object?> get props => [
        number,
        text,
        numberInSurah,
        audio,
        audioSecondary,
        juz,
        manzil,
        page,
        ruku,
        hizbQuarter,
        sajda
      ];
}

class EditionEntity extends Equatable {
  final String? identifier;
  final String? language;
  final String? name;
  final String? englishName;
  final String? format;
  final String? type;
  final String? direction;

  const EditionEntity(
      {this.identifier,
      this.language,
      this.name,
      this.englishName,
      this.format,
      this.type,
      this.direction});

  @override
  List<Object?> get props =>
      [identifier, language, name, englishName, format, type, direction];
}
