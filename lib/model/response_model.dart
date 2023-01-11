class ResponseModel<T> {
  late bool? status;
  late String? message;
  late T? data;

  ResponseModel({
    this.data,
    this.message,
    this.status,
  });

  ResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
  }
}
