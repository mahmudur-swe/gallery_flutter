import 'package:equatable/equatable.dart';

class Photo extends Equatable {
  final String id;
  final String uri;
  final String name;

  const Photo({required this.id, required this.uri, required this.name});

  @override
  List<Object?> get props => [id, uri, name];
}
