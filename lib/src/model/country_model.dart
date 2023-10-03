class CountryModel {
  final String id;
  final String sortName;
  final String name;
  final String phoneCode;

  CountryModel(
      {required this.id,
      required this.sortName,
      required this.name,
      required this.phoneCode});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
        id: json['id'] as String,
        sortName: json['sortname'] as String,
        name: json['name'] as String,
        phoneCode: json['phonecode'] as String);
  }
}
