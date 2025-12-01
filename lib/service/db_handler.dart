import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:isar_community/isar.dart';
import 'package:pretty_good_secure_folder/provider/vault_item_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import '../database/entity/holder_schema.dart';
import '../database/entity/item_schema.dart';
import 'isar_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'db_handler.g.dart';

// Provider for storing measurements
@Riverpod(keepAlive: true)
class DbHandler extends _$DbHandler {
  final _fileName = "backup.isar";

  @override
  Future<void> build() async {
    return;
  }

  // WRITE
  Future<void> writeItem(Item item) async {
    final isar = ref.watch(isarProvider);
    await isar.writeTxn(() async {
      await isar.items.put(item); // insert & update
    });
  }

  Future<void> writeHolder(Holder holder) async {
    final isar = ref.watch(isarProvider);
    await isar.writeTxn(() async {
      await isar.holders.put(holder); // insert & update
    });
  }

  // READ
  Future<List<Holder>> readAllHolder() async {
    final isar = ref.watch(isarProvider);
    return await isar.holders.where().findAll();
  }

  Future<List<Item>> readAllItem() async {
    final isar = ref.watch(isarProvider);
    return await isar.items.where().findAll();
  }

  Future<Item?> readItem(int id) async {
    final isar = ref.watch(isarProvider);
    return await isar.items.get(id);
  }

  // EDIT
  Future<void> editHolder(Holder holder) async {
    final isar = ref.watch(isarProvider);

    await isar.writeTxn(() async {
      await isar.holders.put(holder);
    });
  }

  Future<void> editItems(List<Item> items) async {
    final isar = ref.watch(isarProvider);

    await isar.writeTxn(() async {
      await isar.items.putAll(items);
    });
  }

  // DELETE
  Future<void> deleteHolder(Holder holder) async {
    final isar = ref.watch(isarProvider);

    await isar.writeTxn(() async {
      await isar.holders.delete(holder.id!);
    });
  }

  Future<void> deleteItems(List<Item> items) async {
    final isar = ref.watch(isarProvider);
    await isar.writeTxn(() async {
      await isar.items.deleteAll(items.map((e) => e.id!).toList());
    });
  }

  Future<String> exportFile() async {
    final isar = ref.watch(isarProvider);
    final directory = await getApplicationCacheDirectory();
    final directoryPath = directory.path;
    final completePath = p.join(directoryPath, _fileName);
    try {
      final file = File(completePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    isar.copyToFile(completePath);
    return completePath;
  }

  Future<void> importFile(String filePath)  async  {
    // 1. Get All Items from
    final file = File(filePath);
    if (!file.existsSync()) {
      return;
    }
    final documentDir = await getApplicationDocumentsDirectory();
    final dirPath = documentDir.absolute.path;
    final completePath = p.join(dirPath, _fileName);
    final copiedFile = await file.copy(completePath);
    final dbName = p.basenameWithoutExtension(completePath);
    final tempIsar = await Isar.open(
      [ItemSchema, HolderSchema],
      directory: dirPath,
      name: dbName,
    );
    final backupItems = await tempIsar.items.where().findAll();
    final backupHolders = await tempIsar.holders.where().findAll();

    // 2. compare to the existing folders
    final currentItems = await readAllItem();
    final currentHolders = await readAllHolder();

    var isNeedUpdate = false;

    // 3. backup items and holders if it is not duplicated
    for (var backupHolder in backupHolders) {
      if (!currentHolders.map((it) => it.id).contains(backupHolder.id)) {
        await writeHolder(backupHolder);
        isNeedUpdate = true;
      }
    }

    for (var backupItem in backupItems) {
      if (!currentItems.map((it) => it.id).contains(backupItem.id)) {
        await writeItem(backupItem);
        isNeedUpdate = true;
      }
    }

    if (isNeedUpdate) {
      await ref.read(vaultItemHolderStateProvider.notifier).initialize();
    }

    tempIsar.close(deleteFromDisk: true);
  }
}
