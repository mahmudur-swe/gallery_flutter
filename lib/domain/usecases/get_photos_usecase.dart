

import 'package:gallery_flutter/domain/entities/photo.dart';

class GetPhotosUseCase {

  GetPhotosUseCase();

  Future<List<Photo>> execute() async {


    return [ Photo(id: '1', uri: 'https://picsum.photos/id/10/200/300', name: 'Photo 1', size: 100, timestamp: 0),
      Photo(id: '2', uri: 'https://picsum.photos/id/11/200/301', name: 'Photo 2', size: 200, timestamp: 0),
      Photo(id: '3', uri: 'https://picsum.photos/id/12/200/302', name: 'Photo 3', size: 300, timestamp: 0),
      Photo(id: '4', uri: 'https://picsum.photos/id/13/200/303', name: 'Photo 4', size: 400, timestamp: 0),
      Photo(id: '5', uri: 'https://picsum.photos/id/14/200/304', name: 'Photo 5', size: 500, timestamp: 0),
      Photo(id: '6', uri: 'https://picsum.photos/id/15/200/305', name: 'Photo 6', size: 600, timestamp: 0),
      Photo(id: '7', uri: 'https://picsum.photos/id/16/200/306', name: 'Photo 7', size: 700, timestamp: 0),
      Photo(id: '8', uri: 'https://picsum.photos/id/17/200/307', name: 'Photo 8', size: 800, timestamp: 0)];


    /*return galleryRepository.getPhotos();*/
  }
}
