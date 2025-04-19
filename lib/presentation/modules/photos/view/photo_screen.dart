import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_flutter/core/constants/app_dimens.dart';
import 'package:gallery_flutter/presentation/modules/photos/bloc/photo_bloc.dart';
import 'package:gallery_flutter/presentation/modules/photos/cubit/selection_cubit.dart';
import 'package:gallery_flutter/presentation/widgets/selectable_photo_tile.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_string.dart';
import '../../../../core/services/thumbnail_processor.dart';
import '../../../../core/theme/app_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/utils.dart';
import '../bloc/photo_state.dart';
import '../cubit/download_cubit.dart';
import '../cubit/download_state.dart';

//  WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<PhotoBloc>().add(LoadPhotos(albumId));
//     });

class PhotoScreen extends StatelessWidget {
  final ThumbnailProcessor thumbnailProcessor;

  const PhotoScreen({super.key, required this.thumbnailProcessor});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhotoBloc, PhotoState>(
      listener: (context, state) {
        // Show error snack bar
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        // Use PopScope to prevent back button from popping the screen
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            final downloadState = context.read<DownloadCubit>().state;
            final selectedIds = context.read<SelectionCubit>().state;

            if (downloadState.isDownloading) {
              await showDialog<bool>(
                context: context,
                builder:
                    (internalContext) => AlertDialog(
                      title: const Text(AppString.cancelDownload),
                      content: const Text(AppString.msgDownloading),
                      actions: [
                        TextButton(
                          onPressed:
                              () => Navigator.of(internalContext).pop(true),
                          child: const Text(AppString.no),
                        ),
                        TextButton(
                          onPressed:
                              () => {
                                Navigator.of(internalContext).pop(true),
                                context.read<DownloadCubit>().reset(),
                              },
                          child: const Text(AppString.yes),
                        ),
                      ],
                    ),
              );
            } else if (downloadState.isComplete) {
              context.read<DownloadCubit>().reset();
              context.read<SelectionCubit>().reset();
            } else if (selectedIds.isNotEmpty) {
              context.read<SelectionCubit>().reset();
            } else {
              if (context.canPop()) {
                context.pop();
              } else {
                Utils.exitApp();
              }
            }
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                AppString.appName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                // or use any custom icon
                onPressed:
                    () => {
                      Navigator.of(context).maybePop(),
                      //if (context.canPop()) context.pop() else Utils.exitApp(),
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
                      AppString.msgNoPhotosFound,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }

                return Stack(
                  children: [
                    // Grid of Images
                    GridView.builder(
                      padding: const EdgeInsets.only(
                        top: AppDimens.padding12,
                        left: AppDimens.padding12,
                        right: AppDimens.padding12,
                        bottom:
                            AppDimens
                                .padding100, // leave space for button visibility
                      ),
                      itemCount: state.photos.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                      itemBuilder: (context, index) {
                        final photo = state.photos[index];
                        final uri = photo.uri;

                        return BlocSelector<SelectionCubit, Set<String>, bool>(
                          selector: (selection) => selection.contains(photo.id),
                          builder: (context, isSelected) {
                            // Selectable photo tile to select and deselect photos
                            return SelectablePhotoTile(
                              photoId: photo.id,
                              uri: uri,
                              isSelected: isSelected,
                              // onToggle to toggle the selection state of the photo
                              onToggle:
                                  () => context.read<SelectionCubit>().toggle(
                                    photo.id,
                                  ),
                              thumbnailProcessor: thumbnailProcessor,
                            );
                          },
                        );
                      },
                    ),

                    //Download Button Overlay
                    BlocBuilder<SelectionCubit, Set<String>>(
                      builder: (context, selectedIds) {
                        if (selectedIds.isEmpty) return const SizedBox.shrink();

                        return Positioned(
                          bottom: AppDimens.padding32,
                          left: AppDimens.padding32,
                          right: AppDimens.padding32,

                          child: BlocSelector<
                            DownloadCubit,
                            DownloadState,
                            bool
                          >(
                            selector:
                                (state) =>
                                    state.isDownloading || state.isComplete,
                            builder: (context, isBusy) {
                              if (isBusy) {
                                return const SizedBox.shrink();
                              }

                              return ElevatedButton(
                                key: const Key('download_button'),
                                style: AppButtonStyles.elevatedButtonSecondary,
                                onPressed: () {
                                  final photos =
                                      context.read<PhotoBloc>().state.photos;
                                  final selectedPhotos =
                                      photos
                                          .where(
                                            (p) => selectedIds.contains(p.id),
                                          )
                                          .toList();
                                  context.read<DownloadCubit>().download(
                                    selectedPhotos,
                                  );
                                },
                                child: Text(AppString.download),
                              );
                            },
                          ),
                        );
                      },
                    ),

                    BlocBuilder<DownloadCubit, DownloadState>(
                      builder: (context, state) {
                        if (!state.isDownloading && !state.isComplete) {
                          return const SizedBox.shrink();
                        }

                        var title =
                            state.isDownloading
                                ? AppString.downloading
                                : AppString.downloadComplete;

                        return Center(
                          child: AlertDialog(
                            backgroundColor: Colors.grey.shade100,
                            // or Colors.grey[200]
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimens.radius16,
                              ),
                            ),
                            title: Text(title),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                LinearProgressIndicator(
                                  value:
                                      state.total > 0
                                          ? state.current / state.total
                                          : null,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Completed: ${state.downloadedIds.length} / ${state.total}\n'
                                  'Failed: ${state.failedIds.length}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            actions: [
                              if (state.isComplete)
                                TextButton(
                                  onPressed: () {
                                    context.read<DownloadCubit>().reset();
                                    context.read<SelectionCubit>().reset();
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.primaryVariant,
                                  ),
                                  child: const Text(AppString.done),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
