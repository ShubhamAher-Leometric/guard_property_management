class ChangePasswordModel {
  String? status;
  String? message;
  String? error;

  ChangePasswordModel.withError(String errorMessage) {
    error = errorMessage;
  }

  ChangePasswordModel({this.status, this.message});

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
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
