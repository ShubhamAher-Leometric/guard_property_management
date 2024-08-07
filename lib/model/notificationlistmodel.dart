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
  int? defectId;
  int? propertyId;
  String? visitorName;
  String? requestType;
  int? blockId;
  int? floorId;
  int? unitId;
  String? visitTime;
  int? userId;

  AdditionalData(
      {this.defectId,
        this.propertyId,
        this.visitorName,
        this.requestType,
        this.blockId,
        this.floorId,
        this.unitId,
        this.visitTime,
        this.userId});

  AdditionalData.fromJson(Map<String, dynamic> json) {
    defectId = json['defect_id'];
    propertyId = json['property_id'];
    visitorName = json['visitor_name'];
    requestType = json['request_type'];
    blockId = json['block_id'];
    floorId = json['floor_id'];
    unitId = json['unit_id'];
    visitTime = json['visit_time'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['defect_id'] = this.defectId;
    data['property_id'] = this.propertyId;
    data['visitor_name'] = this.visitorName;
    data['request_type'] = this.requestType;
    data['block_id'] = this.blockId;
    data['floor_id'] = this.floorId;
    data['unit_id'] = this.unitId;
    data['visit_time'] = this.visitTime;
    data['user_id'] = this.userId;
    return data;
  }
}
