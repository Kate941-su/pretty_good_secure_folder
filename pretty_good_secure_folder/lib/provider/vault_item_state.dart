import 'package:pretty_good_secure_folder/model/dummy/dummy_vault_item_holder.dart';
import 'package:pretty_good_secure_folder/model/vault_item_holder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/vault_item.dart';
import 'package:uuid/v4.dart';

import '../model/vault_item_holder.dart';

part 'vault_item_state.g.dart';


// Provider for storing measurements
@riverpod
class VaultItemHolderState extends _$VaultItemHolderState {
  @override
  List<VaultItemHolder> build() {
    return dummyVaultItemHolders;
  }
  void addVaultItemHolder({required itemHolder}) {
    state = [...state, itemHolder];
  }

  void removeVaultItemHolder({required id}) {
    state = state
        .where((element) => element.id != id)
        .toList();
  }

  void addVaultItem({required holderId, required item}) {
    state = state.map((element) {
      if (element.id == holderId) {
        return element.copyWith(itemList: [...element.itemList, item]);
      }
      return element;
    }).toList();
  }

  void removeItem({required holderId, required itemId}) {
    state = state.map((element) {
      if (element.id == holderId) {
        return element.copyWith(
            itemList: element.itemList
                .where((element) => element.id != itemId)
                .toList());
      } else {
      return element;
      }
    }).toList();
  }


}