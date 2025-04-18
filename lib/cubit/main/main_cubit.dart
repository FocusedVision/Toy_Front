import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:virtual_toy_shop/config/notification.dart';
import 'package:virtual_toy_shop/data/const/const.dart';
import 'package:virtual_toy_shop/data/model/products.dart';
import 'package:virtual_toy_shop/data/model/token_data.dart';
import '../../config/get_it.dart';
import '../../data/model/api_response.dart';
import '../../data/model/product.dart';
import '../../data/model/user.dart';
import '../../data/network/network_repository.dart';
import '../../data/network/network_service.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final NetworkRepository networkRepository;

  MainCubit([networkRepository])
      : networkRepository = networkRepository ?? getIt.get<NetworkRepository>(),
        super(MainState());

  void startVideo() async {
    emit(state.copyWith(screen: MainStateScreen.intro));
  }

  void initialize() async {
    //emit(state.copyWith(screen: MainStateScreen.loading));
    startVideo();
    //check if device ID is saved
    String? deviceId = await getNewDeviceId();
    String secretKey = getIt.get<NetworkService>().secretKey;
    String signature = '';

    // get session token
    final ApiResponse result = await networkRepository.getSessionToken();
    if (result.success) {
      //save session token
      TokenData tokenData = TokenData.fromJson(result.data);
      String sessionToken = tokenData.sessionToken ?? '';

      //get signature
      var bytesSignature = utf8.encode(sessionToken + secretKey);
      signature = sha256.convert(bytesSignature).toString();

      getAccessToken(
          sessionToken: sessionToken,
          signature: signature,
          deviceId: deviceId ?? '');
    } else if (result.data == noConnection) {
      emit(state.copyWith(screen: MainStateScreen.noConnection));
    }
  }

  Future<String?> getNewDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
    return null;
  }

  void getAccessToken(
      {required String sessionToken,
      required String signature,
      required String deviceId}) async {
    final ApiResponse response = await networkRepository.getAccessToken(
        sessionToken: sessionToken, signature: signature, deviceId: deviceId);
    if (response.success) {
      TokenData tokenData = TokenData.fromJson(response.data);

      getIt.get<NetworkService>().saveAuthSession(tokenData.accessToken ?? '');

      await getUser();
      await sendFirebaseToken();
      startPushNotifications();
      verifyFirebaseSetup();
      getProducts(1);
      getNewProducts();
    }
  }

  Future sendFirebaseToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print('Firebase Token Generated: $token'); // Debug log

      if (token == null) {
        print('Failed to generate Firebase token');
        return;
      }

      final authToken = await getIt.get<NetworkService>().getJwt();
      if (authToken == null) {
        print('No authentication token available');
        return;
      }

      ApiResponse response = await networkRepository.sendFirebaseToken(token);
      print('Firebase Token Send Response: ${response.success}'); // Debug log

      if (!response.success) {
        print('Failed to send token to backend: ${response.data}');
      }
    } catch (e) {
      print('Error in sendFirebaseToken: $e');
    }
  }

  void startPushNotifications() async {
    try {
      final fcm = FCM();
      await fcm.setNotifications();

      // Listen for notification opens
      fcm.streamBackground.stream.listen((data) {
        print('Notification opened from background');
        getProducts(1); // Refresh products
      });

      fcm.streamTerminated.stream.listen((data) {
        print('Notification opened from terminated state');
        getProducts(1); // Refresh products
      });

      await FirebaseMessaging.instance.unsubscribeFromTopic('new_products');
      await FirebaseMessaging.instance.subscribeToTopic('new_products');

      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        print('Push notifications not authorized');
        return;
      }

      print('Successfully subscribed to new_products topic');
    } catch (e) {
      print('Failed to setup push notifications: $e');
    }
  }

  Future getUser() async {
    ApiResponse response = await networkRepository.getUser();
    if (response.success) {
      User user = User.fromJson(response.data);
      emit(state.copyWith(user: user));
    }
  }

  void checkIfUserExistsAndGoToMain() async {
    if (state.user?.name?.isNotEmpty != true || state.user?.image == null) {
      emit(state.copyWith(screen: MainStateScreen.newUser));
    } else {
      toMain();
    }
  }

  void toMain() {
    if (state.paginatedProducts != null) {
      emit(
        state.copyWith(
          screen: MainStateScreen.main,
        ),
      );
    } else {
      emit(
        state.copyWith(
          screen: MainStateScreen.loading,
        ),
      );
    }
  }

  Future getProducts(int page) async {
    ApiResponse response = await networkRepository.getProducts(page: page);
    if (response.success) {
      Products paginatedProducts = Products.fromJson(response.data);
      emit(
        state.copyWith(
          paginatedProducts: paginatedProducts,
        ),
      );
      if (state.screen == MainStateScreen.loading) {
        emit(
          state.copyWith(
            screen: MainStateScreen.main,
          ),
        );
      }
      if (page == 1) {
        emit(state.copyWith(
          products: paginatedProducts.items,
        ));
      }
    }
  }

  Future getWishlistProducts(int page) async {
    ApiResponse response = await networkRepository.getWishlist(page: page);
    if (response.success) {
      Products paginatedProducts = Products.fromJson(response.data);
      emit(
        state.copyWith(
          paginatedWishlistProducts: paginatedProducts,
          noConnection: false,
        ),
      );
      if (page == 1) {
        emit(state.copyWith(
          wishlistProducts: paginatedProducts.items,
        ));
      }
    } else if (response.data == noConnection) {
      emit(state.copyWith(noConnection: true));
    }
  }

  Future getNewProducts() async {
    //load more products
    int lastPage = state.paginatedProducts?.pagination?.lastPage ?? 1;
    int currentPage = state.paginatedProducts?.pagination?.currentPage ?? 1;
    List<Product> products = state.products ?? [];
    if (lastPage > currentPage) {
      await getProducts(currentPage + 1);
      state.paginatedProducts?.items?.forEach((element) {
        products.add(element);
      });
      emit(state.copyWith(products: products));
    }
  }

  Future getNewWishlistProducts() async {
    //load more wishlist products
    int lastPage = state.paginatedWishlistProducts?.pagination?.lastPage ?? 1;
    int currentPage =
        state.paginatedWishlistProducts?.pagination?.currentPage ?? 1;
    List<Product> products = state.wishlistProducts ?? [];
    if (lastPage > currentPage) {
      await getWishlistProducts(currentPage + 1);
      state.paginatedWishlistProducts?.items?.forEach((element) {
        products.add(element);
      });
      emit(state.copyWith(wishlistProducts: products));
    }
  }

  void addToWishlist(int id) async {
    sendAnalyticsEvent(4, id: id);
    ApiResponse response = await networkRepository.addToWishlist(id);
    if (response.success) {
      getWishlistProducts(1);
    }

    //set locally isInUserProducts
    List<Product>? products = state.products;
    products?.firstWhere((element) => element.id == id).isInUserProducts = true;
    emit(state.copyWith(products: products));
  }

  void removeFromWishlist(int id) async {
    ApiResponse response = await networkRepository.removeFromWishlist(id);
    if (response.success) {
      getWishlistProducts(1);
    }
    //set locally isInUserProducts
    List<Product>? products = state.products;
    products?.firstWhere((element) => element.id == id).isInUserProducts =
        false;
    emit(state.copyWith(products: products));
  }

  void like(int id) async {
    sendAnalyticsEvent(5, id: id);
    ApiResponse response = await networkRepository.likeProduct(id);
    //set locally like
    List<Product> products = [];
    products.addAll(state.products!);
    products.firstWhere((element) => element.id == id).isLiked = true;
    emit(state.copyWith(products: products));
  }

  void dislike(int id) async {
    ApiResponse response = await networkRepository.removeLikeFromProduct(id);
    //set locally dislike
    List<Product>? products = [];
    products.addAll(state.products!);
    products.firstWhere((element) => element.id == id).isLiked = false;
    emit(state.copyWith(products: products));
  }

  void refreshProducts() {
    List<Product>? products = state.products;
    emit(state.copyWith(products: products));
  }

  void changeTab(int index) {
    if (index == 2) {
      getWishlistProducts(1);
    }
    emit(state.copyWith(tabIndex: index));
  }

  void changeToyScreenState() {
    if (state.toyScreenState == ToyScreenState.feed) {
      emit(state.copyWith(toyScreenState: ToyScreenState.grid));
    } else {
      emit(state.copyWith(toyScreenState: ToyScreenState.feed));
    }
  }

  bool isFeedOpened() {
    if (state.toyScreenState == ToyScreenState.feed) {
      return true;
    } else {
      return false;
    }
  }

  void sendAnalyticsEvent(int type, {int? seconds, required int id}) async {
    ApiResponse response =
        await networkRepository.sendAnalyticsEvent(id, type, seconds: seconds);
    print(type);
    print(response.success);
    print(response.data);
  }

  void checkNotificationSettings() async {
    ApiResponse response = await networkRepository.getNotificationSettings();
    if (response.success) {
      bool isEnabled = response.data['is_enabled'];
      if (!isEnabled) {
        print('Notifications are disabled in user settings');
      }
    }
  }

  void verifyFirebaseSetup() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission();
      print('Notification Settings:');
      print('Authorization Status: ${settings.authorizationStatus}');
      print('Alert Setting: ${settings.alert}');
      print('Badge Setting: ${settings.badge}');
      print('Sound Setting: ${settings.sound}');

      // Verify topic subscription
      await FirebaseMessaging.instance.subscribeToTopic('new_products');
      print('Topic subscription successful');
    } catch (e) {
      print('Firebase verification failed: $e');
    }
  }

  Future<Map<String, dynamic>?> getWishlistShareLink() async {
    try {
      ApiResponse response = await networkRepository.getWishlistShareLink();
      if (response.success && response.data != null) {
        final shareUrl = response.data['shareUrl'];
        final productsCount = response.data['productsCount'];

        if (shareUrl == null || productsCount == null) {
          return null;
        }

        return {
          'share_url': shareUrl.toString(),
          'products_count': productsCount as int,
        };
      }
      return null;
    } catch (e) {
      print('Error getting wishlist share link: $e');
      return null;
    }
  }
}
