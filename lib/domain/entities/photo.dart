class Photo {
  final String id;
  final String uri;
  final String name;
  final int size;
  final int timestamp;

  Photo({
    required this.id,
    required this.uri,
    required this.name,
    required this.size,
    required this.timestamp,
  });

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id']?.toString() ?? '',
      uri: map['uri'] ?? '',
      name: map['name'] ?? '',
      size: map['size'] ?? 0,
      timestamp: map['timestamp'] ?? 0
    );
  }
}
