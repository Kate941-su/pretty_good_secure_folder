import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/extension/colors+_custom_color.dart';
import 'package:pretty_good_secure_folder/provider/regacy/create_vault_holder.dart';
import 'package:pretty_good_secure_folder/provider/vault_item_state.dart';
import 'package:pretty_good_secure_folder/view/component/slidable_item_widget.dart';

class SlideItemView extends HookConsumerWidget {
  const SlideItemView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vaultItemHolderList = ref.watch(vaultItemHolderStateProvider);
    final notifier = ref.read(vaultItemHolderStateProvider.notifier);
    return Scaffold(
      body: ListView(
        children: [
          for (var vaultItemHolder in vaultItemHolderList)
            SlidableItemWidget(
              vaultItemHolder: vaultItemHolder,
              onTapItem: (item) {
                context.push('/edit/${vaultItemHolder.id}');
              },
              onTapDelete: (item) {
                notifier.removeVaultItemHolder(id: vaultItemHolder.id);
              },
            ),
          TextButton(
            onPressed: () {
              _dialogBuilder(context,);
              // context.push('/create');
            },
            child: Text("Create New Vault"),
          ),
        ],
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final enterVaultName = ref.watch(enterVaultNameNotifierProvider);
            final notifier = ref.read(enterVaultNameNotifierProvider.notifier);
            return AlertDialog(
              title: const Text('Enter Vault Name'),
              content: TextField(controller: controller ,
                decoration: InputDecoration(
                  labelText: 'Enter the Value',
                  errorText: enterVaultName != null ? 'Value cannot be empty' : null,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text('cancel', style: TextStyle(color: CustomColors.warning),),
                  onPressed: () {
                    Navigator.of(context).pop();
                    notifier.setValue(null);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text('create', style: TextStyle(color: CustomColors.info),),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      Navigator.of(context).pop();
                      context.push('/create/${controller.text}');
                      notifier.setValue(null);
                    } else {
                      notifier.setValue("Value cannot be empty");
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
