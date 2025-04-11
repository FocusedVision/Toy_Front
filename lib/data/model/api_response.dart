class ApiResponse {
  bool success;
  dynamic data;

  ApiResponse({
    this.data,
    this.success = false,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'],
      data: json['data'],
    );
  }
}
