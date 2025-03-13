import 'dart:async';

import 'package:bluetooth_arduino/app/constants2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../app/constants.dart';
import '../app/shared_prefs.dart';
import '../provider.dart';
import 'edit_keys_screens/mars_rover_key_edit_screen.dart';

class MiniMarsRoverScreen extends StatefulWidget {
  const MiniMarsRoverScreen({super.key});

  @override
  State<MiniMarsRoverScreen> createState() => _MiniMarsRoverScreenState();
}

class _MiniMarsRoverScreenState extends State<MiniMarsRoverScreen> {
  late BlueProvider _blueProvider;
  Map<String, dynamic> _prefsData = {};
  Timer? _continuousTimer;

  bool _isLongPressMode = false;
  @override
  void initState() {
    super.initState();
    // Lock orientation to landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _blueProvider = context.read<BlueProvider>();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _getKeyValues();
      },
    );
  }

  @override
  void dispose() {
    // Reset orientation to default when leaving the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _continuousTimer?.cancel();
    super.dispose();
  }

  void _getKeyValues() async {
    final prefs = await SharedPrefsHelper().getData();
    if (prefs != null) {
      setState(() {
        _prefsData = prefs;
      });
    }
    print("##############################${_prefsData}");
  }

// continuous sending data
  void _startContinuousSending(String value) {
    // Cancel any existing timer
    if (_continuousTimer != null) {
      _continuousTimer?.cancel();
      _continuousTimer = null;
    }
    // Create a new timer that repeatedly sends the value
    _continuousTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_blueProvider.isConnected) {
        _blueProvider.sendData(value);
      }
    });
  }

  //stop continuous sending
  void _stopContinuousSending() {
    _continuousTimer?.cancel();
    _continuousTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenColor,
      appBar: AppBar(
        title: const Text('Mini Mars Rover'),
        titleSpacing: 0,
        actions: [
          Row(
            children: [
              const Text('Long Press Mode'),
              Switch(
                value: _isLongPressMode,
                activeColor: mErrorColor,
                onChanged: (value) {
                  setState(() {
                    _isLongPressMode = !_isLongPressMode;
                  });
                },
              ),
            ],
          ),
          IconButton(
              onPressed: () async {
                final result = await Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const MarsRoverEditScreen();
                  },
                ));
                if (result == true) {
                  _getKeyValues();
                }
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onLongPressStart: (_) {
                    if (_isLongPressMode) {
                      final value = _prefsData['mars_top_left_key'];
                      _startContinuousSending(value);
                    }
                  },
                  onLongPressEnd: (_) {
                    _stopContinuousSending();
                  },
                  onTap: () =>
                      _blueProvider.sendData(_prefsData['mars_top_left_key']),
                  child: SvgPicture.asset(
                    'assets/svg_icons/left.svg',
                    height: 50,
                  ),
                ),
                GestureDetector(
                  onLongPressStart: (_) {
                    if (_isLongPressMode) {
                      final value = _prefsData['mars_top_right_key'];
                      _startContinuousSending(value);
                    }
                  },
                  onLongPressEnd: (_) {
                    _stopContinuousSending();
                  },
                  onTap: () =>
                      _blueProvider.sendData(_prefsData['mars_top_right_key']),
                  child: SvgPicture.asset(
                    'assets/svg_icons/right.svg',
                    height: 50,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onLongPressStart: (_) {
                    if (_isLongPressMode) {
                      final value = _prefsData['mars_up_key'];
                      _startContinuousSending(value);
                    }
                  },
                  onLongPressEnd: (_) {
                    _stopContinuousSending();
                  },
                  onTap: () =>
                      _blueProvider.sendData(_prefsData['mars_up_key']),
                  child: SvgPicture.asset(
                    'assets/svg_icons/up.svg',
                    height: 60,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onLongPressStart: (_) {
                        if (_isLongPressMode) {
                          final value = _prefsData['mars_left_key'];
                          _startContinuousSending(value);
                        }
                      },
                      onLongPressEnd: (_) {
                        _stopContinuousSending();
                      },
                      onTap: () =>
                          _blueProvider.sendData(_prefsData['mars_left_key']),
                      child: SvgPicture.asset(
                        'assets/svg_icons/left.svg',
                        height: 60,
                      ),
                    ),
                    const SizedBox(width: 50),
                    GestureDetector(
                      onLongPressStart: (_) {
                        if (_isLongPressMode) {
                          final value = _prefsData['mars_middle_key'];
                          _startContinuousSending(value);
                        }
                      },
                      onLongPressEnd: (_) {
                        _stopContinuousSending();
                      },
                      onTap: () =>
                          _blueProvider.sendData(_prefsData['mars_middle_key']),
                      child: SvgPicture.asset(
                        'assets/svg_icons/stop.svg',
                        height: 50,
                      ),
                    ),
                    const SizedBox(width: 50),
                    GestureDetector(
                      onLongPressStart: (_) {
                        if (_isLongPressMode) {
                          final value = _prefsData['mars_right_key'];
                          _startContinuousSending(value);
                        }
                      },
                      onLongPressEnd: (_) {
                        _stopContinuousSending();
                      },
                      onTap: () =>
                          _blueProvider.sendData(_prefsData['mars_right_key']),
                      child: SvgPicture.asset(
                        'assets/svg_icons/right.svg',
                        height: 60,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onLongPressStart: (_) {
                    if (_isLongPressMode) {
                      final value = _prefsData['mars_down_key'];
                      _startContinuousSending(value);
                    }
                  },
                  onLongPressEnd: (_) {
                    _stopContinuousSending();
                  },
                  onTap: () =>
                      _blueProvider.sendData(_prefsData['mars_down_key']),
                  child: SvgPicture.asset(
                    'assets/svg_icons/down.svg',
                    height: 60,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onLongPressStart: (_) {
                    if (_isLongPressMode) {
                      final value = _prefsData['mars_bottom_left_key'];
                      _startContinuousSending(value);
                    }
                  },
                  onLongPressEnd: (_) {
                    _stopContinuousSending();
                  },
                  onTap: () => _blueProvider
                      .sendData(_prefsData['mars_bottom_left_key']),
                  child: SvgPicture.asset(
                    'assets/svg_icons/left.svg',
                    height: 50,
                  ),
                ),
                GestureDetector(
                  onLongPressStart: (_) {
                    if (_isLongPressMode) {
                      final value = _prefsData['mars_bottom_right_key'];
                      _startContinuousSending(value);
                    }
                  },
                  onLongPressEnd: (_) {
                    _stopContinuousSending();
                  },
                  onTap: () => _blueProvider
                      .sendData(_prefsData['mars_bottom_right_key']),
                  child: SvgPicture.asset(
                    'assets/svg_icons/right.svg',
                    height: 50,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
