import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_package_info.g.dart';

// Provider for storing measurements
@riverpod
class GlobalPackageInfo extends _$GlobalPackageInfo {

  @override
  PackageInfo build() {
    return PackageInfo(appName: "",
        packageName: "",
        version: "",
        buildNumber: "");
  }

  Future<void> initialize() async {
    state = await PackageInfo.fromPlatform();
  }


}