import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jackbox_patcher/components/dialogs/media_kit_remover_dialog.dart';
import 'package:jackbox_patcher/model/base/extensions/list_extensions.dart';
import 'package:jackbox_patcher/model/base/extensions/null_extensions.dart';

class MediaKitRemover {
  static final List<String> appPath = ["./app", "."];

  static final List<String> filesToRemove = [
    "api-ms-win-core-console-l1-1-0.dll",
    "api-ms-win-core-console-l1-2-0.dll",
    "api-ms-win-core-datetime-l1-1-0.dll",
    "api-ms-win-core-debug-l1-1-0.dll",
    "api-ms-win-core-errorhandling-l1-1-0.dll",
    "api-ms-win-core-fibers-l1-1-0.dll",
    "api-ms-win-core-file-l1-1-0.dll",
    "api-ms-win-core-file-l1-2-0.dll",
    "api-ms-win-core-file-l2-1-0.dll",
    "api-ms-win-core-handle-l1-1-0.dll",
    "api-ms-win-core-heap-l1-1-0.dll",
    "api-ms-win-core-interlocked-l1-1-0.dll",
    "api-ms-win-core-libraryloader-l1-1-0.dll",
    "api-ms-win-core-localization-l1-2-0.dll",
    "api-ms-win-core-memory-l1-1-0.dll",
    "api-ms-win-core-namedpipe-l1-1-0.dll",
    "api-ms-win-core-processenvironment-l1-1-0.dll",
    "api-ms-win-core-processthreads-l1-1-0.dll",
    "api-ms-win-core-processthreads-l1-1-1.dll",
    "api-ms-win-core-profile-l1-1-0.dll",
    "api-ms-win-core-rtlsupport-l1-1-0.dll",
    "api-ms-win-core-string-l1-1-0.dll",
    "api-ms-win-core-synch-l1-1-0.dll",
    "api-ms-win-core-synch-l1-2-0.dll",
    "api-ms-win-core-sysinfo-l1-1-0.dll",
    "api-ms-win-core-timezone-l1-1-0.dll",
    "api-ms-win-core-util-l1-1-0.dll",
    "api-ms-win-crt-conio-l1-1-0.dll",
    "api-ms-win-crt-convert-l1-1-0.dll",
    "api-ms-win-crt-environment-l1-1-0.dll",
    "api-ms-win-crt-filesystem-l1-1-0.dll",
    "api-ms-win-crt-heap-l1-1-0.dll",
    "api-ms-win-crt-locale-l1-1-0.dll",
    "api-ms-win-crt-math-l1-1-0.dll",
    "api-ms-win-crt-multibyte-l1-1-0.dll",
    "api-ms-win-crt-private-l1-1-0.dll",
    "api-ms-win-crt-process-l1-1-0.dll",
    "api-ms-win-crt-runtime-l1-1-0.dll",
    "api-ms-win-crt-stdio-l1-1-0.dll",
    "api-ms-win-crt-string-l1-1-0.dll",
    "api-ms-win-crt-time-l1-1-0.dll",
    "api-ms-win-crt-utility-l1-1-0.dll",
    "api-ms-win-downlevel-kernel32-l2-1-0.dll",
    "api-ms-win-eventing-provider-l1-1-0.dll",
    "concrt140.dll",
    "d3dcompiler_47.dll",
    "libc++.dll",
    "libEGL.dll",
    "libGLESv2.dll",
    "libmpv-2.dll",
    "media_kit_libs_windows_video_plugin.dll",
    "media_kit_native_event_loop.dll",
    "media_kit_video_plugin.dll",
    "msvcp140_1.dll",
    "msvcp140_2.dll",
    "msvcp140_atomic_wait.dll",
    "msvcp140_codecvt_ids.dll",
    "screen_brightness_windows_plugin.dll",
    "ucrtbase.dll",
    "ucrtbased.dll",
    "vccorlib140.dll",
    "vccorlib140d.dll",
    "vcruntime140.dll",
    "vcruntime140_1.dll",
    "vcruntime140_1d.dll",
    "vcruntime140d.dll",
    "vk_swiftshader.dll",
    "vulkan-1.dll",
    "zlib.dll"
  ];

  static Future<void> removeMediaKit(BuildContext context) async {
    // Check if any of the files to remove are present in all the app paths available
    String? path = await appPath.firstWhereOrNull((element) async {
      return (await filesToRemove.firstWhereOrNull((file) async {
            return await (File("$element/$file").exists());
          })) !=
          null;
    });

    try {
      await path.let((path) async {
        // Checking if media_kit_remover.exe is present
        if (File("$path/tools/media_kit_remover.exe").existsSync()) {
          // Showing the dialog to remove media kit
          await showDialog(
              context: context,
              builder: (context) => const MediaKitRemoverDialog(),
              barrierDismissible: false);

          Process.run("$path/tools/media_kit_remover.exe",
              [path, "$path/jackbox_patcher.exe"]);
          await Future.delayed(Duration(seconds: 1));
          exit(0);
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
