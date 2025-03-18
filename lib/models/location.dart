import 'dart:math';

class Location {
  final String? country;
  final String? displayName;
  final double? latitude;
  final double? longitude;
  final DateTime? lastUpdated;

  Location({
    required this.country,
    required this.displayName,
    required this.latitude,
    required this.longitude,
    this.lastUpdated,
  });

  String? get fullDisplayName =>
      country == null ? null : "${displayName != null ? "$displayName, $country" : '$country'}";

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      country: json['country'],
      displayName: json['displayName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      lastUpdated: json['lastUpdated'] != null ? DateTime.fromMillisecondsSinceEpoch(json['lastUpdated']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'displayName': displayName,
      'latitude': latitude,
      'longitude': longitude,
      'lastUpdated': lastUpdated?.millisecondsSinceEpoch,
    };
  }

  num distanceTo(Location other) {
    const double earthRadius = 6371; // Radius of the Earth in kilometers
    final double dLat = (other.latitude! - latitude!) * (3.141592653589793 / 180);
    final double dLon = (other.longitude! - longitude!) * (3.141592653589793 / 180);
    final double a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(latitude! * (3.141592653589793 / 180)) *
            cos(other.latitude! * (3.141592653589793 / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2));
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Distance in kilometers
  }

  @override
  String toString() {
    return 'Location{country: $country, displayName: $displayName, latitude: $latitude, longitude: $longitude}';
  }
}

class GoogleLocation {
  final String description;
  final String placeId;

  GoogleLocation({required this.description, required this.placeId});

  factory GoogleLocation.fromJson(Map<String, dynamic> json) {
    return GoogleLocation(
      description: json['description'],
      placeId: json['place_id'],
    );
  }
}
