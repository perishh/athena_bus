import 'package:athena_bus/models/line.dart';
import 'package:athena_bus/models/schedule.dart';
import 'package:athena_bus/repositories/line_repository.dart';
import 'package:athena_bus/services/api_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'schedule_provider.g.dart';
part 'schedule_provider.freezed.dart';

@freezed
abstract class LineScheduleState with _$LineScheduleState {
  const factory LineScheduleState({
    required Line line,
    required List<ScheduleDay> days,
  }) = _LineScheduleState;
}

@Riverpod(keepAlive: true)
class LineSchedule extends _$LineSchedule {
  @override
  Future<LineScheduleState> build(int lineId) async {
    final line = await LineRepository.getLineById(lineId);
    if (line == null) throw Exception('Line $lineId not found');

    final days = await ApiService.getScheduleDays(lineId);

    final allDays = [
      const ScheduleDay(
        desc: 'ΣΗΜΕΡΑ',
        descEn: 'TODAY',
        code: 'today',
      ),
      ...days,
    ];

    return LineScheduleState(line: line, days: allDays);
  }
}

@Riverpod(keepAlive: true)
class ScheduleItinerary extends _$ScheduleItinerary {
  @override
  Future<Schedule> build({
    required int masterLineId,
    required int lineId,
    required String scheduleCode,
  }) async {
    if (scheduleCode == 'today') {
      return ApiService.getDailySchedule(lineId);
    }
    return ApiService.getSchedule(masterLineId, lineId, scheduleCode);
  }
}
