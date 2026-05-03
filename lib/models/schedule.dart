class Schedule {
  final List<String> come;
  final List<String> go;

  Schedule({required this.come, required this.go});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      come: (json['come'] as List<dynamic>)
          .where((x) => (x['sde_start2'] as String?) != null)
          .map((x) => _format((x['sde_start2'] as String)))
          .toList(),
      go: (json['go'] as List<dynamic>)
          .where((x) => (x['sde_start1'] as String?) != null)
          .map((x) => _format((x['sde_start1'] as String)))
          .toList(),
    );
  }
}

class ScheduleDay {
  final String desc;
  final String descEn;
  final String code;

  const ScheduleDay({
    required this.desc,
    required this.descEn,
    required this.code,
  });

  factory ScheduleDay.fromJson(Map<String, dynamic> json) {
    return ScheduleDay(
      desc: json['sdc_descr'],
      descEn: json['sdc_descr_eng'],
      code: json['sdc_code'].toString(),
    );
  }
}

String _format(String format) {
  final split = format.split(" ")[1].split(":");
  split.removeLast();
  return split.join(":");
}
