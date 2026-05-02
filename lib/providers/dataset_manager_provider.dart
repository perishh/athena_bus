import 'package:athena_bus/models/dataset.dart';
import 'package:athena_bus/services/dataset_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dataset_manager_provider.g.dart';

enum DatasetStatus { notDownloaded, downloading, downloaded, error }

@Riverpod(keepAlive: true)
class DatasetManager extends _$DatasetManager {
  @override
  Future<Map<Dataset, DatasetStatus>> build() async {
    return {
      Dataset.stops: await DatasetService.isDownloaded(Dataset.stops)
          ? DatasetStatus.downloaded
          : DatasetStatus.notDownloaded,
      Dataset.routes: await DatasetService.isDownloaded(Dataset.routes)
          ? DatasetStatus.downloaded
          : DatasetStatus.notDownloaded,
    };
  }

  Future download(Dataset dataset) async {
    try {
      state = AsyncValue.data(
        {...state.value!}..update(dataset, (_) => DatasetStatus.downloading),
      );
      await DatasetService.downloadDataset(dataset);
      state = AsyncValue.data(
        {...state.value!}..update(dataset, (_) => DatasetStatus.downloaded),
      );
    } catch (e, _) {
      state = AsyncValue.data(
        {...state.value!}..update(dataset, (_) => DatasetStatus.error),
      );
    }
  }
}
