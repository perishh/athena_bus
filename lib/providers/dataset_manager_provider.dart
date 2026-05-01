import 'package:athena_bus/services/dataset_service.dart';
import 'package:athena_bus/services/database_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dataset_manager_provider.g.dart';
part 'dataset_manager_provider.freezed.dart';

enum DatasetStatus { notDownloaded, downloading, downloaded, error }

@freezed
abstract class DatasetManagerState with _$DatasetManagerState {
  const factory DatasetManagerState({required DatasetStatus stopsStatus}) =
      _DatasetManagerState;
}

@Riverpod(keepAlive: true)
class DatasetManager extends _$DatasetManager {
  @override
  Future<DatasetManagerState> build() async {
    return DatasetManagerState(
      stopsStatus: await DatasetService.isDownloaded(DatabaseService.stopsKey)
          ? DatasetStatus.downloaded
          : DatasetStatus.notDownloaded,
    );
  }

  Future downloadStops() async {
    try {
      state = AsyncValue.data(
        state.value!.copyWith(stopsStatus: DatasetStatus.downloading),
      );
      await DatasetService.downloadDataset("stops");
      state = AsyncValue.data(
        state.value!.copyWith(stopsStatus: DatasetStatus.downloaded),
      );
    } catch (e, _) {
      state = AsyncValue.data(
        state.value!.copyWith(stopsStatus: DatasetStatus.error),
      );
    }
  }
}
