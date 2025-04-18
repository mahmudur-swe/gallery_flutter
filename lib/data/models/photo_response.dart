

import 'package:equatable/equatable.dart';

import '../../domain/entities/photo.dart';

class PhotoResponse extends Equatable {
  final List<PhotoModel> photos;

  const PhotoResponse({
    required this.photos,
  });

  @override
  List<Object?> get props => [photos];

  // Convert PhotoResponse to a JSON-serializable Map
  Map<String, dynamic> toJson() => {
        "photos": photos.map((photo) => photo.toJson()).toList(),
      };

  // Factory constructor to create PhotoResponse from a JSON Map
  factory PhotoResponse.fromJson(List<dynamic> json) => PhotoResponse(
        photos: json.map((photoJson) => PhotoModel.fromJson(photoJson)).toList(),
      );
}

class PhotoModel extends Equatable {
  final String id;
  final String uri;
  final String name;

  const PhotoModel({
    required this.id,
    required this.uri,
    required this.name
  });


  @override
  List<Object?> get props => [id, uri, name];

  // Convert Photo to a JSON-serializable Map
  Map<String, dynamic> toJson() => {
        "id": id,
        "uri": uri,
        "name": name
      };

  // Factory constructor to create Photo from a JSON Map
  factory PhotoModel.fromJson(dynamic path) => PhotoModel(
        id: path['id'],
        uri: path['uri'],
        name: path['name']
      );
}

extension PhotoModelMapper on PhotoModel {
  Photo toDomain() {
    return Photo(
      id: id,
      uri: uri,
      name: name
    );
  }
}