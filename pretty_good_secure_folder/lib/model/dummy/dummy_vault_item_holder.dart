import 'package:pretty_good_secure_folder/model/vault_item.dart';

final dummyVaultItemHolder = List.generate(
  10,
  (index) => VaultItem(
    id: 'id_$index',
    key: 'key_$index',
    value: 'value_$index',
  ),
);
