import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/model/error/app_error.dart';
import 'package:pretty_good_secure_folder/provider/vault_item_state.dart';
import 'package:pretty_good_secure_folder/view/component/text_enter_field.dart';
import 'package:uuid/v4.dart';

import 'model/vault_item.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyController = TextEditingController();
    final valueController = TextEditingController();
    final vaultItemList = ref.watch(vaultItemStateProvider);
    final vaultItemNotifier = ref.read(vaultItemStateProvider.notifier);

    final keyStringError = useState<AppError?>(null);
    final valueyStringError = useState<AppError?>(null);

    useEffect(() {
      return null;
    }, [keyController.dispose, valueController.dispose]);

    final dataRowList = vaultItemList.map((item) => DataRow(cells: [
      DataCell(Text(item.id)),
      DataCell(Text(item.key)),
      DataCell(Text(item.value)),
    ]) ).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Title"),
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
                error: valueyStringError.value,
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
                    valueyStringError.value = AppError.emptyString();
                  } else {
                    valueyStringError.value = null;
                  }

                  if (keyStringError.value != null ||
                      valueyStringError.value != null) {
                    return;
                  }

                  vaultItemNotifier.addVaultItem(
                    vaultItem: VaultItem(
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
