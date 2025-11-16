
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/v4.dart';

import '../model/error/app_error.dart';
import '../model/vault_item.dart';
import '../provider/vault_item_state.dart';
import 'component/text_enter_field.dart';

class CreateItemView extends HookConsumerWidget {
  const CreateItemView({required this.id, super.key});

  final String id;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyController = TextEditingController();
    final valueController = TextEditingController();
    final vaultItemHolder = ref.watch(vaultItemHolderStateProvider.select(
            (it) => it.firstWhere((elem) {
             return  elem.id == id;
    })));
    final notifier = ref.read(vaultItemHolderStateProvider.notifier);

    final keyStringError = useState<AppError?>(null);
    final valueStringError = useState<AppError?>(null);

    useEffect(() {
      return null;
    }, [keyController.dispose, valueController.dispose]);

    final dataRowList = vaultItemHolder.itemList.map((item) => DataRow(cells: [
      DataCell(Text(item.id)),
      DataCell(Text(item.key)),
      DataCell(Text(item.value)),
    ]) ).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Create Vault Item"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Title", style: TextStyle(fontSize: 28),),
              DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'id',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'key',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'value',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
                rows: dataRowList,
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

                  notifier.addVaultItem(
                    holderId: vaultItemHolder.id,
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
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue,
                      ),
                    ),
                    onPressed: () {},
                    child: Text('Cancel', style: TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue,
                      ),
                    ),
                    onPressed: () {},
                    child: Text('Save'),
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