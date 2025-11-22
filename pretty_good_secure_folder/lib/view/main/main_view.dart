import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/view/main/slide_item_view.dart';

import '../../extension/colors+_custom_color.dart';

class MainView extends HookConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isFavorite = useState(false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Folder'),
        actions: [
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
          IconButton(onPressed: () {}, icon: Icon(Icons.sort)),
        ],
      ),
      body: SlideItemView(isFilterFavorite: isFavorite.value,),
    );
  }
}
