class ConfigFileModel {
  ConfigFileModel({required this.theme});

  factory ConfigFileModel.fromJson(Map<String, dynamic> json) {
    return ConfigFileModel(
        theme: json["theme"] as String
    );
  }

  factory ConfigFileModel.basicConfig() {
    return ConfigFileModel(
      theme: ""
    );
  }

  Map<String, dynamic> toJson() => {
    'theme': theme
  };

  String theme;

}