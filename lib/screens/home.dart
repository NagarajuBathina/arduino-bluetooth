import 'dart:convert';
import 'package:bluetooth_arduino/app/extensions.dart';
import 'package:bluetooth_arduino/provider.dart';
import 'package:bluetooth_arduino/screens/mini_mars_rover.dart';
import 'package:bluetooth_arduino/screens/terminal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import '../app/constants.dart';
import '../app/shared_prefs.dart';
import 'arrow_keys_screen.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  late BlueProvider _blueProvider;
  int timeInterval = 10000;
  String receivedData = "";

  final Map<String, dynamic> initialData = {
    'left_key': '1',
    'right_key': '1',
    'up_key': '1',
    'down_key': '1',
    'mars_up_key': '1',
    'mars_down_key': '1',
    'mars_left_key': '1',
    'mars_right_key': '1',
    'mars_middle_key': '1',
    'mars_top_left_key': '1',
    'mars_top_right_key': '1',
    'mars_bottom_left_key': '1',
    'mars_bottom_right_key': '1',
  };

  @override
  void initState() {
    super.initState();

    _blueProvider = context.read<BlueProvider>();

    checkForUpdate();
    _check();
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          update();
        }
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  void update() async {
    print('updating');
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      print(e.toString());
    });
  }

  void _check() async {
    final result = await SharedPrefsHelper().checkIsFirstTime();

    if (result) {
      await SharedPrefsHelper().saveData(initialData);
    }
  }

  void connectToDevice(BluetoothDevice device) async {
    context.showLoading();
    await _blueProvider.connectToDevice(device, license: License.free);

    if (!mounted) return;
    context.hideLoading();

    _blueProvider.sendData(jsonEncode({"command": "GET_DEVICE_PROPERTIES"}));
  }

  @override
  void dispose() {
    _blueProvider.startScan();
    super.dispose();
  }

  final List<String> _iconPath = [
    'assets/svg_icons/arrow_keys.svg',
    'assets/svg_icons/terminal.svg',
    'assets/svg_icons/mars-rover2.svg',
    'assets/svg_icons/buttons.svg',
    'assets/svg_icons/metrics.svg',
    'assets/svg_icons/mic.svg'
  ];

  final List<String> _screenNames = [
    'Arrow Keys',
    'Terminal',
    'Mini Mars Rover',
    'Buttons',
    'Metrics',
    'Voice Control'
  ];

  final List<Color> _bgColor = [
    buttonColor,
    limeColor,
    greenColor,
    blueColor,
    redColor,
    buttonColor
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BlueProvider>(builder: (context, listener, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            if (listener.adapterState == BluetoothAdapterState.on) ...[
              // If currently scanning -> show a "stop" (close) button
              if (listener.isScanning)
                IconButton(
                  onPressed: () => _blueProvider.stopScan(),
                  icon: const Icon(Icons.close),
                  tooltip: 'Stop scan',
                )
              // If not scanning and not connected -> show refresh (start scan)
              else if (!listener.isConnected)
                IconButton(
                  onPressed: () => _blueProvider.startScan(),
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Start scan',
                )
              // If connected -> show disconnect
              else
                IconButton(
                  onPressed: () => _blueProvider.disconnect(),
                  icon: const Icon(Icons.bluetooth_disabled),
                  tooltip: 'Disconnect',
                ),
            ],
          ],
        ),
        body: Builder(
          builder: (context) {
            if (listener.adapterState == BluetoothAdapterState.off) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Bluetooth is currently turned off. To use Bluetooth features, please enable it by tapping the button below.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        child: const Text("Turn Bluetooth On"),
                        onPressed: () => _blueProvider.enableBluetooth(),
                      ),
                    ),
                    const SizedBox(height: defaultPadding * 2),
                  ],
                ),
              );
            }

            if (listener.isConnected) {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: _iconPath.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (index == 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ArrowKeysScreen()));
                        } else if (index == 1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TerminalScreen()));
                        } else if (index == 2) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MiniMarsRoverScreen()));
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(color: _bgColor[index]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(_iconPath[index], height: 100),
                            Text(
                              _screenNames[index],
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            }

            if (!listener.isScanning && listener.devices.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "No devices available",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Visibility(
                    visible: listener.isScanning,
                    child: const LinearProgressIndicator(),
                  ),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: listener.devices.length,
                    itemBuilder: (context, index) {
                      final device = listener.devices[index];
                      print(device.toString());
                      return Container(
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          minLeadingWidth: 30,
                          leading: const Icon(
                            Icons.devices,
                            color: primaryColor,
                          ),
                          visualDensity:
                              const VisualDensity(horizontal: -1, vertical: -1),
                          title: Text(
                            device.platformName.isNotEmpty
                                ? device.platformName
                                : "Unknown Device",
                            style: const TextStyle(
                              color: primaryColor,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            device.remoteId.str,
                            style: const TextStyle(
                              color: primaryColor,
                              fontSize: 12,
                            ),
                          ),
                          trailing: TextButton(
                            onPressed: () =>
                                connectToDevice(listener.devices[index]),
                            child: const Text("Connect"),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
