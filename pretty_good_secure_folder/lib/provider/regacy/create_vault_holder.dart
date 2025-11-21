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

class TextNotifier extends Notifier<String?> {

  TextNotifier(this.text);

  final String? text;

  @override
  String? build() {
    return text;
  }

  void setValue(String? value) {
    state = value;
  }
}