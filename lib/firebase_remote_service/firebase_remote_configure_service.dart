import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigService {
  static bool dashBordScreen = false;

  static Future init() async {
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(seconds: 10),
    ));
    await remoteConfig
        .setDefaults(const {"DashboardScreen": false});
    await remoteConfig.fetchAndActivate();
    dashBordScreen = remoteConfig.getBool('DashboardScreen');
  }
}