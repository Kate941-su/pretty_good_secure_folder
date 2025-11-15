import 'package:freezed_annotation/freezed_annotation.dart';

part 'vault_item.freezed.dart';

@freezed
abstract class VaultItem with _$VaultItem {
  const factory VaultItem({
    required String id,
    required String key,
    required String value,
  }) = _VaultItem;
}