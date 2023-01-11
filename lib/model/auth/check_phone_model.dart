class CheckMobileModel {
  int? status;
  bool? error;
  String? message;

  CheckMobileModel({this.status, this.error, this.message});

  CheckMobileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
  }
}
