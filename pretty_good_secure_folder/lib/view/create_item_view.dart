import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/model/toast.dart';
import 'package:pretty_good_secure_folder/model/vault_item_holder.dart';
import 'package:pretty_good_secure_folder/provider/toast_trigger_provider.dart';
import 'package:pretty_good_secure_folder/view/component/item_handle_view.dart';
import 'package:uuid/v4.dart';
import '../provider/vault_item_state.dart';

class CreateItemView extends HookConsumerWidget {
  const CreateItemView({required this.name, super.key});

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyController = TextEditingController();
    final valueController = TextEditingController();
    final notifier = ref.read(vaultItemHolderStateProvider.notifier);
    useEffect(() {
      return null;
    }, [keyController.dispose, valueController.dispose]);
    return ItemHandleView(
      name: name,
      defaultItemList: [],
      onSave: (itemList) {
        if (itemList.isNotEmpty) {
          final id = UuidV4().generate();
          notifier.addVaultItemHolder(
            itemHolder: VaultItemHolder(
              id: id,
              updatedAt: DateTime.now(),
              name: name,
              itemList: itemList,
            ),
          );
          ref.read(toastTriggerProvider.notifier).setToast(CreateVaultHolder());
          context.pop();
        }
      },
    );
  }
}
