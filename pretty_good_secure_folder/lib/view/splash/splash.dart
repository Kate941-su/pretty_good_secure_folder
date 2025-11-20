import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/provider/vault_item_state.dart';

class SplashView extends HookConsumerWidget {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    useEffect((){
      ref.read(vaultItemHolderStateProvider.notifier)
          .initialize()
          .then((value) {
        if (context.mounted) {
          context.go("/main");
        }
      });
      return null;
    },[]);

      return Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Splash")
          ],
        ),
      );
    }
}
