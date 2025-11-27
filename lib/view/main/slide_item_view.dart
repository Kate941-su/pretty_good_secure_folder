import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:pretty_good_secure_folder/extension/colors+_custom_color.dart';
import 'package:pretty_good_secure_folder/model/toast.dart';
import 'package:pretty_good_secure_folder/model/union/sort_type.dart';
import 'package:pretty_good_secure_folder/model/vault_item_holder.dart';
import 'package:pretty_good_secure_folder/provider/regacy/create_vault_holder.dart';
import 'package:pretty_good_secure_folder/provider/toast_trigger_provider.dart';
import 'package:pretty_good_secure_folder/provider/vault_item_state.dart';
import 'package:pretty_good_secure_folder/view/component/item_separater.dart';
import 'package:pretty_good_secure_folder/view/component/slidable_item_widget.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/v4.dart';

class SlideItemView extends HookConsumerWidget {
  const SlideItemView({
    required this.isFilterFavorite,
    required this.filterText,
    required this.sortType,
    super.key,
  });

  final bool isFilterFavorite;
  final SortType sortType;
  final String filterText;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterTextController = TextEditingController();
    final vaultItemHolderList = ref.watch(
      vaultItemHolderStateProvider.select(
        (it) => it.where((elem) {
          return !isFilterFavorite || elem.isFavorite;
        }).toList(growable: false),
      ),
    );
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

    final filteredVaultItemHolder =  vaultItemHolderList

    final sortedVaultItemHolder = sortByType(sortType, vaultItemHolderList);

    return Scaffold(
      body: Column(
        children: [
          Separator(),
          Expanded(
            child: ListView(
              children: [
                for (var vaultItemHolder in sortedVaultItemHolder)
                  Column(
                    spacing: 0,
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                      Separator(),
                    ],
                  ),
                TextButton(
                  onPressed: () {
                    _createHolderDialogBuilder(context, "Create New Vault", (name) {
                      context.push('/create/$name');
                    });
                  },
                  child: Text("Create New Vault"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<VaultItemHolder> sortByType(SortType type, List<VaultItemHolder> list) {
    List<VaultItemHolder> resultList = list;
    sortType.when(
      dateAscend: () =>
          resultList.sort((a, b) => a.updatedAt.compareTo(b.updatedAt)),
      dateDescend: () =>
          resultList.sort((b, a) => a.updatedAt.compareTo(b.updatedAt)),
      wordAscend: () => resultList.sort((a, b) => a.name.compareTo(b.name)),
      wordDescend: () =>
          resultList.sort((b, a) => a.updatedAt.compareTo(b.updatedAt)),
    );
    return resultList;
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
              title: Text(
                "Are you sure that you want to delete \"$holderName\"",
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
