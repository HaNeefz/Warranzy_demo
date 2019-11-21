class ModelLanguage {
  dynamic id;
  String name;
  String prefix;

  ModelLanguage({this.id, this.name, this.prefix});

  ModelLanguage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    prefix = json['prefix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['prefix'] = this.prefix;
    return data;
  }
}
