import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';

class BlueProvider with ChangeNotifier {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  bool _isScanning = false;
  bool _isConnected = false;

  BluetoothDevice? _connectedDevice;

  final List<ScanResult> _scanResults = [];

  StreamSubscription<List<ScanResult>>? _scanSub;

  StreamSubscription<BluetoothConnectionState>? _deviceStateSub;
  StreamSubscription<List<int>>? _notifySub;

  BluetoothCharacteristic? _writeChar;
  BluetoothCharacteristic? _notifyChar;

  final StreamController<Uint8List> _dataStreamController =
      StreamController<Uint8List>.broadcast();

  // Getters
  BluetoothAdapterState get adapterState => _adapterState;
  bool get isScanning => _isScanning;
  bool get isConnected => _isConnected;
  List<BluetoothDevice> get devices =>
      _scanResults.map((e) => e.device).toList();
  Stream<Uint8List> get onDataReceived => _dataStreamController.stream;

  BlueProvider() {
    initialize();
  }

  // ------------------------------------------------------------
  // INITIALIZE
  // ------------------------------------------------------------
  Future<void> initialize() async {
    FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      notifyListeners();

      if (state == BluetoothAdapterState.off) {
        _onDisconnected();
      }
    });

    _adapterState = await FlutterBluePlus.adapterState.first;
    notifyListeners();
  }

  // ------------------------------------------------------------
  // ENABLE BLUETOOTH
  // ------------------------------------------------------------
  Future<void> enableBluetooth() async {
    await checkPermissions();
    await FlutterBluePlus.turnOn();
  }

  // ------------------------------------------------------------
  // PERMISSIONS
  // ------------------------------------------------------------
  Future<void> checkPermissions() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  }

  // ------------------------------------------------------------
  // SCAN DEVICES
  // ------------------------------------------------------------
  Future<void> startScan() async {
    if (_isScanning) return;

    await checkPermissions();
    _scanResults.clear();
    notifyListeners();

    _isScanning = true;
    notifyListeners();

    await FlutterBluePlus.startScan();

    _scanSub = FlutterBluePlus.scanResults.listen((results) {
      _scanResults.clear();
      _scanResults.addAll(results);
      notifyListeners();
    });
  }

  void stopScan() async {
    await FlutterBluePlus.stopScan();
    _scanSub?.cancel();
    _isScanning = false;
    notifyListeners();
  }

  // ------------------------------------------------------------
  // CONNECT TO DEVICE
  // ------------------------------------------------------------
  Future<void> connectToDevice(
    BluetoothDevice device, {
    required License license,
  }) async {
    try {
      stopScan();

      await device.connect(
        license: license,
        timeout: const Duration(seconds: 25),
        autoConnect: false,
      );

      _connectedDevice = device;
      _isConnected = true;
      notifyListeners();

      _deviceStateSub =
          device.connectionState.listen((BluetoothConnectionState state) {
        if (state == BluetoothConnectionState.disconnected) {
          _onDisconnected();
        }
      });

      final services = await device.discoverServices();

      // auto-pick characteristics
      for (var s in services) {
        for (var c in s.characteristics) {
          if (_writeChar == null &&
              (c.properties.write || c.properties.writeWithoutResponse)) {
            _writeChar = c;
          }

          if (_notifyChar == null &&
              (c.properties.notify || c.properties.indicate)) {
            _notifyChar = c;
          }

          if (_writeChar != null && _notifyChar != null) break;
        }
        if (_writeChar != null && _notifyChar != null) break;
      }

      if (_notifyChar != null) {
        await _notifyChar!.setNotifyValue(true);
        _notifySub = _notifyChar!.lastValueStream.listen((value) {
          _dataStreamController.add(Uint8List.fromList(value));
        });
      }
    } catch (e) {
      debugPrint("Connect error: $e");
      _onDisconnected();
    }
  }

  // ------------------------------------------------------------
  // SEND DATA
  // ------------------------------------------------------------
  Future<void> sendData(String data) async {
    if (_writeChar == null) return;

    Vibration.vibrate(duration: 100);
    final bytes = utf8.encode(data);

    await _writeChar!.write(bytes, withoutResponse: false);
  }

  // ------------------------------------------------------------
  // DISCONNECT
  // ------------------------------------------------------------
  Future<void> disconnect() async {
    if (_connectedDevice != null) {
      await _connectedDevice!.disconnect();
    }
    _onDisconnected();
  }

  void _onDisconnected() {
    _isConnected = false;
    _connectedDevice = null;

    _scanSub?.cancel();
    _deviceStateSub?.cancel();
    _notifySub?.cancel();

    _writeChar = null;
    _notifyChar = null;

    notifyListeners();
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    _deviceStateSub?.cancel();
    _notifySub?.cancel();
    _dataStreamController.close();
    super.dispose();
  }
}
