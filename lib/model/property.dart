class Property {
  late String status;
  late List<Data> data;

  Property({
    required this.status,
    required this.data,
  });

  Property.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}

class Data {
  late int propertyId;
  late String name;

  Data({
    required this.propertyId,
    required this.name,
  });

  Data.fromJson(Map<String, dynamic> json) {
    propertyId = json['property_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['property_id'] = propertyId;
    data['name'] = name;
    return data;
  }
}
