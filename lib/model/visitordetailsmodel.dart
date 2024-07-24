class VisitorDetailsModel {
  String? status;
  Data? data;
  String? message;
  String? error;

  VisitorDetailsModel.withError(String errorMessage) {
    error = errorMessage;
  }

  VisitorDetailsModel({this.status, this.data, this.message});

  VisitorDetailsModel.fromJson(Map<String, dynamic> json) {
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
  int? visitId;
  String? unitInfo;
  String? purposeOfVisit;
  String? name;
  String? mobileNumber;
  String? ownerMobileNumber;
  String? status;
  String? visitType;
  String? entryType;
  String? date;
  String? expiredDate;
  String? visitTime;
  String? expiredTime;
  String? vehicleNumber;
  String? remark;
  String? nricPassportNo;
  String? idImage;

  Data(
      {this.visitId,
        this.unitInfo,
        this.purposeOfVisit,
        this.name,
        this.mobileNumber,
        this.ownerMobileNumber,
        this.status,
        this.visitType,
        this.entryType,
        this.date,
        this.expiredDate,
        this.visitTime,
        this.expiredTime,
        this.vehicleNumber,
        this.remark,
        this.nricPassportNo,
        this.idImage});

  Data.fromJson(Map<String, dynamic> json) {
    visitId = json['visit_id'];
    unitInfo = json['unit_info'];
    purposeOfVisit = json['purpose_of_visit'];
    name = json['name'];
    mobileNumber = json['mobile_number'];
    ownerMobileNumber = json['owner_mobile_number'];
    status = json['status'];
    visitType = json['visit_type'];
    entryType = json['entry_type'];
    date = json['date'];
    expiredDate = json['expired_date'];
    visitTime = json['visit_time'];
    expiredTime = json['expired_time'];
    vehicleNumber = json['vehicle_number'];
    remark = json['remark'];
    nricPassportNo = json['nric_passport_no'];
    idImage = json['id_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visit_id'] = this.visitId;
    data['unit_info'] = this.unitInfo;
    data['purpose_of_visit'] = this.purposeOfVisit;
    data['name'] = this.name;
    data['mobile_number'] = this.mobileNumber;
    data['owner_mobile_number'] = this.ownerMobileNumber;
    data['status'] = this.status;
    data['visit_type'] = this.visitType;
    data['entry_type'] = this.entryType;
    data['date'] = this.date;
    data['expired_date'] = this.expiredDate;
    data['visit_time'] = this.visitTime;
    data['expired_time'] = this.expiredTime;
    data['vehicle_number'] = this.vehicleNumber;
    data['remark'] = this.remark;
    data['nric_passport_no'] = this.nricPassportNo;
    data['id_image'] = this.idImage;
    return data;
  }
}
