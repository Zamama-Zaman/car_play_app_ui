import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/streams.dart';

class AssetAudioPlayerProvider with ChangeNotifier {
  final _assetsAudioPlayer = AssetsAudioPlayer();

  get getAssetAudioPlayer => _assetsAudioPlayer;

  creatPlaylistAssetAudioPlayer(List<Audio> _audio) {
    _assetsAudioPlayer.open(
      Playlist(audios: _audio),
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      showNotification: true,
      autoStart: false,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    super.dispose();
  }

  playAssetAudioPlayer() {
    _assetsAudioPlayer.play();
    notifyListeners();
  }

  pauseAssetAudioPlayer() {
    _assetsAudioPlayer.pause();
    notifyListeners();
  }

  playPauseAssetAudioPlayer() {
    _assetsAudioPlayer.playOrPause();
    notifyListeners();
  }

  fastforwardAssetAudioPlayer() {
    _assetsAudioPlayer.forwardOrRewind(30);
    notifyListeners();
  }

  fastRewindAssetAudioPlayer() {
    _assetsAudioPlayer.forwardOrRewind(-30);
    notifyListeners();
  }

  ValueStream<Duration> currentPositionAssetAudioPlayer() {
    return _assetsAudioPlayer.currentPosition;
  }

  seekDurationAssetAudioPlayer(Duration val) {
    _assetsAudioPlayer.seek(val);
    notifyListeners();
  }
}
