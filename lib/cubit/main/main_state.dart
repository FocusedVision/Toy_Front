part of 'main_cubit.dart';

class MainState {
  MainStateScreen screen;
  ToyScreenState toyScreenState;
  bool isLoading;
  bool noConnection;
  int tabIndex;
  User? user;
  Products? paginatedProducts;
  Products? paginatedWishlistProducts;
  List<Product>? products;
  List<Product>? wishlistProducts;

  MainState({
    this.screen = MainStateScreen.loading,
    this.toyScreenState = ToyScreenState.feed,
    this.isLoading = false,
    this.noConnection = false,
    this.tabIndex = 1,
    this.user,
    this.products,
    this.paginatedProducts,
    this.wishlistProducts,
    this.paginatedWishlistProducts,
  });

  MainState copyWith({
    MainStateScreen? screen,
    ToyScreenState? toyScreenState,
    bool? isLoading,
    bool? noConnection,
    int? tabIndex,
    User? user,
    Products? paginatedProducts,
    Products? paginatedWishlistProducts,
    List<Product>? products,
    List<Product>? wishlistProducts,
    Product? currentProduct,
  }) {
    return MainState(
      screen: screen ?? this.screen,
      toyScreenState: toyScreenState ?? this.toyScreenState,
      isLoading: isLoading ?? this.isLoading,
      noConnection: noConnection ?? this.noConnection,
      tabIndex: tabIndex ?? this.tabIndex,
      user: user ?? this.user,
      paginatedProducts: paginatedProducts ?? this.paginatedProducts,
      products: products ?? this.products,
      wishlistProducts: wishlistProducts ?? this.wishlistProducts,
      paginatedWishlistProducts:
          paginatedWishlistProducts ?? this.paginatedWishlistProducts,
    );
  }
}

enum MainStateScreen { main, loading, intro, noConnection, newUser }

enum ToyScreenState { feed, grid }
