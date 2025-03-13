import 'dart:convert';
import 'package:bluetooth_arduino/app/extensions.dart';
import 'package:bluetooth_arduino/provider.dart';
import 'package:bluetooth_arduino/screens/mini_mars_rover.dart';
import 'package:bluetooth_arduino/screens/terminal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  String wifiId = "", wifiPswd = "";
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

    _check();
  }

  void _check() async {
    final result = await SharedPrefsHelper().checkIsFirstTime();

    print('!!!!!!!!!!!!!!!!!!!!!!!${result}');
    if (result) {
      await SharedPrefsHelper().saveData(initialData);
    } else {
      Map<String, dynamic>? data = await SharedPrefsHelper().getData();
      print('#######################${data}');
    }
  }

  void connectToDevice(BluetoothDevice device) async {
    context.showLoading();
    await _blueProvider.connectToDevice(device);

    if (!mounted) return;
    context.hideLoading();

    _blueProvider.sendData(jsonEncode({"command": "GET_DEVICE_PROPERTIES"}));
  }

  @override
  void dispose() {
    super.dispose();

    _blueProvider.stopDiscovery();
  }

  final List<String> _iconPath = [
    'assets/svg_icons/arrow_keys.svg',
    'assets/svg_icons/terminal.svg',
    'assets/svg_icons/mars-rover2.svg'
  ];

  final List<String> _screenNames = [
    'Arrow Keys',
    'Terminal',
    'Mini Mars Rover'
  ];

  final List<Color> _bgColor = [buttonColor, limeColor, greenColor];

  @override
  Widget build(BuildContext context) {
    return Consumer<BlueProvider>(builder: (context, listener, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            if (listener.bluetoothState == BluetoothState.STATE_ON &&
                !listener.isDiscovering &&
                !listener.isConnected) ...[
              IconButton(
                onPressed: () => _blueProvider.startDiscovery(),
                icon: const Icon(Icons.refresh),
              ),
            ] else if (!listener.isDiscovering && listener.isConnected) ...[
              IconButton(
                  onPressed: () => _blueProvider.disconnect(),
                  icon: const Icon(
                    Icons.bluetooth,
                  )),
              // TextButton(
              //     onPressed: () => _blueProvider.disconnect(),
              //     child: const Text(
              //       'Disconnect',
              //       style: TextStyle(color: primaryColor),
              //     ))
            ],
          ],
        ),
        body: Builder(
          builder: (context) {
            if (listener.bluetoothState == BluetoothState.STATE_OFF) {
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

            if (!listener.isDiscovering && listener.devices.isEmpty) {
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
                    visible: listener.isDiscovering,
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
                            listener.devices[index].name ?? "Unknown device",
                            style: const TextStyle(
                              color: primaryColor,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            listener.devices[index].address,
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
