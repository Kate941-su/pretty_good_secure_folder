import 'package:pretty_good_secure_folder/model/vault_item_holder.dart';
import 'package:pretty_good_secure_folder/provider/db_handler.dart';
import 'package:pretty_good_secure_folder/repository/vault_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vault_item_state.g.dart';

@riverpod
class VaultItemHolderState extends _$VaultItemHolderState {
  @override
  Future<List<VaultItemHolder>> build() async {
    final vaultRepository = ref.read(vaultRepositoryProvider.notifier);
    final holders = await vaultRepository.readVaultItemHolders();
    return holders;
  }

  void addVaultItemHolder({required VaultItemHolder itemHolder}) {
    final previousState = state.value; // Get current list
    if (previousState != null) {
      // Wrap the new list in AsyncData
      state = AsyncData([...previousState, itemHolder]);
    }
  }

  void removeVaultItemHolder({required String id}) {
    final previousState = state.value;
    if (previousState != null) {
      state = AsyncData(
        previousState.where((element) => element.id != id).toList(),
      );
    }
  }

  void addVaultItem({required String holderId, required dynamic item}) {
    final previousState = state.value;
    if (previousState != null) {
      final newList = previousState.map((element) {
        if (element.id == holderId) {
          return element.copyWith(itemList: [...element.itemList, item]);
        }
        return element;
      }).toList();

      state = AsyncData(newList);
    }
  }

  void removeItem({required String holderId, required String itemId}) {
    final previousState = state.value;
    if (previousState != null) {
      final newList = previousState.map((element) {
        if (element.id == holderId) {
          return element.copyWith(
            itemList: element.itemList
                .where((element) => element.id != itemId)
                .toList(),
          );
        }
        return element;
      }).toList();

      state = AsyncData(newList);
    }
  }

  void editHolder({required VaultItemHolder holder}) {
    final previousState = state.value;
    if (previousState != null) {
      final newList = previousState.map((item) {
        if (item.id == holder.id) {
          return holder;
        }
        return item;
      }).toList();

      state = AsyncData(newList);
    }
  }
}
