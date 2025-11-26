import 'package:freezed_annotation/freezed_annotation.dart';

part 'toast.freezed.dart';

@freezed
abstract class Toast with _$Toast {
  const factory Toast.createVaultHolder() = CreateVaultHolder;
  const factory Toast.editVaultHolder() = EditVaultHolder;
}

String getMessage(Toast toast) {
  return toast.when(
      createVaultHolder: () => 'Success Create',
      editVaultHolder: () => 'Success Edit'
    );
}