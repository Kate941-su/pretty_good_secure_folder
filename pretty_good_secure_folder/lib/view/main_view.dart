import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/model/error/app_error.dart';
import 'package:pretty_good_secure_folder/view/component/slide_item_view.dart';

class MainView extends HookConsumerWidget {
  const MainView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pretty Good Secure Folder'),
      ),
      body: SlideItemView()
    );
  }
}
