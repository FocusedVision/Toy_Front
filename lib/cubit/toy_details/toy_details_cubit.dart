import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:virtual_toy_shop/config/get_it.dart';
import 'package:virtual_toy_shop/data/const/const.dart';
import 'package:virtual_toy_shop/data/model/api_response.dart';
import 'package:virtual_toy_shop/data/model/product.dart';
import 'package:virtual_toy_shop/data/network/network_repository.dart';

part 'toy_details_state.dart';

class ToyDetailsCubit extends Cubit<ToyDetailsState> {
  ToyDetailsCubit() : networkRepository = getIt.get<NetworkRepository>(), super(ToyDetailsState());

  final NetworkRepository networkRepository;

  void getToyById(int id) async {
    emit(state.copyWith(isLoading: true, noConnection: false));
    ApiResponse response = await networkRepository.getProductById(id);
    if (response.success) {
      Product product = Product.fromJson(response.data);
      print("------------------------------");
      print("aga");
      sendAnalyticsEvent(0, id: product.id);
      print(product.id);
      emit(state.copyWith(currentProduct: product, isLoading: false));
    } else {
      if (response.data == noConnection) {
        emit(state.copyWith(noConnection: true));
      }
    }
  }
  String getInfoUrl(int id) => networkRepository.getInfoUrl(id);

  void sendAnalyticsEvent(int type, {int? seconds, required int id}) async {
    print("11111111");
    ApiResponse response = await networkRepository.sendAnalyticsEvent(
        id, type,
        seconds: seconds);
    print("------------------------------");
    print(type);
    print(response.success);
    print(response.data);
  }
}
