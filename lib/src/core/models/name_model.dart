class NameModel {
  String? text;
  String? name;

  NameModel(this.name, this.text);

  NameModel.fromJson(Map<String, dynamic> json) {
    text = json["text"] ?? "";
    name = json["name"] ?? "";
  }
}
