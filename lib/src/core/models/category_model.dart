part 'quote_model.dart';

class CategoryModel {
  int? id;
  String? category;
  String? audio;
  String? filename;
  List<QuoteModel>? array;

  CategoryModel(
      {this.id, this.category, this.audio, this.filename, this.array});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    category = json["category"] ?? "";
    audio = json["audio"] ?? "";
    filename = json["filename"] ?? "";
    final List<dynamic> arrayData = json["array"] ?? [];
    array = arrayData.map((element) => QuoteModel.fromJson(element)).toList();
  }
}