class ApiResponse {
  int statusCode;
  String message;

  ApiResponse(this.statusCode, this.message);

  static ApiResponse fromJson(json) {
    int statusCode = json['statusCode'];
    String message = json['message'];
    return ApiResponse(statusCode, message);
  }

  static Map toJson(ApiResponse apiResponse) {
    Map json = {};
    json['statusCode'] = apiResponse.statusCode;
    json['message'] = apiResponse.message;
    return json;
  }

  static ApiResponse empty() {
    return ApiResponse(0, '');
  }

  static bool isEmpty(ApiResponse apiResponse) {
    return apiResponse.statusCode == 0 && apiResponse.message == '';
  }
}