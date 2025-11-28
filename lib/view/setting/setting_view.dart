import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/model/error/app_error.dart';
import 'package:pretty_good_secure_folder/provider/global_package_info.dart';
import 'package:pretty_good_secure_folder/service/db_handler.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingView extends HookConsumerWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: Text('General'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              onPressed: (_) {
                showLicensePage(
                  applicationName: ref.watch(
                    globalPackageInfoProvider.select((it) => it.packageName),
                  ),
                  context: context,
                );
              },
              leading: Icon(Icons.library_books),
              title: Text('License'),
            ),
          ],
        ),
        SettingsSection(
          title: Text('Backup'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              onPressed: (_) async {
                await ref.read(dbHandlerProvider.notifier).exportFile();
              },
              leading: Icon(Icons.upload),
              title: Text('Data Export'),
            ),
            SettingsTile.navigation(
              onPressed: (_) {

              },
              leading: Icon(Icons.import_export),
              title: Text('Data Import'),
            ),
            SettingsTile.navigation(
              onPressed: (_) {
                // Directory(path);
              },
              leading: Icon(Icons.garage),
              title: Text('Debug(Delete)'),
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
