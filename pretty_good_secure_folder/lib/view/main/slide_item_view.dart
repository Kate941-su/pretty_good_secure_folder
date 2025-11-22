import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:pretty_good_secure_folder/extension/colors+_custom_color.dart';
import 'package:pretty_good_secure_folder/model/toast.dart';
import 'package:pretty_good_secure_folder/provider/regacy/create_vault_holder.dart';
import 'package:pretty_good_secure_folder/provider/toast_trigger_provider.dart';
import 'package:pretty_good_secure_folder/provider/user_state.dart';
import 'package:pretty_good_secure_folder/provider/vault_item_state.dart';
import 'package:pretty_good_secure_folder/view/component/slidable_item_widget.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/v4.dart';

class SlideItemView extends HookConsumerWidget {
  const SlideItemView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vaultItemHolderList = ref.watch(vaultItemHolderStateProvider);
    final notifier = ref.read(vaultItemHolderStateProvider.notifier);
    final listener = ref.listen(toastTriggerProvider, (prev, next) {
      if (next == null) return;
      toastification.show(
        title: Text(getMessage(next)),
        autoCloseDuration: const Duration(seconds: 5),
        callbacks: ToastificationCallbacks(
          onDismissed: (_) {
            ref.read(toastTriggerProvider.notifier).setToast(null);
          },
        ),
      );
      ref.read(toastTriggerProvider.notifier).setToast(null);
    });

    return Scaffold(
      body: ListView(
        children: [
          for (var vaultItemHolder in vaultItemHolderList)
            SlidableItemWidget(
              vaultItemHolder: vaultItemHolder,
              isFavorite: vaultItemHolder.isFavorite,
              onTapFavorite: (nextState) {
                notifier.editHolder(
                  holder: vaultItemHolder.copyWith(isFavorite: nextState),
                );
              },
              onTapCopy: (holder) {
                _createHolderDialogBuilder(
                  context,
                  "Copy A Vault from \"${vaultItemHolder.name}\"",
                  (name) {
                    final id = UuidV4().generate().hashCode;
                    notifier.addVaultItemHolder(
                      itemHolder: holder.copyWith(name: name, id: id),
                    );
                  },
                );
              },
              onTapItem: (holder) {
                Logger().i(holder);
                context.push('/edit/${vaultItemHolder.id}');
              },
              onTapDelete: (holder) {
                _deleteConfirmationDialogBuilder(
                  context,
                  vaultItemHolder.name,
                  () {
                    notifier.removeVaultItemHolder(id: vaultItemHolder.id);
                  },
                );
              },
            ),
          TextButton(
            onPressed: () {
              _createHolderDialogBuilder(context, "Create New Vault", (name) {
                context.push('/create/$name');
              });
            },
            child: Text("Create New Vault"),
          ),
          if (kDebugMode)
            Column(
              children: [
                TextButton(
                  onPressed: () {
                    ref.watch(userStateProvider);
                    Logger().i(
                      ref.watch(
                        userStateProvider.select((it) => it.privateKey),
                      ),
                    );
                  },
                  child: Text("Show private key"),
                ),
                TextButton(
                  onPressed: () {
                    ref.watch(userStateProvider);
                    Logger().i(
                      ref.watch(userStateProvider.select((it) => it.publicKey)),
                    );
                  },
                  child: Text("Show public key"),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _deleteConfirmationDialogBuilder(
    BuildContext context,
    String holderName,
    VoidCallback onDelete,
  ) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return AlertDialog(
              title: Text('Are you sure that you want to delete $holderName'),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
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
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text(
                    'delete',
                    style: TextStyle(color: CustomColors.info),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onDelete();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _createHolderDialogBuilder(
    BuildContext context,
    String title,
    Function(String) onCreate,
  ) {
    final controller = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final enterVaultName = ref.watch(enterVaultNameNotifierProvider);
            final notifier = ref.read(enterVaultNameNotifierProvider.notifier);
            return AlertDialog(
              title: Text(title),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Enter the Value',
                  errorText: enterVaultName != null
                      ? 'Value cannot be empty'
                      : null,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text(
                    'cancel',
                    style: TextStyle(color: CustomColors.warning),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    notifier.setValue(null);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text(
                    'create',
                    style: TextStyle(color: CustomColors.info),
                  ),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      Navigator.of(context).pop();
                      notifier.setValue(null);
                      onCreate(controller.text);
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
