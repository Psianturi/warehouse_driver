
class LocationData {
  double lat;
  double long;
  double elevasi;
  double kecepatan;
  int battery;

  LocationData({
    required this.lat,
    required this.long,
    required this.elevasi,
    required this.kecepatan,
    required this.battery,
  });

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'longitude': long,
      'elevasi': elevasi,
      'kecepatan': kecepatan,
      'battery': battery,
    };
  }
}