import 'package:pretty_good_secure_folder/model/vault_item_holder.dart';
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
    final previousState = state;
    final vaultRepository = ref.read(vaultRepositoryProvider.notifier);
    vaultRepository.addVaultItemHolder(itemHolder);
    state = [...previousState, itemHolder];
  }

  void removeVaultItemHolder({required int id}) {
    final vaultRepository = ref.read(vaultRepositoryProvider.notifier);
    final previousState = state;
    final removedHolder = previousState.firstWhere((element) => element.id == id);
    state = previousState.where((element) => element.id != id).toList();
    vaultRepository.deleteVaultItemHolder(removedHolder);
  }

  void editHolder({required VaultItemHolder holder}) {
    final vaultRepository = ref.read(vaultRepositoryProvider.notifier);
    final previousState = state;
    final newList = previousState.map((item) {
      if (item.id == holder.id) {
        return holder;
      }
      return item;
    }).toList();
    vaultRepository.editVaultItemHolder(holder);
    state = newList;
  }
}
