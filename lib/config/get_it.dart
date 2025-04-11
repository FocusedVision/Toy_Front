import 'package:get_it/get_it.dart';
import 'package:virtual_toy_shop/config/soundpool_manager.dart';

import '../data/network/network_repository.dart';
import '../data/network/network_service.dart';

final getIt = GetIt.instance;

Future setup() async {
  getIt.registerSingleton<NetworkService>(NetworkService());
  getIt.registerSingleton<NetworkRepository>(NetworkRepository());

  final spm = SoundpoolManager();
  await spm.init();
  getIt.registerSingleton<SoundpoolManager>(
    spm,
    dispose: (instance) {
      instance.dispose();
    },
  );
}
