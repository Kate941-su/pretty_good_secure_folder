import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/model/error/app_error.dart';
import 'package:pretty_good_secure_folder/provider/global_package_info.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingView extends HookConsumerWidget {
  const SettingView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: Text('Common'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: Icon(Icons.language),
              title: Text('Language'),
              value: Text('English'),
            ),
            SettingsTile.switchTile(
              onToggle: (value) {},
              initialValue: true,
              leading: Icon(Icons.format_paint),
              title: Text('Enable custom theme'),
            ),
            SettingsTile.navigation(
              onPressed: (_){
                showLicensePage(
                  applicationName: ref.watch(globalPackageInfoProvider.select((it) => it.packageName)),
                    context: context
                );},
              leading: Icon(Icons.library_books),
              title: Text('License'),
            ),
          ],
        ),
      ],
    );
  }

  void showLicensePage({
    required BuildContext context,
    String? applicationName,
    String? applicationVersion,
    Widget? applicationIcon,
    String? applicationLegalese,
    bool useRootNavigator = false,
  }) {
    final CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(context, rootNavigator: useRootNavigator).context,
    );
    Navigator.of(context, rootNavigator: useRootNavigator).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => themes.wrap(
          LicensePage(
            applicationName: applicationName,
            applicationVersion: applicationVersion,
            applicationIcon: applicationIcon,
            applicationLegalese: applicationLegalese,
          ),
        ),
      ),
    );
  }
}
