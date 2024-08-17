class NotificationListModel {
  String? status;
  List<Data>? data;
  String? error;

  NotificationListModel.withError(String errorMessage) {
    error = errorMessage;
  }

  NotificationListModel({this.status, this.data});

  NotificationListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? notificationText;
  String? status;
  String? notificationType;
  String? date;
  AdditionalData? additionalData;

  Data(
      {this.id,
        this.notificationText,
        this.status,
        this.notificationType,
        this.date,
        this.additionalData});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notificationText = json['notification_text'];
    status = json['status'];
    notificationType = json['notification_type'];
    date = json['date'];
    additionalData = json['additional_data'] != null
        ? new AdditionalData.fromJson(json['additional_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['notification_text'] = this.notificationText;
    data['status'] = this.status;
    data['notification_type'] = this.notificationType;
    data['date'] = this.date;
    if (this.additionalData != null) {
      data['additional_data'] = this.additionalData!.toJson();
    }
    return data;
  }
}

class AdditionalData {
  String? visitorName;
  String? requestType;
  int? visitId;
  int? blockId;
  int? floorId;
  int? unitId;
  String? visitTime;

  AdditionalData(
      {this.visitorName,
        this.requestType,
        this.visitId,
        this.blockId,
        this.floorId,
        this.unitId,
        this.visitTime});

  AdditionalData.fromJson(Map<String, dynamic> json) {
    visitorName = json['visitor_name'];
    requestType = json['request_type'];
    visitId = json['visit_id'];
    blockId = json['block_id'];
    floorId = json['floor_id'];
    unitId = json['unit_id'];
    visitTime = json['visit_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visitor_name'] = this.visitorName;
    data['request_type'] = this.requestType;
    data['visit_id'] = this.visitId;
    data['block_id'] = this.blockId;
    data['floor_id'] = this.floorId;
    data['unit_id'] = this.unitId;
    data['visit_time'] = this.visitTime;
    return data;
  }
}
