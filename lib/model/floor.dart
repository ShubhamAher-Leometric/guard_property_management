class Floor {
  Floor({
    required String status,
    List<Data>? data,
  }) : _status = status,
        _data = data ?? [];

  Floor.fromJson(dynamic json)
      : _status = json['status'] ?? '',
        _data = json['data'] != null
            ? List<Data>.from((json['data'] as List).map((x) => Data.fromJson(x)))
            : [];

  late String _status;
  late List<Data> _data;

  String get status => _status;
  List<Data> get data => _data;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['status'] = _status;
    map['data'] = _data.map((v) => v.toJson()).toList();
    return map;
  }
}

class Data {
  Data({
    required this.floorId,
    required this.name,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      floorId: json['floor_id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  final int floorId;
  final String name;

  Map<String, dynamic> toJson() {
    return {
      'floor_id': floorId,
      'name': name,
    };
  }
}
