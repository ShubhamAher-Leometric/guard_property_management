class Unit {
  Unit({
    required this.status,
    required this.data,
  });

  String status;
  List<Data> data;

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      status: json['status'],
      data: (json['data'] as List<dynamic>)
          .map((dataJson) => Data.fromJson(dataJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data.map((data) => data.toJson()).toList();
    }
    return map;
  }
}

class Data {
  Data({
    required this.unitId,
    required this.name,
  });

  int unitId;
  String name;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      unitId: json['unit_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['unit_id'] = unitId;
    map['name'] = name;
    return map;
  }
}
