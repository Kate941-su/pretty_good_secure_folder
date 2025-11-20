import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/model/toast.dart';
import 'package:pretty_good_secure_folder/model/vault_item_holder.dart';
import 'package:pretty_good_secure_folder/provider/toast_trigger_provider.dart';
import 'package:pretty_good_secure_folder/view/component/item_handle_view.dart';
import '../../provider/vault_item_state.dart';

class EditItemView extends HookConsumerWidget {
  const EditItemView({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyController = TextEditingController();
    final valueController = TextEditingController();
    final holder = ref.watch(vaultItemHolderStateProvider.select(
            (it) => it.firstWhere((it) => it.id == id)));
    final notifier = ref.read(vaultItemHolderStateProvider.notifier);
    useEffect(() {
      return null;
    }, [keyController.dispose, valueController.dispose]);

    return ItemHandleView(
      name: holder.name,
      defaultItemList: holder.itemList,
      onSave: (itemList) {
        if (itemList.isNotEmpty) {
          notifier.editHolder(
            holder: VaultItemHolder(
              id: id,
              updatedAt: DateTime.now(),
              name: holder.name,
              itemList: itemList,
            ),
          );
          ref.read(toastTriggerProvider.notifier).setToast(EditVaultHolder());
          context.pop();
        }
      },
    );
  }
}