import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluetooth_arduino/provider.dart';
import 'package:bluetooth_arduino/app/constants.dart';

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String receivedData = "";
  late BlueProvider _blueProvider;

  @override
  void initState() {
    super.initState();
    _blueProvider = context.read<BlueProvider>();
    _blueProvider.onDataReceived.listen(_handleBluetoothData);
  }

  void _handleBluetoothData(Uint8List data) {
    if (!mounted) return;
    try {
      final String jsonString = utf8.decode(data).trim();
      setState(() {
        // Append received data with "Received:" prefix
        receivedData = "$receivedData\nReceived: $jsonString".trim();
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: limeColor,
      appBar: AppBar(
        title: const Text("Terminal"),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: defaultSpacing),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 90),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  reverse: true,
                  child: Text(
                    receivedData,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(defaultPadding),
        color: limeColor,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: const InputDecoration(
                  hintText: 'Enter text to send...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  String textToSend = "Sent: ${_controller.text}";
                  _blueProvider.sendData(_controller.text);

                  setState(() {
                    receivedData = "$receivedData\n$textToSend";
                  });

                  _controller.clear();
                  _focusNode.unfocus();
                }
              },
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
