import 'package:dio/dio.dart';
import 'package:virtual_toy_shop/config/get_it.dart';
import 'package:virtual_toy_shop/data/const/const.dart';

import '../model/api_response.dart';
import 'network_service.dart';

class NetworkRepository {
  NetworkService service = getIt.get<NetworkService>();

  ApiResponse errorResponse(Response? error) {
    if (error != null) {
      return ApiResponse.fromJson(error.data);
    } else {
      return ApiResponse(success: false, data: noConnection);
    }
  }

  Future getSessionToken() async {
    String endPoint = 'api/auth/session';
    final api = service.getApiClient();
    try {
      final result = await api!.post(endPoint);
      return ApiResponse.fromJson(result.data);
    } on DioException catch (error) {
      return errorResponse(error.response);
    }
  }

  Future getAccessToken(
      {required String sessionToken,
      required String signature,
      required String deviceId}) async {
    String endPoint = 'api/auth/token';
    final api = service.getApiClient();
    try {
      final params = {
        "sessionToken": sessionToken,
        "signature": signature,
        "deviceId": deviceId,
      };
      final result = await api!.post(endPoint, data: params);
      return ApiResponse.fromJson(result.data);
    } on DioException catch (error) {
      return errorResponse(error.response);
    }
  }

  Future getUser() async {
    String endPoint = 'api/user';
    final api = service.getApiClient();
    try {
      final result = await api!.get(endPoint);
      return ApiResponse.fromJson(result.data);
    } on DioException catch (error) {
      return errorResponse(error.response);
    }
  }

  Future getWishlist({required int page}) async {
    String endPoint = 'api/user/products/?page=$page';
    final api = service.getApiClient();
    try {
      final result = await api!.get(endPoint);
      return ApiResponse.fromJson(result.data);
    } on DioException catch (error) {
      return errorResponse(error.response);
    }
  }

  Future addToWishlist(int id) async {
    String endPoint = 'api/user/products/$id';
    final api = service.getApiClient();
    try {
      final result = await api!.post(endPoint);
      return ApiResponse.fromJson(result.data);
    } on DioException catch (error) {
      return errorResponse(error.response);
    }
  }

  Future removeFromWishlist(int id) async {
    String endPoint = 'api/user/products/$id';
    final api = service.getApiClient();
    try {
      final result = await api!.delete(endPoint);
      return ApiResponse.fromJson(result.data);
    } on DioException catch (error) {
      return errorResponse(error.response);
    }
  }

  Future likeProduct(int id) async {
    String endPoint = 'api/products/$id/likes';
    final api = service.getApiClient();
    try {
      final result = await api!.post(endPoint);
      return ApiResponse.fromJson(result.data);
    } on DioException catch (error) {
      return errorResponse(error.response);
    }
  }

  Future removeLikeFromProduct(int id) async {
    String endPoint = 'api/products/$id/likes';
    final api = service.getApiClient();
    try {
      final result = await api!.delete(endPoint);
      return ApiResponse.fromJson(result.data);
    } on DioException catch (error) {
      return errorResponse(error.response);
    }
  }

  Future getProducts({required int page}) async {
    String endPoint = 'api/products/?page=$page';
    final api = service.getApiClient();
    try {
      final result = await api!.get(endPoint);
      return ApiResponse.fromJson(result.data);
    } on DioException catch (error) {
      return errorResponse(error.response);
    }
  }

  Future getProductById(int id) async {
    String endPoint = 'api/products/$id';
    final api = service.getApiClient();
    try {
      final result = await api!.get(endPoint);
      return ApiResponse.fromJson(result.data);
    } on DioException catch (error) {
      return errorResponse(error.response);
    }
  }

  String getInfoUrl(int id) {
    String endPoint = 'api/products/$id/info';
    return "${service.url}$endPoint";
  }

  Future sendAnalyticsEvent(int id, int type, {int? seconds}) async {
    String endPoint = 'api/products/$id/events';
    final api = service.getApiClient();
    try {
      final params = {"type": type, if (seconds != null) "seconds": seconds};
      print(params);
      final result = await api!.post(endPoint, data: params);
      return ApiResponse.fromJson(result.data);
    } on DioException catch (error) {
      return errorResponse(error.response);
    }
  }

  Future getAvatars() async {
    String endPoint = 'api/user/avatars';
    final api = service.getApiClient();
    try {
      final result = await api!.get(endPoint);
      return ApiResponse.fromJson(result.data);
    } on DioException catch (error) {
      return errorResponse(error.response);
    }
  }

  Future updateUser(String? name, String? image) async {
    String endPoint = 'api/user';
    final api = service.getApiClient();
    try {
      final params = {
        if (name != null) "name": name,
        if (image != null) "image": image,
      };
      final result = await api!.post(endPoint, data: params);
      return ApiResponse.fromJson(result.data);
    } on DioException catch (error) {
      return errorResponse(error.response);
    }
  }

  Future sendFirebaseToken(String token) async {
    String endPoint = 'api/user/push-tokens';
    final api = service.getApiClient();
    try {
      final params = {
        "token": token,
      };
      final result = await api!.post(endPoint, data: params);
      return ApiResponse.fromJson(result.data);
    } on DioException catch (error) {
      return errorResponse(error.response);
    }
  }

  Future<ApiResponse> getNotificationSettings() async {
    String endPoint = 'api/user/notification';
    final api = service.getApiClient();
    try {
      final result = await api!.get(endPoint);
      return ApiResponse.fromJson(result.data);
    } on DioException catch (error) {
      return errorResponse(error.response);
    }
  }

  Future<ApiResponse> updateNotificationSettings(
      {required bool isEnabled}) async {
    String endPoint = 'api/user/notification';
    final api = service.getApiClient();
    try {
      final params = {
        'is_enabled': isEnabled,
      };
      final result = await api!.post(endPoint, data: params);
      return ApiResponse.fromJson(result.data);
    } on DioException catch (error) {
      return errorResponse(error.response);
    }
  }

  Future getWishlistShareLink() async {
    String endPoint = 'api/user/wishlist/share';
    final api = service.getApiClient();
    try {
      final result = await api!.get(endPoint);
      return ApiResponse.fromJson(result.data);
    } on DioException catch (error) {
      return errorResponse(error.response);
    }
  }
}
