class StateModel {
  String id;
  String name;
  String countryId;

  StateModel({required this.id, required this.name, required this.countryId});

  factory StateModel.fromJson(Map<String, dynamic> json){
    return StateModel(
        id: json['id'] as String,
        name: json['name'] as String,
        countryId: json['country_id'] as String
    );
  }
}
