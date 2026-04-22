import 'dart:convert';

import '../../domain/entities/surahs.dart';

class Surahs extends SurahsEntity {
  const Surahs({int? count, List<References>? references})
      : super(count: count, references: references);

  SurahsEntity toEntity() => SurahsEntity(count: count, references: references);
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'count': count,
      'references': references!.map((x) => x.toMap()).toList(),
    };
  }

  factory Surahs.fromMap(Map<String, dynamic> map) {
    return Surahs(
      count: map['count'] != null ? map['count'] as int : null,
      references: map['references'] != null
          ? List<References>.from(
              (map['references'] as List).map<ReferencesEntity?>(
                (x) => References.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Surahs.fromJson(String source) =>
      Surahs.fromMap(json.decode(source) as Map<String, dynamic>);
}

class References extends ReferencesEntity {
  const References(
      {int? number,
      String? name,
      String? englishName,
      String? englishNameTranslation,
      int? numberOfAyahs,
      String? revelationType})
      : super(
          number: number,
          name: name,
          englishName: englishName,
          englishNameTranslation: englishNameTranslation,
          numberOfAyahs: numberOfAyahs,
          revelationType: revelationType,
        );

  factory References.fromMap(Map<String, dynamic> map) {
    return References(
      number: map['number'] != null ? map['number'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      englishName:
          map['englishName'] != null ? map['englishName'] as String : null,
      englishNameTranslation: map['englishNameTranslation'] != null
          ? map['englishNameTranslation'] as String
          : null,
      numberOfAyahs:
          map['numberOfAyahs'] != null ? map['numberOfAyahs'] as int : null,
      revelationType: map['revelationType'] != null
          ? map['revelationType'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory References.fromJson(String source) =>
      References.fromMap(json.decode(source) as Map<String, dynamic>);
  @override
  List<Object?> get props => [
        number,
        name,
        englishName,
        englishNameTranslation,
        numberOfAyahs,
        revelationType,
      ];
}
