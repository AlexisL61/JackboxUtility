import 'package:flutter/foundation.dart';
import 'package:jackbox_patcher/model/enums/platforms.dart';
import 'package:jackbox_patcher/model/jackbox/jackbox_pack_patch.dart';
import 'package:jackbox_patcher/model/misc/launcher_property.dart';

import 'jackbox_game.dart';

class JackboxPack {
  final String id;
  final String name;
  final String description;
  final String icon;
  final JackboxLoader? loader;
  final LaunchersId? launchersId;
  final List<JackboxGame> games;
  final List<JackboxPackPatch> fixes;
  final List<JackboxPackPatch> patches;
  final PackConfiguration? configuration;
  final String background;
  final String? executable;
  final StoreLinks? storeLinks;
  final String? resourceLocation;

  JackboxPack(
      {required this.id,
      required this.name,
      required this.description,
      required this.icon,
      required this.loader,
      required this.launchersId,
      required this.background,
      required this.games,
      required this.fixes,
      required this.patches,
      required this.configuration,
      required this.executable,
      required this.storeLinks,
      required this.resourceLocation});

  factory JackboxPack.fromJson(Map<String, dynamic> json) {
    List<JackboxPackPatch> patches = _getPackPatchesFromJson(json);

    return JackboxPack(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        icon: json['icon'],
        loader: json['loader'] != null ? JackboxLoader.fromJson(json['loader']) : null,
        launchersId: json["launchers_id"] != null ? LaunchersId.fromJson(json['launchers_id']) : null,
        background: json['background'],
        games: (json['games'] as List<dynamic>).map((e) => JackboxGame.fromJson(e)).toList(),
        fixes: json["fixes"] != null
            ? (json['fixes'] as List<dynamic>).map((e) => JackboxPackPatch.fromJson(e)).toList()
            : [],
        patches: patches,
        configuration: json['configuration'] != null ? PackConfiguration.fromJson(json['configuration']) : null,
        executable: JackboxPack.generateExecutableFromJson(json['executables']),
        storeLinks: json['store_links'] != null ? StoreLinks.fromJson(json['store_links']) : null,
        resourceLocation: getDeviceGamePathOverride(json['resource_location']));
  }

  static List<JackboxPackPatch> _getPackPatchesFromJson(Map<String, dynamic> json) {
    List<JackboxPackPatch> patches = json['patchs'] != null
        ? (json['patchs'] as List<dynamic>).map((e) => JackboxPackPatch.fromJson(e)).toList()
        : [];
    patches = patches.where((element) => element.supportedPlatforms.currentPlatformInclude()).toList();
    return patches;
  }

  static isGameDubbedByPackPatch(List<JackboxPackPatch> patches, String gameId) {
    for (var patch in patches) {
      for (var game in patch.components) {
        if (game.linkedGame == gameId && game.patchType!.audios) {
          return true;
        }
      }
    }
    return false;
  }

  static List<JackboxPack> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => JackboxPack.fromJson(json)).toList();
  }

  static String? generateExecutableFromJson(json) {
    if (json == null) {
      return null;
    } else {
      if (defaultTargetPlatform == TargetPlatform.windows) {
        return json['windows'];
      } else {
        if (defaultTargetPlatform == TargetPlatform.macOS) {
          return json['mac'];
        } else {
          return json['linux'];
        }
      }
    }
  }

  static String? getDeviceGamePathOverride(Map<String, dynamic>? overrides) {
    if (overrides != null && overrides.containsKey(AppPlatformExtension.currentPlatform().name)) {
      return overrides[AppPlatformExtension.currentPlatform().name];
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'loader': loader?.toJson(),
      'launchers_id': launchersId?.toJson(),
      'background': background,
      'games': games.map((e) => e.toJson()).toList(),
      'fixes': fixes.map((e) => e.toJson()).toList(),
      'patchs': patches.map((e) => e.toJson()).toList(),
      'configuration': configuration?.toJson(),
      'executables': executable,
      'store_links': storeLinks?.toJson()
    };
  }
}

class JackboxLoader {
  final String path;
  final String version;

  JackboxLoader({required this.path, required this.version});

  factory JackboxLoader.fromJson(Map<String, dynamic> json) {
    return JackboxLoader(path: json['path'], version: json['version']);
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'version': version,
    };
  }
}

class LaunchersId {
  final String? steam;
  final String? epic;

  LaunchersId({required this.steam, required this.epic});

  factory LaunchersId.fromJson(Map<String, dynamic> json) {
    return LaunchersId(steam: json['steam'], epic: json['epic']);
  }

  Map<String, dynamic> toJson() {
    return {
      'steam': steam,
      'epic': epic,
    };
  }
}

class StoreLinks {
  final String? steam;
  final String? epic;
  final String? jackboxGamesStore;

  StoreLinks({required this.steam, required this.epic, this.jackboxGamesStore});

  factory StoreLinks.fromJson(Map<String, dynamic> json) {
    return StoreLinks(
        steam: json['steam'] != null ? json["steam"] : null,
        epic: json['epic'] != null ? json["epic"] : null,
        jackboxGamesStore: json['jackbox_games_store'] != null ? json["jackbox_games_store"] : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'steam': steam,
      'epic': epic,
      'jackbox_games_store': jackboxGamesStore,
    };
  }
}

class PackConfiguration {
  final LocalVersionOrigin versionOrigin;
  final LauncherProperty versionFile;
  final String versionProperty;

  PackConfiguration({required this.versionOrigin, required this.versionFile, required this.versionProperty});

  factory PackConfiguration.fromJson(Map<String, dynamic> json) {
    return PackConfiguration(
        versionOrigin: LocalVersionOrigin.fromString(json['version_origin']),
        versionFile: json['launcher_version_file'] == null
            ? (json['version_file'] == null
                ? LauncherProperty.fromDefault("")
                : LauncherProperty.fromData(json['version_file']))
            : LauncherProperty.fromData(json['launcher_version_file']),
        versionProperty: json['version_property']);
  }

  Map<String, dynamic> toJson() {
    return {
      'version_origin': versionOrigin.toString(),
      'version_file': versionFile,
      'version_property': versionProperty,
    };
  }
}

enum LocalVersionOrigin {
  APP,
  GAME_FILE;

  static LocalVersionOrigin fromString(String value) {
    switch (value) {
      case "app":
        return LocalVersionOrigin.APP;
      case "game_file":
        return LocalVersionOrigin.GAME_FILE;
      default:
        throw Exception("Invalid VersionOrigin");
    }
  }

  String toString() {
    switch (this) {
      case LocalVersionOrigin.APP:
        return "app";
      case LocalVersionOrigin.GAME_FILE:
        return "game_file";
    }
  }
}
