class Line {
  final int id;
  final String code;
  final String desc;
  final String descEn;
  final int masterLineId;
  final bool isMaster;

  Line({
    required this.id,
    required this.code,
    required this.desc,
    required this.descEn,
    required this.masterLineId,
    required this.isMaster,
  });

  factory Line.fromJson(Map<String, dynamic> json) {
    return Line(
      id: int.parse(json['line_code'].toString()),
      code: json['line_id'].toString(),
      desc: json['line_descr'].toString(),
      descEn: json['line_descr_eng'].toString(),
      masterLineId: int.parse(json['ml_code'].toString()),
      isMaster: (int.tryParse(json['mld_master'].toString()) ?? 0) == 1,
    );
  }

  (String, List<dynamic>) get sqlQuery => (
    "id, code, desc, descEn, masterLineId, isMaster",
    [id, code, desc, descEn, masterLineId, isMaster ? 1 : 0],
  );
}
