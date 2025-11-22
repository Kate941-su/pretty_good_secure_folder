import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/model/vault_item.dart';
import 'package:pretty_good_secure_folder/model/vault_item_holder.dart';
import 'package:pretty_good_secure_folder/provider/user_state.dart';
import 'package:pretty_good_secure_folder/service/db_handler.dart';
import 'package:pretty_good_secure_folder/util/Util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../database/entity/item_schema.dart';

part 'vault_repository.g.dart';

// Provider for storing measurements
@Riverpod(keepAlive: true)
class VaultRepository extends _$VaultRepository {
  @override
  void build() {
    return;
  }

  // ADD
  Future<void> addVaultItemHolder(VaultItemHolder holder) async {
    final dbNotifier = ref.read(dbHandlerProvider.notifier);
    Future.wait([
      ...holder.itemList.map((it) async {
        final publicKey = ref.read(userStateProvider.select((it) => it.publicKey),);
        final item = await it.toItemSchemaWithEncryption(publicKey);
        await dbNotifier.writeItem(item);
      }),
      dbNotifier.writeHolder(holder.toHolderSchema()),
    ]);
  }

  // UPDATE
  Future<void> editVaultItemHolder(VaultItemHolder holder) async {
    final dbNotifier = ref.read(dbHandlerProvider.notifier);
    final publicKey = ref.read(userStateProvider.select((it) => it.publicKey));
    List<Item> list = [];
    for (final item in holder.itemList) {
      final itemSchema = await item.toItemSchemaWithEncryption(publicKey);
      list.add(itemSchema);
    }
    Future.wait([
      dbNotifier.editHolder(holder.toHolderSchema()),
      dbNotifier.editItems(list),
    ]);
  }

  // DELETE
  Future<void> deleteVaultItemHolder(VaultItemHolder holder) async {
    final dbNotifier = ref.read(dbHandlerProvider.notifier);
    final publicKey = ref.read(userStateProvider.select((it) => it.publicKey));
    List<Item> list = [];
    for (final item in holder.itemList) {
      final itemSchema = await item.toItemSchemaWithEncryption(publicKey);
      list.add(itemSchema);
    }
    Future.wait([
      dbNotifier.deleteHolder(holder.toHolderSchema()),
      dbNotifier.deleteItems(list),
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
                isFavorite: it.isFavorite!,
              );
            } else {
              final itemIdList = it.itemIdList!;
              final items = await Future.wait(
                itemIdList.map((id) async {
                  final itemSchema = await dbNotifier.readItem(id);
                  if (itemSchema == null) {
                    return null;
                  } else {
                    final privateKey = ref.read(userStateProvider.select((it) => it.privateKey),);
                    final item = await itemSchema.toItemWithDecryption(
                      privateKey,
                    );
                    return item;
                  }
                }),
              );
              return VaultItemHolder(
                id: it.id!,
                updatedAt: Util.formatter.parse(it.updateAtString!),
                name: it.name!,
                itemList: items.whereType<VaultItem>().toList(),
                isFavorite: it.isFavorite!,
              );
            }
          })
          .toList(growable: false),
    );
    return vaultItemHolders;
  }
}
