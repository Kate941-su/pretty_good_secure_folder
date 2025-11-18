import 'package:freezed_annotation/freezed_annotation.dart';

part 'toast.freezed.dart';

@freezed
abstract class Toast with _$Toast {
  const factory Toast.createVaultHolder() = CreateVaultHolder;
}

String getMessage(Toast toast) {
  return toast.when(createVaultHolder: (){
    return 'Create Vault Holder';
  });
}