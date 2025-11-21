import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';
import 'package:openpgp/openpgp.dart';
import 'package:pretty_good_secure_folder/database/entity/item_schema.dart';

part 'vault_item.freezed.dart';

@freezed
abstract class VaultItem with _$VaultItem {
  const VaultItem._();
  const factory VaultItem({
    required int id,
    required String key,
    required String value,
  }) = _VaultItem;

  Future<Item> toItemSchemaWithEncryption(String publicKey) async {
    final encryptedValue = await OpenPGP.encrypt(value, publicKey);
    final encryptedKey = await OpenPGP.encrypt(key, publicKey);
    Item i = Item();
    i.id = id;
    i.key = encryptedKey;
    i.value = encryptedValue;
    return i;
  }

}