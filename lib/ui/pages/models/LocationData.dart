
class LocationData {
  double latitude;
  double longitude;
  double elevation;
  double speed;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.elevation,
    required this.speed,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'elevation': elevation,
      'speed': speed,
    };
  }
}