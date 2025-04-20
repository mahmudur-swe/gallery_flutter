import 'package:equatable/equatable.dart';

class Photo extends Equatable {
  final String id;
  final String uri;
  final String name;

  const Photo({required this.id, required this.uri, required this.name});

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id']?.toString() ?? '',
      uri: map['uri'] ?? '',
      name: map['name'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, uri, name];
}
