import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:security_key_generator/model/ui_model.dart/home_grid_btn_model.dart';
import 'package:security_key_generator/utility/drive_utility.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DriveUtility detector = DriveUtility();
  List<String> drives = [];
  String? selectedDrive;
  String fileContent = '';
  bool isScanning = true;

  final List<HomeGridBtnModel> gridItems = [
    HomeGridBtnModel(icon: Icons.track_changes, label: "Scan Drive"),
    HomeGridBtnModel(icon: Icons.add_moderator, label: "Create key"),
    HomeGridBtnModel(icon: Icons.document_scanner_outlined, label: "Read key"),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () => _loadDrives());
  }

  void _loadDrives() {
    setState(() {
      drives = detector.getDrives();
      if (drives.isNotEmpty) {
        selectedDrive = drives.first;
      }
      isScanning = false;
    });
  }

  void _createJsonFile() async {
    if (selectedDrive == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('There is no Selected Drive')));
      return;
    }

    String filePath = '$selectedDrive/data.json';
    File file = File(filePath);

    Map<String, dynamic> data = {
      'message': 'Hello from Flutter!',
      'timestamp': DateTime.now().toIso8601String(),
    };

    String jsonString = jsonEncode(data);

    try {
      await file.writeAsString(jsonString);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('JSON file created at $filePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating file: $e')),
      );
    }
  }

  void _readFile() async {
    if (selectedDrive == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('There is no Selected Drive')));
      return;
    }

    String filePath = '$selectedDrive/data.json';
    File file = File(filePath);

    if (!file.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File does not exist at $filePath')),
      );
      return;
    }

    try {
      String content = await file.readAsString();
      setState(() {
        fileContent = content;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error reading file: $e')),
      );
    }
  }

  void _gridBtnFunc(int index) {
    switch (index) {
      case 1:
        return _createJsonFile();
      case 2:
        return _readFile();
      default:
        setState(() {
          isScanning = true;
        });
        Future.delayed(const Duration(seconds: 3), () => _loadDrives());
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sekurity Key Generator'),
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListOfDrives(context),
          const SizedBox(width: 20),
          _buildGridBtnView(context),
        ],
      ),
    );
  }

  Widget _buildListOfDrives(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width / 2,
        child: Card(
          elevation: 5.0,
          child: ListView.builder(
            itemCount: drives.isNotEmpty ? drives.length : 1,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (drives.isEmpty) {
                return Center(
                  child: Text(
                    "There is no drive detected",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                );
              }
              return _buildListDriveItem(context, drives[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildListDriveItem(BuildContext context, String driveName) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      child: ListTile(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        leading: const Icon(
          Icons.sd_storage,
          size: 30.0,
        ),
        title: Text(
          driveName,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        onTap: () {
          setState(() {
            selectedDrive = driveName;
          });
        },
      ),
    );
  }

  Widget _buildGridBtnView(BuildContext context) {
    return Flexible(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: 100.0,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
          ),
          shrinkWrap: true,
          itemCount: gridItems.length,
          itemBuilder: (context, index) => _buildGridBtnItem(
            context,
            index,
            gridItems[index].icon,
            gridItems[index].label,
          ),
        ),
      ),
    );
  }

  Widget _buildGridBtnItem(
      BuildContext context, int index, IconData icon, String label) {
    return Card(
      elevation: 5.0,
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          InkWell(
            onTap: () => _gridBtnFunc(index),
            borderRadius: BorderRadius.circular(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  icon,
                  size: 30.0,
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Visibility(
            visible: isScanning,
            child: Container(
              color: Colors.white.withOpacity(0.6),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
