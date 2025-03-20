class LocationDto {
  final String? country;
  final String? displayName;
  final double? latitude;
  final double? longitude;
  final DateTime? lastUpdated;

  LocationDto({
    required this.country,
    required this.displayName,
    required this.latitude,
    required this.longitude,
    this.lastUpdated,
  });

  String? get fullDisplayName => country == null
      ? null
      : "${displayName != null ? "$displayName, $country" : '$country'}";

  factory LocationDto.fromJson(Map<dynamic, dynamic> json) {
    return LocationDto(
      country: json['country'],
      displayName: json['displayName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastUpdated'])
          : null,
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
