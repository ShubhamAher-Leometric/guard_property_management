class VisitorHistoryModel {
  String? status;
  List<Data>? data;
  String? message;
  String? error;

  VisitorHistoryModel.withError(String errorMessage) {
    error = errorMessage;
  }
  VisitorHistoryModel({this.status, this.data, this.message});

  VisitorHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? visitId;
  String? unitInfo;
  String? name;
  String? mobileNumber;
  String? visitDate;
  String? status;
  String? createdBy;

  Data(
      {this.visitId,
        this.unitInfo,
        this.name,
        this.mobileNumber,
        this.visitDate,
        this.status,
        this.createdBy});

  Data.fromJson(Map<String, dynamic> json) {
    visitId = json['visit_id'];
    unitInfo = json['unit_info'];
    name = json['name'];
    mobileNumber = json['mobile_number'];
    visitDate = json['visit_date'];
    status = json['status'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visit_id'] = this.visitId;
    data['unit_info'] = this.unitInfo;
    data['name'] = this.name;
    data['mobile_number'] = this.mobileNumber;
    data['visit_date'] = this.visitDate;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    return data;
  }
}