class CheckEmailModel {
  int? status;
  bool? error;
  String? message;

  CheckEmailModel({this.status, this.error, this.message});

  CheckEmailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
  }
}
