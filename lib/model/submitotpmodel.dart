class SubmitOtpModel {
  String? status;
  String? message;
  String? error;

  SubmitOtpModel.withError(String errorMessage) {
    error = errorMessage;
  }


  SubmitOtpModel({this.status, this.message});

  SubmitOtpModel.fromJson(Map<String, dynamic> json) {
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
