import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pretty_good_secure_folder/model/vault_item.dart';

import '../database/entity/holder_schema.dart';

part 'vault_item_holder.freezed.dart';

@freezed
abstract class VaultItemHolder with _$VaultItemHolder {
  const VaultItemHolder._();

  const factory VaultItemHolder({
    required int id,
    required DateTime updatedAt,
    required String name,
    @Default(false) bool isFavorite,
    required List<VaultItem> itemList,
  }) = _VaultItemHolder;

  Holder toHolderSchema() {
    Holder h = Holder();
    h.id = id;
    h.updateAtString = updatedAt.toIso8601String().split('T')[0];
    h.name = name;
    h.itemIdList = itemList.map((e) => e.id).toList();
    return h;
  }
}