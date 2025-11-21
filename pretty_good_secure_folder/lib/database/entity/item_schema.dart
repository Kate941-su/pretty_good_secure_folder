import 'package:isar_community/isar.dart';
import 'package:openpgp/openpgp.dart';

import '../../model/vault_item.dart';

part 'item_schema.g.dart';

@collection
class Item {
  Id? id;
  String? key;
  String? value;


  Future<VaultItem> toItemWithDecryption(String privateKey) async {
    // TODO: Passphrase feature
    final decryptedValue = await OpenPGP.decrypt(value!, privateKey, "");
    return VaultItem(id: id!,
        key: key!,
        value: decryptedValue);
  }
}