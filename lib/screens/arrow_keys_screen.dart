// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks

import 'package:bluetooth_arduino/app/shared_prefs.dart';
import 'package:bluetooth_arduino/screens/edit_keys_screens/arrow_key_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../app/constants.dart';
import '../provider.dart';

class ArrowKeysScreen extends StatefulWidget {
  const ArrowKeysScreen({super.key});

  @override
  State<ArrowKeysScreen> createState() => _ArrowKeysScreenState();
}

class _ArrowKeysScreenState extends State<ArrowKeysScreen> {
  late BlueProvider _blueProvider;

  @override
  void initState() {
    super.initState();
    _blueProvider = context.read<BlueProvider>();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _getKeyValues();
      },
    );
  }

  Map<String, dynamic> _prefsData = {};
  void _getKeyValues() async {
    final prefs = await SharedPrefsHelper().getData();
    if (prefs != null) {
      setState(() {
        _prefsData = prefs;
      });
    }
    print("##############################${_prefsData}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: buttonColor,
      appBar: AppBar(
        title: const Text('Arrow Keys'),
        titleSpacing: 0,
        actions: [
          IconButton(
              onPressed: () async {
                final result = await Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const ArrowKeysEditScreen();
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
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _blueProvider.sendData(_prefsData['up_key']),
              child: SvgPicture.asset(
                'assets/svg_icons/up.svg',
                height: 80,
              ),
            ),
            const SizedBox(height: defaultSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => _blueProvider.sendData(_prefsData['left_key']),
                  child: SvgPicture.asset(
                    'assets/svg_icons/left.svg',
                    height: 80,
                  ),
                ),
                const SizedBox(width: defaultSpacing),
                GestureDetector(
                  onTap: () => _blueProvider.sendData(_prefsData['right_key']),
                  child: SvgPicture.asset(
                    'assets/svg_icons/right.svg',
                    height: 80,
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultSpacing),
            GestureDetector(
              onTap: () => _blueProvider.sendData(_prefsData['down_key']),
              child: SvgPicture.asset(
                'assets/svg_icons/down.svg',
                height: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
