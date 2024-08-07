class LoginModel {
  String? status;
  Data? data;
  String? message;
  String? tokenType;
  String? apiAccessToken;
  String? error;

  LoginModel.withError(String errorMessage) {
    error = errorMessage;
  }

  LoginModel(
      {this.status,
        this.data,
        this.message,
        this.tokenType,
        this.apiAccessToken});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    tokenType = json['token_type'];
    apiAccessToken = json['api_access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['token_type'] = this.tokenType;
    data['api_access_token'] = this.apiAccessToken;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? mobileNumber;
  bool? inRelation;

  Data({this.id, this.name, this.email, this.mobileNumber, this.inRelation});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobileNumber = json['mobile_number'];
    inRelation = json['in-relation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile_number'] = this.mobileNumber;
    data['in-relation'] = this.inRelation;
    return data;
  }
}
