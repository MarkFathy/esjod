import '../../domain/entities/surah.dart';

class Surah extends SurahEntity {
  const Surah({
    int? code,
    String? status,
    required Data? mainData,
    Data? audioData,
    Data? translationData,
  }) : super(
            code: code,
            status: status,
            mainData: mainData,
            audioData: audioData,
            translationData: translationData);

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      code: json['code'],
      status: json['status'],
      mainData: json['data'] != null ? Data.fromJson(json['data'][0]) : null,
      audioData: json['data'] != null ? Data.fromJson(json['data'][1]) : null,
      translationData:
          json['data'] != null ? Data.fromJson(json['data'][2]) : null,
    );
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['code'] = this.code;
  //   data['status'] = this.status;
  //   if (this.data != null) {
  //     data['data'] = this.data!.toJson();
  //   }
  //   return data;
  // }
}

class Data extends DataEntity {
  const Data(
      {int? number,
      String? name,
      String? englishName,
      String? englishNameTranslation,
      String? revelationType,
      int? numberOfAyahs,
      List<Ayahs>? ayahs,
      Edition? edition})
      : super(
          number: number,
          name: name,
          englishName: englishName,
          englishNameTranslation: englishNameTranslation,
          revelationType: revelationType,
          numberOfAyahs: numberOfAyahs,
          ayahs: ayahs,
          edition: edition,
        );

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
  @override
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        number: json['number'],
        name: json['name'],
        englishName: json['englishName'],
        englishNameTranslation: json['englishNameTranslation'],
        revelationType: json['revelationType'],
        numberOfAyahs: json['numberOfAyahs'],
        ayahs: json['ayahs'] != null
            ? (json['ayahs'] as List).map((e) => Ayahs.fromJson(e)).toList()
            : null,
        edition:
            json['edition'] != null ? Edition.fromJson(json['edition']) : null);
  }
  // @override
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>(),
  //   data['number'] = this.number;
  //   data['name'] = this.name;
  //   data['englishName'] = this.englishName;
  //   data['englishNameTranslation'] = this.englishNameTranslation;
  //   data['revelationType'] = this.revelationType;
  //   data['numberOfAyahs'] = this.numberOfAyahs;
  //   if (this.ayahs != null) {
  //     data['ayahs'] = this.ayahs!.map((v) => v.toJson()).toList();
  //   }
  //   if (this.edition != null) {
  //     data['edition'] = this.edition!.toJson();
  //   }
  //   return data;
  // }
}

class Ayahs extends AyahsEntity {
  const Ayahs({
    int? number,
    String? text,
    int? numberInSurah,
    String? audio,
    List? audioSecondary,
    int? juz,
    int? manzil,
    int? page,
    int? ruku,
    int? hizbQuarter,
    bool? sajda,
  }) : super(
          number: number,
          text: text,
          numberInSurah: numberInSurah,
          audio: audio,
          audioSecondary: audioSecondary,
          juz: juz,
          manzil: manzil,
          page: page,
          ruku: ruku,
          hizbQuarter: hizbQuarter,
          sajda: sajda,
        );

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

  factory Ayahs.fromJson(Map<String, dynamic> json) {
    return Ayahs(
        number: json['number'],
        text: json['text'],
        numberInSurah: json['numberInSurah'],
        audio: json['audio'],
        audioSecondary: json['audioSecondary'],
        juz: json['juz'],
        manzil: json['manzil'],
        page: json['page'],
        ruku: json['ruku'],
        hizbQuarter: json['hizbQuarter']);
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['number'] = this.number;
  //   data['text'] = this.text;
  //   data['numberInSurah'] = this.numberInSurah;
  //   data['juz'] = this.juz;
  //   data['manzil'] = this.manzil;
  //   data['page'] = this.page;
  //   data['ruku'] = this.ruku;
  //   data['hizbQuarter'] = this.hizbQuarter;
  //   data['sajda'] = this.sajda;
  //   return data;
  // }
}

class Edition extends EditionEntity {
  const Edition(
      {String? identifier,
      String? language,
      String? name,
      String? englishName,
      String? format,
      String? type,
      String? direction})
      : super(
          identifier: identifier,
          language: language,
          name: name,
          englishName: englishName,
          format: format,
          type: type,
          direction: direction,
        );

  factory Edition.fromJson(Map<String, dynamic> json) {
    return Edition(
        identifier: json['identifier'],
        language: json['language'],
        name: json['name'],
        englishName: json['englishName'],
        format: json['format'],
        type: json['type'],
        direction: json['direction']);
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['identifier'] = this.identifier;
  //   data['language'] = this.language;
  //   data['name'] = this.name;
  //   data['englishName'] = this.englishName;
  //   data['format'] = this.format;
  //   data['type'] = this.type;
  //   data['direction'] = this.direction;
  //   return data;
  // }
}
