import 'dart:io';

class DriveUtility {
  List<String> getDrives() {
    if (Platform.isLinux) {
      return _getLinuxDrives();
    } else {
      return [];
    }
  }

  List<String> _getLinuxDrives() {
    // Common mount points for external drives
    List<String> mountPoints = [
      '/media',
      '/mnt',
    ];

    List<String> drives = [];
    for (var mount in mountPoints) {
      Directory dir = Directory(mount);
      if (dir.existsSync()) {
        drives.addAll(dir
            .listSync()
            .whereType<Directory>()
            .map((d) => d.absolute.path)
            .toList());
      }
    }
    return drives;
  }
}
