import 'package:equatable/equatable.dart';

import '../../domain/entities/photo.dart';

class PhotoResponse extends Equatable {
  final List<PhotoModel> photos;

  const PhotoResponse({required this.photos});

  @override
  List<Object?> get props => [photos];

  Map<String, dynamic> toJson() => {
    "photos": photos.map((photo) => photo.toJson()).toList(),
  };

  factory PhotoResponse.fromJson(List<dynamic> json) => PhotoResponse(
    photos: json.map((photoJson) => PhotoModel.fromJson(photoJson)).toList(),
  );
}

class PhotoModel extends Equatable {
  final String id;
  final String uri;
  final String name;

  const PhotoModel({required this.id, required this.uri, required this.name});

  @override
  List<Object?> get props => [id, uri, name];

  Map<String, dynamic> toJson() => {"id": id, "uri": uri, "name": name};

  factory PhotoModel.fromJson(dynamic path) =>
      PhotoModel(id: path['id'], uri: path['uri'], name: path['name']);

  factory PhotoModel.fromMap(Map<String, dynamic> map) {
    return PhotoModel(
      id: map['id']?.toString() ?? '',
      uri: map['uri'] ?? '',
      name: map['name'] ?? '',
    );
  }
}

extension PhotoModelMapper on PhotoModel {
  Photo toDomain() {
    return Photo(id: id, uri: uri, name: name);
  }
}
