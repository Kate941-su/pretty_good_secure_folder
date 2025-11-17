import 'package:hooks_riverpod/hooks_riverpod.dart';

final enterVaultNameNotifierProvider = NotifierProvider<EnterVaultNameNotifier, String?>(() {
  return EnterVaultNameNotifier();
});

class EnterVaultNameNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  void setValue(String? value) {
    state = value;
  }
}