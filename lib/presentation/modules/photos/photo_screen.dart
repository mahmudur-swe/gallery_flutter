import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_flutter/core/constants/app_dimens.dart';
import 'package:gallery_flutter/presentation/modules/photos/photo_bloc.dart';
import 'package:gallery_flutter/presentation/modules/photos/photo_event.dart';
import 'package:gallery_flutter/presentation/modules/photos/photo_state.dart';
import 'package:gallery_flutter/presentation/modules/photos/selection_cubit.dart';
import 'package:gallery_flutter/presentation/widgets/selectable_photo_tile.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/thumbnail_processor.dart';
import '../../../core/util/utils.dart';

//  WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<PhotoBloc>().add(LoadPhotos(albumId));
//     });

class PhotoScreen extends StatelessWidget {
  final ThumbnailProcessor thumbnailProcessor;

  const PhotoScreen({super.key, required this.thumbnailProcessor});

  @override
  Widget build(BuildContext context) {
    // final args =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return BlocConsumer<PhotoBloc, PhotoState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Photos",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              // or use any custom icon
              onPressed:
                  () => {
                    if (context.canPop()) context.pop() else Utils.exitApp(),
                  },
            ),
          ),
          body: Builder(
            builder: (context) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.errorMessage != null) {
                return Center(
                  child: Text(
                    'Error: ${state.errorMessage}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (state.photos.isEmpty) {
                return Center(
                  child: Text(
                    'No photos found.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(AppDimens.padding12),
                itemCount: state.photos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  final photo = state.photos[index];
                  final uri = photo.uri; // 🔁 Adjust if structure changes

                  return BlocSelector<SelectionCubit, Set<String>, bool>(
                    selector: (selection) => selection.contains(photo.id),
                    builder: (context, isSelected) {
                      return SelectablePhotoTile(
                        photoId: photo.id,
                        uri: photo.uri,
                        isSelected: isSelected,
                        onToggle:
                            () => {
                              context.read<SelectionCubit>().toggle(photo.id),
                            },
                        thumbnailProcessor: thumbnailProcessor,
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
