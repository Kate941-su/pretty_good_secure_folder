import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pretty_good_secure_folder/model/vault_item.dart';

part 'vault_item_holder.freezed.dart';

@freezed
abstract class VaultItemHolder with _$VaultItemHolder {
  const factory VaultItemHolder({
    required String id,
    required List<VaultItem> itemList,
  }) = _VaultItemHolder;
}