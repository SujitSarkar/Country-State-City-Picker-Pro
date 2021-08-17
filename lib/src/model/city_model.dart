class CityModel {
  String id;
  String name;
  String stateId;

  CityModel({required this.id, required this.name, required this.stateId});

  factory CityModel.fromJson(Map<String, dynamic> json){
    return CityModel(
        id: json['id'] as String,
        name: json['name'] as String,
        stateId: json['state_id'] as String,
    );
  }
}
