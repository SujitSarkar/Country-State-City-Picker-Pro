class CityModel {
  final String id;
  final String name;
  final String stateId;

  CityModel({required this.id, required this.name, required this.stateId});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      stateId: json['state_id'] as String,
    );
  }
}
