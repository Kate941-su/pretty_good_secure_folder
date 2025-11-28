import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../database/entity/holder_schema.dart';
import '../database/entity/item_schema.dart';
import 'isar_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p; // <-- Import with the 'p' alias


part 'db_handler.g.dart';

// Provider for storing measurements
@Riverpod(keepAlive: true)
class DbHandler extends _$DbHandler {

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

  Future<void> exportFile() async {
    final isar = ref.watch(isarProvider);
    final directory = await getApplicationDocumentsDirectory();
    final backup = "backup.db";
    final directoryPath = directory.path;
    final completePath = p.join(directoryPath, backup);
    try {
      final file = File(completePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
        debugPrint(e.toString());
    }
    isar.copyToFile(completePath);
  }

}