part of "category_model.dart";

class QuoteModel {
  int? id;
  int? count;
  String? text;
  String? audio;
  String? filename;

  QuoteModel(this.id, this.count, this.text, this.audio, this.filename);

  QuoteModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    count = json["count"] ?? 0;
    text = json["text"] ?? "";
    audio = json["audio"] ?? "";
    filename = json["filename"] ?? "";
  }
}