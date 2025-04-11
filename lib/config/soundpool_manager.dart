import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class SoundpoolManager{
  late Soundpool _soundpool;

  final Map<String, int> _soundMap = {};

  Future init() async {
    _soundpool = Soundpool.fromOptions(
      options: const SoundpoolOptions(
          streamType: StreamType.notification
      )
    );

    await _loadSounds();
  }

  void play({int? soundId, String? soundName}){

    assert(soundId != null || soundName != null);

    if(soundId != null){
      _soundpool.play(soundId);
    }
    else if(soundName != null){
      final localSoundId = _soundMap[soundName];
      if(localSoundId != null){
        _soundpool.play(localSoundId);
      }
    }

  }

  Future _loadSounds() async {
    final soundsPath = await _getSoundsAssetsPath();
    for (var element in soundsPath) {
      final soundName = element.split('/').last.split('.').first;
      final soundData = await rootBundle.load(element);
      final soundId = await _soundpool.load(soundData);
      _soundMap[soundName] = soundId;
    }
  }

  Future<List<String>> _getSoundsAssetsPath() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    return manifestMap.keys
        .where((String key) => key.contains('sounds/'))
        .where((String key) => key.contains('.mp3'))
        .toList();
  }


  void dispose(){
    _soundpool.dispose();
  }
}