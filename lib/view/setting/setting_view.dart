import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/provider/global_package_info.dart';
import 'package:pretty_good_secure_folder/service/db_handler.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';


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
                final exportedPath = await ref.read(dbHandlerProvider.notifier).exportFile();
                await SharePlus.instance.share(ShareParams(files: [XFile(exportedPath)]));
                // Show Dialog
              },
              leading: Icon(Icons.upload),
              title: Text('Make backup'),
            ),
            SettingsTile.navigation(
              onPressed: (_) async {
                try {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                  ) ?? FilePickerResult([]);
                  final paths = result.paths;
                  if (paths.isNotEmpty) {
                    ref.read(dbHandlerProvider.notifier).importFile(paths.first!);
                  } else {
                    // User canceled the picker
                  }
                } catch (e) {
                  // TODO: Show alert
                }
              },
              leading: Icon(Icons.download),
              title: Text('Import Items from backup'),
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
