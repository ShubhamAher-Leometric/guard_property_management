class ReadDeleteNotificationModel {
  String? status;
  String? message;
  String? error;

  ReadDeleteNotificationModel.withError(String errorMessage) {
    error = errorMessage;
  }

  ReadDeleteNotificationModel({this.status, this.message});

  ReadDeleteNotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
