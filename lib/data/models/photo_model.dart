import 'package:equatable/equatable.dart';

import '../../domain/entities/photo.dart';


class PhotoModel extends Equatable {
  final String id;
  final String uri;
  final String name;

  const PhotoModel({required this.id, required this.uri, required this.name});

  @override
  List<Object?> get props => [id, uri, name];

  factory PhotoModel.fromMap(Map<String, dynamic> map) {
    return PhotoModel(
      id: map['id']?.toString() ?? '',
      uri: map['uri'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Photo toDomain() {
    return Photo(id: id, uri: uri, name: name);
  }
}


