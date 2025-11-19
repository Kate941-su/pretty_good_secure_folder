import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_good_secure_folder/database/entity/holder_schema.dart';
import 'package:pretty_good_secure_folder/database/entity/item_schema.dart';
import 'package:pretty_good_secure_folder/go_router/go_router_manager.dart';
import 'package:pretty_good_secure_folder/provider/db_handler.dart';
import 'package:pretty_good_secure_folder/provider/isar_service.dart';
import 'package:toastification/toastification.dart';

void main() async {
  // Initialize Isar
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final Isar isar = await Isar.open(
    [ItemSchema, HolderSchema],
    directory: dir.path,
  );
  return runApp(ProviderScope(
      overrides: [isarProvider.overrideWithValue(isar)],
      child: const MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return ToastificationWrapper(
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
      ),
    );
  }
}
