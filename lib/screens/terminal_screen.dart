import 'dart:convert';

import 'package:bluetooth_arduino/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TerminalLine {
  final String content;
  final DateTime timestamp;
  final TerminalLineType type;
  final String? prefix;

  TerminalLine({
    required this.content,
    required this.timestamp,
    required this.type,
    this.prefix,
  });
}

enum TerminalLineType {
  received,
  sent,
  system,
  error,
  info,
}

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final List<TerminalLine> _terminalLines = [];
  late BlueProvider _blueProvider;
  bool _isConnected = false;
  String _deviceName = "Unknown Device";

  @override
  void initState() {
    super.initState();
    _blueProvider = context.read<BlueProvider>();
    _blueProvider.onDataReceived.listen(_handleBluetoothData);
    _addSystemLine("Terminal initialized. Ready for commands.");
    _checkConnectionStatus();
  }

  void _checkConnectionStatus() {
    // Check if device is connected
    setState(() {
      _isConnected = _blueProvider.isConnected;
      if (_isConnected) {
        _deviceName = _blueProvider.devices.first.name ?? "Unknown Device";
        _addSystemLine("Connected to $_deviceName");
      } else {
        _addSystemLine("No device connected");
      }
    });
  }

  void _handleBluetoothData(Uint8List data) {
    if (!mounted) return;
    try {
      final String jsonString = utf8.decode(data).trim();
      _addTerminalLine(jsonString, TerminalLineType.received);
    } catch (err) {
      _addTerminalLine("Error decoding data: $err", TerminalLineType.error);
    }
  }

  void _addTerminalLine(String content, TerminalLineType type,
      {String? prefix}) {
    setState(() {
      _terminalLines.add(TerminalLine(
        content: content,
        timestamp: DateTime.now(),
        type: type,
        prefix: prefix,
      ));
    });
    _scrollToBottom();
  }

  void _addSystemLine(String content) {
    _addTerminalLine(content, TerminalLineType.system);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearTerminal() {
    setState(() {
      _terminalLines.clear();
    });
    _addSystemLine("Terminal cleared");
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117), // GitHub dark theme
      appBar: _buildTerminalAppBar(),
      body: Column(
        children: [
          _buildTerminalHeader(),
          Expanded(
            child: _buildTerminalBody(),
          ),
          _buildTerminalInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildTerminalAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF161B22),
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Color(0xFFF85149),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Color(0xFFFBAB04),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Color(0xFF3FB950),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            "Terminal",
            style: TextStyle(
              color: Color(0xFFF0F6FC),
              fontSize: 16,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _clearTerminal,
          icon: const Icon(Icons.clear_all, color: Color(0xFFF0F6FC)),
          tooltip: "Clear Terminal",
        ),
        IconButton(
          onPressed: _checkConnectionStatus,
          icon: Icon(
            _isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
            color: _isConnected
                ? const Color(0xFF3FB950)
                : const Color(0xFFF85149),
          ),
          tooltip: _isConnected ? "Connected" : "Disconnected",
        ),
      ],
    );
  }

  Widget _buildTerminalHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF21262D),
        border: Border(
          bottom: BorderSide(color: Color(0xFF30363D), width: 1),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.terminal,
            color: Color(0xFF7C3AED),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            _isConnected ? "Connected to $_deviceName" : "No device connected",
            style: const TextStyle(
              color: Color(0xFFF0F6FC),
              fontSize: 14,
              fontFamily: 'monospace',
            ),
          ),
          const Spacer(),
          Text(
            DateTime.now().toString().substring(11, 19),
            style: const TextStyle(
              color: Color(0xFF7D8590),
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerminalBody() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF30363D)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(12),
          itemCount: _terminalLines.length,
          itemBuilder: (context, index) {
            final line = _terminalLines[index];
            return _buildTerminalLine(line);
          },
        ),
      ),
    );
  }

  Widget _buildTerminalLine(TerminalLine line) {
    Color textColor;
    String prefix = "";

    switch (line.type) {
      case TerminalLineType.received:
        textColor = const Color(0xFF58A6FF);
        prefix = "← ";
        break;
      case TerminalLineType.sent:
        textColor = const Color(0xFF7C3AED);
        prefix = "→ ";
        break;
      case TerminalLineType.system:
        textColor = const Color(0xFF7D8590);
        prefix = "● ";
        break;
      case TerminalLineType.error:
        textColor = const Color(0xFFF85149);
        prefix = "✗ ";
        break;
      case TerminalLineType.info:
        textColor = const Color(0xFF3FB950);
        prefix = "ℹ ";
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "[${line.timestamp.toString().substring(11, 19)}] ",
            style: const TextStyle(
              color: Color(0xFF7D8590),
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
          Text(
            prefix,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
          Expanded(
            child: Text(
              line.content,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontFamily: 'monospace',
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerminalInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF161B22),
        border: Border(
          top: BorderSide(color: Color(0xFF30363D), width: 1),
        ),
      ),
      child: Row(
        children: [
          const Text(
            "> ",
            style: TextStyle(
              color: Color(0xFF7C3AED),
              fontSize: 16,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: const TextStyle(
                color: Color(0xFFF0F6FC),
                fontSize: 14,
                fontFamily: 'monospace',
              ),
              decoration: const InputDecoration(
                hintText: 'Enter command...',
                hintStyle: TextStyle(
                  color: Color(0xFF7D8590),
                  fontFamily: 'monospace',
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              onSubmitted: _sendCommand,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED),
              borderRadius: BorderRadius.circular(6),
            ),
            child: IconButton(
              onPressed: _sendCommand,
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              tooltip: "Send Command",
            ),
          ),
        ],
      ),
    );
  }

  void _sendCommand([String? command]) {
    final text = command ?? _controller.text;
    if (text.isNotEmpty) {
      _addTerminalLine(text, TerminalLineType.sent);
      _blueProvider.sendData(text);
      _controller.clear();
      _focusNode.requestFocus();
    }
  }
}
