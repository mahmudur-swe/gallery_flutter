import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_flutter/core/constants/app_dimens.dart';
import 'package:gallery_flutter/presentation/modules/photos/photo_bloc.dart';
import 'package:gallery_flutter/presentation/modules/photos/photo_event.dart';
import 'package:gallery_flutter/presentation/modules/photos/photo_state.dart';
import 'package:go_router/go_router.dart';

import '../../../core/util/utils.dart';
import '../../../di/injection_container.dart';

//  WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<PhotoBloc>().add(LoadPhotos(albumId));
//     });

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final args =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return BlocProvider(
      // bloc injected by dependency injection
      create: (_) => sl<PhotoBloc>()..add(LoadPhotos()),
      child: BlocConsumer<PhotoBloc, PhotoState>(
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

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(AppDimens.radius6),
                      child: Image.network(
                        uri,
                        fit: BoxFit.cover,
                        key: ValueKey(photo.id),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
