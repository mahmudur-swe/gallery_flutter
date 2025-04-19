
import 'package:equatable/equatable.dart';
import 'package:gallery_flutter/domain/entities/photo.dart';

class PhotoState extends Equatable {
  final List<Photo> photos;
  //final Set<String> selectedPhotoIds;
  final bool isLoading;
  final String? errorMessage;

  const PhotoState({
    this.photos = const [],
    this.isLoading = false,
    this.errorMessage,
   // this.selectedPhotoIds = const {},
  });

  PhotoState copyWith({
    List<Photo>? photos,
    bool? isLoading,
    String? errorMessage,
  //  Set<String>? selectedPhotoIds,
  }) {
    return PhotoState(
      photos: photos ?? this.photos,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
  //    selectedPhotoIds: selectedPhotoIds ?? this.selectedPhotoIds,
    );
  }


  //bool isSelected(String id) => selectedPhotoIds.contains(id);

  @override
  List<Object?> get props => [isLoading, errorMessage, photos, /*selectedPhotoIds*/];
}
