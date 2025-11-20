import 'package:pretty_good_secure_folder/model/vault_item_holder.dart';
import 'package:pretty_good_secure_folder/provider/db_handler.dart';
import 'package:pretty_good_secure_folder/repository/vault_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vault_item_state.g.dart';

@Riverpod(keepAlive: true)
class VaultItemHolderState extends _$VaultItemHolderState {
  @override
  List<VaultItemHolder> build() {
    return [];
  }

  Future<void> initialize() async {
    final vaultRepository = ref.read(vaultRepositoryProvider.notifier);
    final holders = await vaultRepository.readVaultItemHolders();
    state = holders;
  }

  void addVaultItemHolder({required VaultItemHolder itemHolder}) {
    final previousState = state; // Get current list
    if (previousState != null) {
      // Wrap the new list in AsyncData
      state = [...previousState, itemHolder];
    }
  }

  void removeVaultItemHolder({required int id}) {
    final previousState = state;
    if (previousState != null) {
      state = previousState.where((element) => element.id != id).toList();
    }
  }

  void addVaultItem({required int holderId, required dynamic item}) {
    final previousState = state;
    final newList = previousState.map((element) {
      if (element.id == holderId) {
        return element.copyWith(itemList: [...element.itemList, item]);
      }
      return element;
    }).toList();
      state = newList;
  }

  void removeItem({required int holderId, required String itemId}) {
    final previousState = state;
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
      state = newList;
  }

  void editHolder({required VaultItemHolder holder}) {
    final previousState = state;
    final newList = previousState.map((item) {
      if (item.id == holder.id) {
        return holder;
      }
      return item;
    }).toList();
      state = newList;
  }
}
