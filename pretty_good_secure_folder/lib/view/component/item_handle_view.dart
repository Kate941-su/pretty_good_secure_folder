import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/extension/colors+_custom_color.dart';
import 'package:pretty_good_secure_folder/model/vault_item_holder.dart';
import 'package:pretty_good_secure_folder/view/component/text_enter_field.dart';
import 'package:uuid/v4.dart';

import '../../model/error/app_error.dart';
import '../../model/vault_item.dart';
import '../../provider/vault_item_state.dart';

class ItemHandleView extends HookConsumerWidget {
  const ItemHandleView({
    required this.defaultItemList,
    required this.name,
    required this.onSave,
    super.key});

  final Function(List<VaultItem>) onSave;
  final String name;
  final List<VaultItem> defaultItemList;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyController = TextEditingController();
    final valueController = TextEditingController();
    final notifier = ref.read(vaultItemHolderStateProvider.notifier);
    final keyStringError = useState<AppError?>(null);
    final valueStringError = useState<AppError?>(null);

    useEffect(() {
      return null;
    }, [keyController.dispose, valueController.dispose]);

    final vaultItemList = useState<List<VaultItem>>(defaultItemList);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(name),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DataTable(
                columns: <DataColumn>[
                  const DataColumn(
                    label: Expanded(
                      child: Text(
                        'key',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  const DataColumn(
                    label: Expanded(
                      child: Text(
                        'value',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(""),
                    ),
                  ),
                ],
                rows: vaultItemList.value.map((it) => DataRow(cells: [
                  DataCell(Text(it.key)),
                  DataCell(Text(it.value)),
                  DataCell(Row(children: [
                    IconButton(onPressed: (){}, icon: const Icon(Icons.edit)),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.copy)),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.delete))
                  ],)),
                ])).toList(growable: false),
              ),
              TextEnterField(
                title: "key",
                controller: keyController,
                error: keyStringError.value,
              ),
              TextEnterField(
                title: "value",
                controller: valueController,
                error: valueStringError.value,
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.blue,
                  ),
                ),
                onPressed: () {
                  if (keyController.text.isEmpty) {
                    keyStringError.value = AppError.emptyString();
                  } else if (keyController.text.contains(" ")) {
                    keyStringError.value = AppError.keyStringError();
                  } else {
                    keyStringError.value = null;
                  }

                  if (valueController.text.isEmpty) {
                    valueStringError.value = AppError.emptyString();
                  } else {
                    valueStringError.value = null;
                  }

                  if (keyStringError.value != null ||
                      valueStringError.value != null) {
                    return;
                  }

                  final id = UuidV4().generate();
                  vaultItemList.value = [...vaultItemList.value, VaultItem(
                    key: keyController.text,
                    value: valueController.text,
                    id: UuidV4().generate(),
                  )];
                  notifier.addVaultItem(
                    holderId: id,
                    item: VaultItem(
                      key: keyController.text,
                      value: valueController.text,
                      id: UuidV4().generate(),
                    ),
                  );
                },
                child: Text('Add'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text('Cancel', style: TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue,
                      ),
                    ),
                    onPressed: () {
                      onSave(vaultItemList.value);
                    },
                    child: Text('Save', style: TextStyle(
                        color: vaultItemList.value.isEmpty ?
                        CustomColors.disable : null),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}