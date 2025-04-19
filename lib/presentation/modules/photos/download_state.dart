

class DownloadState {
  final int current;
  final int total;
  final bool isDownloading;
  final bool isComplete;
  final Set<String> downloadedIds;
  final Set<String> failedIds;

  const DownloadState({
    this.current = 0,
    this.total = 0,
    this.isDownloading = false,
    this.isComplete = false,
    this.downloadedIds = const {},
    this.failedIds = const {},
  });

  DownloadState copyWith({
    int? current,
    int? total,
    bool? isDownloading,
    bool? isComplete,
    Set<String>? downloadedIds,
    Set<String>? failedIds,
  }) {
    return DownloadState(
      current: current ?? this.current,
      total: total ?? this.total,
      isDownloading: isDownloading ?? this.isDownloading,
      isComplete: isComplete ?? this.isComplete,
      downloadedIds: downloadedIds ?? this.downloadedIds,
      failedIds: failedIds ?? this.failedIds,
    );
  }
}