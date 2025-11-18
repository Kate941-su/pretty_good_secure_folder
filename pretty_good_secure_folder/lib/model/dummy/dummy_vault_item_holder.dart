import 'package:pretty_good_secure_folder/model/vault_item.dart';
import 'package:pretty_good_secure_folder/model/vault_item_holder.dart';

final dummyVaultItemHolders = List.generate(
  10,
  (i) => VaultItemHolder(
    id: 'holder_id_$i',
    name: 'holder_name_$i',
    itemList: List.generate(
      3,
      (j) => VaultItem(
        id: 'item_id_${i}_$j',
        key: 'key_${i}_$j',
        value: 'value_${i}_$j',
      ),
    ), updatedAt: DateTime.now(),
  ),
);
