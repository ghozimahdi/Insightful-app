enum GeoFenceType {
  home,
  office,
  traveling,
  unknown;

  static GeoFenceType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'home':
        return GeoFenceType.home;
      case 'office':
        return GeoFenceType.office;
      case 'traveling':
        return GeoFenceType.traveling;
      default:
        return GeoFenceType.unknown;
    }
  }
}

extension GeoFenceTypeExtension on GeoFenceType {
  String get label {
    switch (this) {
      case GeoFenceType.home:
        return 'Home';
      case GeoFenceType.office:
        return 'Office';
      case GeoFenceType.traveling:
        return 'Traveling';
      case GeoFenceType.unknown:
        return '-';
    }
  }
}
