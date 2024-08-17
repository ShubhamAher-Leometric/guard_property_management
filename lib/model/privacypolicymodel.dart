class PrivacyPolicyModel {
  String? status;
  Data? data;
  String? message;
  String? error;

  PrivacyPolicyModel.withError(String errorMessage) {
    error = errorMessage;
  }
  PrivacyPolicyModel({this.status, this.data, this.message});

  PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
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
  String? pageName;
  String? content;

  Data({this.pageName, this.content});

  Data.fromJson(Map<String, dynamic> json) {
    pageName = json['page_name'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_name'] = this.pageName;
    data['content'] = this.content;
    return data;
  }
}
