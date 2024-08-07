class NotificationCountModel {
  String? status;
  int? data;
  String? error;

  NotificationCountModel.withError(String errorMessage) {
    error = errorMessage;
  }
  NotificationCountModel({this.status, this.data});

  NotificationCountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['data'] = this.data;
    return data;
  }
}
