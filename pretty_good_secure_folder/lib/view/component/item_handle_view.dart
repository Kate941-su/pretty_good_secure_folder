import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/extension/colors+_custom_color.dart';
import 'package:pretty_good_secure_folder/provider/regacy/create_vault_holder.dart';
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
    super.key,
  });

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

    final keyEditingController = TextEditingController();
    final valueEditingController = TextEditingController();

    useEffect(
          () {
        return null;
      },
      [
        keyController.dispose,
        valueController.dispose,
        keyEditingController.dispose,
        valueEditingController.dispose,
      ],
    );

    final vaultItemList = useState<List<VaultItem>>(defaultItemList);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
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
                  DataColumn(label: Expanded(child: Text(""))),
                ],
                rows: vaultItemList.value
                    .map(
                      (it) =>
                      DataRow(
                        cells: [
                          DataCell(Text(it.key)),
                          DataCell(Text(it.value)),
                          DataCell(
                            Row(
                              spacing: 0,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _editDialogBuilder(
                                        context,
                                        keyEditingController,
                                        valueEditingController,
                                        it.key,
                                        it.value,
                                        vaultItemList.value
                                            .where((e) => e.id != it.id)
                                            .map((e) => e.key,)
                                            .toList(),
                                            (key, value) {
                                          final item = VaultItem(id: it.id,
                                              key: key,
                                              value: value);
                                          var newVaultItemList = vaultItemList
                                              .value.map((it) {
                                            if (it.id == item.id) {
                                              return item;
                                            }
                                            return it;
                                          }).toList(growable: false);
                                          vaultItemList.value = newVaultItemList;
                                        }
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await Clipboard.setData(
                                      ClipboardData(text: it.value),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.copy,
                                    color: CustomColors.copy,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    vaultItemList.value = vaultItemList.value
                                        .where((element) => element.id != it.id)
                                        .toList();
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: CustomColors.warning,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                )
                    .toList(growable: false),
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
                  } else if (vaultItemList.value.any(
                        (it) => it.key == keyController.text,
                  )) {
                    keyStringError.value = AppError.keyDupulicateError();
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
                  final id = UuidV4()
                      .generate()
                      .hashCode;
                  vaultItemList.value = [
                    ...vaultItemList.value,
                    VaultItem(
                      key: keyController.text,
                      value: valueController.text,
                      id: id,
                    ),
                  ];
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
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: vaultItemList.value.isEmpty
                            ? CustomColors.disable
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editDialogBuilder(BuildContext context,
      TextEditingController keyEditController,
      TextEditingController valueEditController,
      String key,
      String value,
      List<String> forbiddenKeyList,
      Function(String, String) onEdit,) {

    final keyErrorNotifierProvider = NotifierProvider.family<TextNotifier, String?, String?>(
        (text) => TextNotifier(text),
    );

    final valueErrorNotifierProvider = NotifierProvider.family<TextNotifier, String?, String?>(
          (text) => TextNotifier(text),
    );

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {

            // TODO: implement key error value with Riverpod
            final keyErrorValue = ref.watch(keyErrorNotifierProvider(null));
            final valueErrorValue = ref.watch(valueErrorNotifierProvider(null));
            return AlertDialog(
              title: const Text('Edit Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: keyEditController,
                    onChanged: (value) {

                    },
                    decoration: InputDecoration(
                      labelText: 'Enter the key',
                      errorText: ke.value,
                    ),
                  ),
                  TextField(
                    controller: valueEditController,
                    decoration: InputDecoration(
                      labelText: 'Enter the Value',
                      errorText: errorValueString.value,
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme
                        .of(context)
                        .textTheme
                        .labelLarge,
                  ),
                  child: Text(
                    'cancel',
                    style: TextStyle(color: CustomColors.warning),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme
                        .of(context)
                        .textTheme
                        .labelLarge,
                  ),
                  child: Text(
                    'create',
                    style: TextStyle(color: CustomColors.info),
                  ),
                  onPressed: () {
                    if (keyEditController.text.isEmpty) {
                      errorKeyString.value = 'Key must be unique and not empty';
                    } else if (keyEditController.text.contains(" ")) {
                      errorKeyString.value = 'Key must be unique and not empty';
                    } else
                    if (forbiddenKeyList.contains(keyEditController.text)) {
                      errorKeyString.value = 'Key must be unique and not empty';
                    }
                    if (valueEditController.text.isEmpty) {
                      errorValueString.value = 'Value must not be empty';
                    }
                    if (errorKeyString.value != null ||
                        errorValueString.value != null) {
                      onEdit(keyEditController.text, valueEditController.text);
                      Navigator.of(context).pop();
                      return;
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
