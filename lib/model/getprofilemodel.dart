class GetProfileModel {
  String? status;
  Data? data;
  String? error;

  GetProfileModel.withError(String errorMessage) {
    error = errorMessage;
  }

  GetProfileModel({this.status, this.data});

  GetProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? name;
  String? email;
  String? profileImage;
  String? mobileNumber;

  Data({this.name, this.email, this.profileImage, this.mobileNumber});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    profileImage = json['profile_image'];
    mobileNumber = json['mobile_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['profile_image'] = this.profileImage;
    data['mobile_number'] = this.mobileNumber;
    return data;
  }
}
