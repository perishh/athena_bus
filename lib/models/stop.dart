class Stop {
  final int id;
  final String code;
  final String desc;
  final String? descEn;
  final String? street;
  final String? streetEn;
  final int heading;
  final double lng;
  final double lat;
  final int type;
  final bool amea;
  final String? terminal;
  final String? terminalEn;

  Stop({
    required this.id,
    required this.code,
    required this.desc,
    required this.descEn,
    required this.street,
    required this.streetEn,
    required this.heading,
    required this.lng,
    required this.lat,
    required this.type,
    required this.amea,
    required this.terminal,
    required this.terminalEn,
  });

  factory Stop.fromMap(Map<String, Object?> map) {
    return Stop(
      id: map['id'] as int,
      code: map['code'] as String,
      desc: map['desc'] as String,
      descEn: map['descEn'] as String?,
      street: map['street'] as String?,
      streetEn: map['streetEn'] as String?,
      heading: map['heading'] as int,
      lng: map['lng'] is int
          ? (map['lng'] as int).toDouble()
          : map['lng'] as double,
      lat: map['lat'] is int
          ? (map['lat'] as int).toDouble()
          : map['lat'] as double,
      type: map['type'] as int,
      amea: map['amea'] as int == 1,
      terminal: map['terminal'] as String?,
      terminalEn: map['terminalEn'] as String?,
    );
  }

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      id: int.parse(json['StopID'].toString()),
      code: json['StopCode'].toString(),
      desc: json['StopDescr'] as String,
      descEn: json['StopDescrEng'] as String?,
      street: json['StopStreet'] as String?,
      streetEn: json['StopStreetEng'] as String?,
      heading: int.parse((json['StopHeading']?.toString()) ?? "0"),
      lng: double.parse(json['StopLng'].toString()),
      lat: double.parse(json['StopLat'].toString()),
      type: int.parse(json['StopType'].toString()),
      amea: json['StopAmea'].toString() == "1",
      terminal: null,
      terminalEn: null,
    );
  }
}
