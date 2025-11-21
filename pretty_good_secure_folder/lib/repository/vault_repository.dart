import 'package:pretty_good_secure_folder/model/vault_item.dart';
import 'package:pretty_good_secure_folder/model/vault_item_holder.dart';
import 'package:pretty_good_secure_folder/service/db_handler.dart';
import 'package:pretty_good_secure_folder/util/Util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vault_repository.g.dart';

// Provider for storing measurements
@riverpod
class VaultRepository extends _$VaultRepository {
  @override
  void build() {
    return;
  }

  // ADD
  Future<void> addVaultItemHolder(VaultItemHolder holder) async {
    final dbNotifier = ref.watch(dbHandlerProvider.notifier);
    Future.wait([
      ...holder.itemList.map((it) async {
        await dbNotifier.writeItem(it.toItemSchema());
      }),
      dbNotifier.writeHolder(holder.toHolderSchema()),
    ]);
  }

  // UPDATE
  Future<void> editVaultItemHolder(VaultItemHolder holder) async {
    final dbNotifier = ref.watch(dbHandlerProvider.notifier);
    Future.wait([
      dbNotifier.editHolder(holder.toHolderSchema()),
      dbNotifier.editItems(
        holder.itemList.map((it) => it.toItemSchema()).toList(),
      ),
    ]);
  }

  // DELETE
  Future<void> deleteVaultItemHolder(VaultItemHolder holder) async {
    final dbNotifier = ref.watch(dbHandlerProvider.notifier);
    Future.wait([
      dbNotifier.deleteHolder(holder.toHolderSchema()),
      dbNotifier.deleteItems(
        holder.itemList.map((it) => it.toItemSchema()).toList(),
      ),
    ]);
  }

  // READ
  Future<List<VaultItemHolder>> readVaultItemHolders() async {
    final dbNotifier = ref.read(dbHandlerProvider.notifier);
    final holdersSchema = await dbNotifier.readAllHolder();
    final vaultItemHolders = await Future.wait(
      holdersSchema
          .map((it) async {
            if (it.itemIdList == null) {
              return VaultItemHolder(
                id: it.id!,
                updatedAt: Util.formatter.parse(it.updateAtString!),
                name: it.name!,
                itemList: [],
              );
            } else {
              final itemIdList = it.itemIdList!;
              final items = await Future.wait(
                itemIdList.map((id) async {
                  final itemSchema = await dbNotifier.readItem(id);
                  if (itemSchema == null) {
                    return null;
                  } else {
                    return VaultItem(
                      id: itemSchema.id!,
                      key: itemSchema.key!,
                      value: itemSchema.value!,
                    );
                  }
                }),
              );
              return VaultItemHolder(
                id: it.id!,
                updatedAt: Util.formatter.parse(it.updateAtString!),
                name: it.name!,
                itemList: items.whereType<VaultItem>().toList(),
              );
            }
          })
          .toList(growable: false),
    );
    return vaultItemHolders;
  }
}
