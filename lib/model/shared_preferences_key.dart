import 'package:freezed_annotation/freezed_annotation.dart';

part 'shared_preferences_key.freezed.dart';

@freezed
abstract class SharedPreferencesKey with _$SharedPreferencesKey {
  const SharedPreferencesKey._();
  const factory SharedPreferencesKey.publicKey() = PublicKey;
  const factory SharedPreferencesKey.privateKey() = PrivateKey;

  String get key {
    return when(
        publicKey: () => "public_key",
        privateKey: () => "private_key"
    );
  }

}