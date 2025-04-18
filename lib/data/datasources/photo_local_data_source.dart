import 'package:gallery_flutter/data/models/photo_response.dart';

class PhotoLocalDataSource {

  Future<List<PhotoModel>> fetchPhotos() async {
    return [
      PhotoModel(
        id: '1',
        uri: 'https://picsum.photos/id/10/200/300',
        name: 'Photo 1',
      ),
      PhotoModel(
        id: '2',
        uri: 'https://picsum.photos/id/11/200/301',
        name: 'Photo 2',
      ),
      PhotoModel(
        id: '3',
        uri: 'https://picsum.photos/id/12/200/302',
        name: 'Photo 3',
      ),
      PhotoModel(
        id: '4',
        uri: 'https://picsum.photos/id/13/200/303',
        name: 'Photo 4',
      ),
      PhotoModel(
        id: '5',
        uri: 'https://picsum.photos/id/14/200/304',
        name: 'Photo 5',
      ),
      PhotoModel(
        id: '6',
        uri: 'https://picsum.photos/id/15/200/305',
        name: 'Photo 6',
      ),
      PhotoModel(
        id: '7',
        uri: 'https://picsum.photos/id/16/200/306',
        name: 'Photo 7',
      ),
      PhotoModel(
        id: '8',
        uri: 'https://picsum.photos/id/17/200/307',
        name: 'Photo 8',
      ),
    ];
  }
}
