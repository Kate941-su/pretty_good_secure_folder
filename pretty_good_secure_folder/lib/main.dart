import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/go_router/go_router_manager.dart';
import 'package:pretty_good_secure_folder/model/error/app_error.dart';
import 'package:pretty_good_secure_folder/provider/vault_item_state.dart';
import 'package:pretty_good_secure_folder/view/component/text_enter_field.dart';
import 'package:pretty_good_secure_folder/view/create_item_view.dart';
import 'package:pretty_good_secure_folder/view/main_view.dart';

import 'model/vault_item.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
