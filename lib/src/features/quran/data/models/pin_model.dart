import '../../domain/entities/pin.dart';

class PinModel extends PinEntity {
  const PinModel({
    String? title,
    int? surah,
    int? ayah,
  }) : super(title: title, surah: surah, ayah: ayah);

  factory PinModel.fromJson(Map<String, dynamic> json) {
    return PinModel(
        title: json['title'], surah: json['surah'], ayah: json['ayah']);
  }

  Map<String, dynamic> toJson() {
    return {"title": title, "surah": surah, "ayah": ayah};
  }
}
