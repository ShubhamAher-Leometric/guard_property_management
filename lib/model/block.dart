class Block {
  late String status;
  late List<Data?> data; // Use nullable type for Data

  Block({required this.status, required this.data});

  Block.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['status'] = status;
    if (data.isNotEmpty) {
      map['data'] = data.map((v) => v!.toJson()).toList(); // Access data directly if it's not null
    }
    return map;
  }
}

class Data {
  late int blockId;
  late String name;

  Data({required this.blockId, required this.name});

  Data.fromJson(Map<String, dynamic> json) {
    blockId = json['block_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['block_id'] = blockId;
    map['name'] = name;
    return map;
  }
}
