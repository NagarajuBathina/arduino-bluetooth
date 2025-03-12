import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_arduino/extensions.dart';
import 'package:bluetooth_arduino/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

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
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    _blueProvider = context.read<BlueProvider>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getDeviceData();
    });
  }

  void getDeviceData() async {
    _blueProvider.onDataReceived.listen(_handleBluetoothData);

    if (!_blueProvider.isConnected) {
      _blueProvider.startDiscovery();
    } else {
      _blueProvider.sendData(jsonEncode({"command": "GET_DEVICE_PROPERTIES"}));
    }
  }

  void setTimeInterval(int value) async {
    context.showLoading();
    await _blueProvider.sendData(jsonEncode({"time_interval": value}));

    if (!mounted) return;
    context.hideLoading();

    setState(() {
      timeInterval = value;
    });

    context.showMessage("Configure successfully");
  }

  void connectToDevice(BluetoothDevice device) async {
    context.showLoading();
    await _blueProvider.connectToDevice(device);

    if (!mounted) return;
    context.hideLoading();

    _blueProvider.sendData(jsonEncode({"command": "GET_DEVICE_PROPERTIES"}));
  }

  void _handleBluetoothData(Uint8List data) {
    if (!mounted) return;

    try {
      final String jsonString = utf8.decode(data);
      setState(() {
        receivedData = jsonString;
      });
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);

      if (jsonData.containsKey("wifi_id")) {
        wifiId = jsonData["wifi_id"];
      }

      if (jsonData.containsKey("wifi_password")) {
        wifiPswd = jsonData["wifi_password"];
      }

      if (jsonData.containsKey("time_interval")) {
        timeInterval = jsonData["time_interval"];
      }

      setState(() {});
    } catch (err) {
      print(err);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _blueProvider.stopDiscovery();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BlueProvider>(builder: (context, listener, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Bluetooth"),
          actions: [
            if (listener.bluetoothState == BluetoothState.STATE_ON &&
                !listener.isDiscovering &&
                !listener.isConnected)
              IconButton(
                onPressed: () => _blueProvider.startDiscovery(),
                icon: const Icon(Icons.refresh),
              ),
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
                        child: Text("Turn Bluetooth On"),
                        onPressed: () => _blueProvider.enableBluetooth(),
                      ),
                    ),
                    const SizedBox(height: defaultPadding * 2),
                  ],
                ),
              );
            }

            if (listener.isConnected) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      minLeadingWidth: 0,
                      leading: const Icon(Icons.bluetooth_connected),
                      title: const Text(
                        "Device connected",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      subtitle: const Text(
                        "Bluetooth is connected to your device",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      trailing: TextButton(
                        onPressed: () => _blueProvider.disconnect(),
                        child: const Text("Disconnect"),
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 250,
                          child: TextFormField(
                            controller: _controller,
                            focusNode: _focusNode,
                            decoration: const InputDecoration(
                                hintText: 'send text here...'),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              listener.sendData(_controller.text);
                              _controller.clear();
                              _focusNode.unfocus();
                            },
                            child: const Icon(Icons.send))
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Received Data",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          child: Text(receivedData,
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (!listener.isDiscovering && listener.devices.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "No devices available",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
