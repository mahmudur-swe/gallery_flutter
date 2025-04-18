
import 'package:equatable/equatable.dart';
import 'package:gallery_flutter/domain/entities/photo.dart';

class PhotoState extends Equatable {
  final List<Photo> photos;
  final bool isLoading;
  final String? errorMessage;

  PhotoState({
    this.photos = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  PhotoState copyWith({
    List<Photo>? photos,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PhotoState(
      photos: photos ?? this.photos,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, photos];
}
