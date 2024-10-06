import 'dart:io';

import 'package:disks_desktop/disks_desktop.dart';
import 'package:flutter/material.dart';

class DriveUtility {
  Future<List<Disk>> getDrives() async {
    if (Platform.isLinux) {
      return _getLinuxDrives();
    } else {
      return [];
    }
  }

  Future<List<Disk>> _getLinuxDrives() async {
    final repository = DisksRepository();
    final disks = await repository.query;
    debugPrint('devices $disks');

    List<Disk> listRemovableDisks = [];
    for (var disk in disks) {
      if (disk.busType.toLowerCase().trim() == "usb") {
        listRemovableDisks.add(disk);
      }
    }

    return listRemovableDisks;
  }
}
