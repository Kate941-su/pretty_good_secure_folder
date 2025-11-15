import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/vault_item.dart';

part 'vault_item_state.g.dart';

// Provider for storing measurements
@riverpod
class VaultItemState extends _$VaultItemState {
  @override
  List<VaultItem> build() {
    return [];
  }
  void addVaultItem({required vaultItem}) {
    state = [...state, vaultItem];
  }

  void removeVaultItem({required id}) {
    state = state.where((element) => element.id != id).toList();
  }

}