class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});

  factory Location.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Location(latitude: parsedJson['lat'], longitude: parsedJson['lng']);
  }
}
