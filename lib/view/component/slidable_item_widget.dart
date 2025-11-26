import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/extension/colors+_custom_color.dart';
import 'package:pretty_good_secure_folder/model/vault_item_holder.dart';

class SlidableItemWidget extends ConsumerStatefulWidget {
  const SlidableItemWidget({
    required this.vaultItemHolder,
    required this.isFavorite,
    required this.onTapFavorite,
    required this.onTapCopy,
    required this.onTapDelete,
    required this.onTapItem,
    super.key,
  });

  final VaultItemHolder vaultItemHolder;
  final bool isFavorite;
  final Function(bool) onTapFavorite;
  final Function(VaultItemHolder) onTapCopy;
  final Function(VaultItemHolder) onTapDelete;
  final Function(VaultItemHolder) onTapItem;

  @override
  ConsumerState<SlidableItemWidget> createState() => _SlidableItemState();
}

class _SlidableItemState extends ConsumerState<SlidableItemWidget>
    with SingleTickerProviderStateMixin {
  late final controller = SlidableController(this);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTapItem(widget.vaultItemHolder);
      },
      child: Slidable(
        controller: controller,
        key: const ValueKey(1),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                widget.onTapCopy(widget.vaultItemHolder);
              },
              backgroundColor: CustomColors.copy,
              foregroundColor: Colors.white,
              icon: Icons.copy,
              label: 'Copy',
            ),
            SlidableAction(
              onPressed: (_) {
                widget.onTapDelete(widget.vaultItemHolder);
              },
              backgroundColor: CustomColors.warning,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.vaultItemHolder.name, maxLines: 3),
                    Text(
                      "${widget.vaultItemHolder.updatedAt.day}.${widget.vaultItemHolder.updatedAt.month}.${widget.vaultItemHolder.updatedAt.year}",
                      style: TextStyle(
                        color: CustomColors.disable,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  widget.onTapFavorite(!widget.isFavorite);
                },
                icon: widget.isFavorite
                    ? Icon(Icons.star, color: CustomColors.favorite)
                    : Icon(
                        Icons.star_border_outlined,
                        color: CustomColors.favorite,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void doNothing(BuildContext context) {}
