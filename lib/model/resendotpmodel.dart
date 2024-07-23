class RegResendOtpModel {
  String? status;
  Data? data;
  String? message;
  String? error;

  RegResendOtpModel.withError(String errorMessage) {
    error = errorMessage;
  }

  RegResendOtpModel({this.status, this.data, this.message});

  RegResendOtpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? userId;
  int? otp;
  String? email;
  String? name;

  Data({this.userId, this.otp, this.email, this.name});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    otp = json['otp'];
    email = json['email'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['otp'] = this.otp;
    data['email'] = this.email;
    data['name'] = this.name;
    return data;
  }
}
