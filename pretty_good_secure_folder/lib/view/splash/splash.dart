import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/extension/colors+_custom_color.dart';
import 'package:pretty_good_secure_folder/provider/user_state.dart';
import 'package:pretty_good_secure_folder/provider/vault_item_state.dart';
import 'package:pretty_good_secure_folder/service/shared_preference_service.dart';

import '../../gen/assets.gen.dart';

class SplashView extends HookConsumerWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future(() async {
        await ref.read(sharedPreferenceServiceProvider.notifier).initialize();
        await ref.read(userStateProvider.notifier).initialize();
        await ref.read(vaultItemHolderStateProvider.notifier).initialize();
        if (context.mounted) { context.go("/main"); }
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: CustomColors.primaryColor,
      body: Column(
        children: [
          // Expanded takes remaining space in the Column
          Expanded(
            // Center positions the image within that expanded space
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  Text(
                    "Key Holder",
                    style: TextStyle(fontSize: 24,
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    "Initializing...",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
