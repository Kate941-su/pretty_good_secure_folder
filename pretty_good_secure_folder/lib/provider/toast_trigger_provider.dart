import 'package:pretty_good_secure_folder/model/toast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'toast_trigger_provider.g.dart';

// Provider for storing measurements
@riverpod
class ToastTrigger extends _$ToastTrigger {
  @override
  Toast? build() {
    return null;
  }
  void setToast(Toast? toast) {
    state = toast;
  }

  void unsetToast() {
    state = null;
  }

}