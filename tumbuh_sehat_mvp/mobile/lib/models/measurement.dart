class Measurement {
  final int? id;
  final int age;
  final double weight;
  final double height;
  final String gender;
  final double lat;
  final double lng;
  final double zScore;
  final int isSynced;

  Measurement({
    this.id,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.lat,
    required this.lng,
    required this.zScore,
    this.isSynced = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'lat': lat,
      'lng': lng,
      'z_score': zScore,
      'is_synced': isSynced,
    };
  }

  factory Measurement.fromMap(Map<String, dynamic> map) {
    return Measurement(
      id: map['id'],
      age: map['age'],
      weight: map['weight'],
      height: map['height'],
      gender: map['gender'],
      lat: map['lat'],
      lng: map['lng'],
      zScore: map['z_score'],
      isSynced: map['is_synced'],
    );
  }
}