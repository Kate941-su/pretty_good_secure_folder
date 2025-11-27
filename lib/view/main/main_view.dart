import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/model/union/sort_type.dart';
import 'package:pretty_good_secure_folder/provider/sort_type_state.dart';
import 'package:pretty_good_secure_folder/view/main/slide_item_view.dart';

import '../../extension/colors+_custom_color.dart';

class MainView extends HookConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = useState(false);
    final isSearching = useState(false);
    final filterText = useState("");
    final sortType = ref.watch(sortTypeStateProvider);
    // final controller = TextEditingController();

    Widget appBarTitle({
      required bool isSearching,
      required Function(String) onChange,
      required VoidCallback onCancel,
    }) {
      if (isSearching) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  // controller: controller,
                  initialValue: "",
                  cursorColor: Colors.red,
                  onTapOutside: (_){
                    onCancel();
                  },
                  onChanged: (value) {
                    onChange(value);
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  onCancel();
                },
                icon: Icon(Icons.cancel),
              ),
            ],
          ),
        );
      } else {
        return Text("Items");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: appBarTitle(
          isSearching: isSearching.value,
          onChange: (value) {
            filterText.value = value;
          },
          onCancel: () {
            filterText.value = "";
            isSearching.value = false;
          },
        ),
        actions: [
          if (!isSearching.value)
            IconButton(
              onPressed: () {
                isSearching.value = true;
              },
              icon: Icon(Icons.search),
            ),
          if (!isSearching.value)
            IconButton(
              onPressed: () {
                isFavorite.value = !isFavorite.value;
              },
              icon: isFavorite.value
                  ? Icon(Icons.star, color: CustomColors.favorite)
                  : Icon(
                      Icons.star_border_outlined,
                      color: CustomColors.favorite,
                    ),
            ),
          if (!isSearching.value)
            IconButton(
              onPressed: () {
                _changeSortTypeDialogBuilder(context);
              },
              icon: Icon(Icons.sort),
            ),
        ],
      ),
      body: SlideItemView(
        isFilterFavorite: isFavorite.value,
        filterText: filterText.value,
        sortType: sortType,
      ),
    );
  }

  Future<void> _changeSortTypeDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final sortType = ref.watch(sortTypeStateProvider);
            return AlertDialog(
              title: Text("Choose sort type"),
              content: RadioGroup<SortType>(
                groupValue: sortType,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  ref.read(sortTypeStateProvider.notifier).setSortType(value);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(SortType.wordAscend().name),
                      leading: Radio<SortType>(value: SortType.wordAscend()),
                    ),
                    ListTile(
                      title: Text(SortType.dateAscend().name),
                      leading: Radio<SortType>(value: SortType.dateAscend()),
                    ),
                    ListTile(
                      title: Text(SortType.wordAscend().name),
                      leading: Radio<SortType>(value: SortType.wordDescend()),
                    ),
                    ListTile(
                      title: Text(SortType.dateDescend().name),
                      leading: Radio<SortType>(value: SortType.dateDescend()),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text(
                    'End',
                    style: TextStyle(color: CustomColors.info),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
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
