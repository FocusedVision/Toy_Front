part of 'toy_details_cubit.dart';

class ToyDetailsState {
  Product? currentProduct;
  bool isLoading;
  bool noConnection;

  ToyDetailsState({
    this.currentProduct,
    this.isLoading = false,
    this.noConnection = false,
  });

  ToyDetailsState copyWith({
    bool? isLoading,
    bool? noConnection,
    Product? currentProduct,
  }) {
    return ToyDetailsState(
      isLoading: isLoading ?? this.isLoading,
      noConnection: noConnection ?? this.noConnection,
      currentProduct: currentProduct ?? this.currentProduct,
    );
  }
}

