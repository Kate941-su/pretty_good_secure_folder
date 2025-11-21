import 'package:pretty_good_secure_folder/model/user.dart';
import 'package:pretty_good_secure_folder/service/shared_preference_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:openpgp/openpgp.dart';

import '../model/shared_preferences_key.dart';

part 'user_state.g.dart';

// Provider for storing measurements
@riverpod
class UserState extends _$UserState {
  @override
  User build() {
    return User(publicKey: "", privateKey: "");
  }

  Future<void> initialize() async {
    final pref = ref.watch(sharedPreferenceServiceProvider);
    String? publicKey = pref?.getString(SharedPreferencesKey.publicKey().key);
    String? privateKey = pref?.getString(SharedPreferencesKey.privateKey().key);
    if (publicKey == null || privateKey == null) {
      var keyOptions = KeyOptions()
        ..rsaBits = 2048;
      var keyPair = await OpenPGP.generate(
          options: Options()
            ..keyOptions = keyOptions);
      publicKey = keyPair.publicKey;
      privateKey = keyPair.privateKey;
    }
    state = User(publicKey: publicKey, privateKey: privateKey);
  }

}