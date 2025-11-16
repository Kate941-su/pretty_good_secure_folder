import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/provider/vault_item_state.dart';
import 'package:pretty_good_secure_folder/view/component/slidable_item_widget.dart';

class SlideItemView extends ConsumerWidget{
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

              },
              onTapDelete: (item){
                notifier.removeVaultItemHolder(id: vaultItemHolder.id);
              },
            ),
          TextButton(onPressed:() {

          }, child: Text("Create New Vault"))
        ],
      ),
    );
  }
}