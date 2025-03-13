import 'package:bluetooth_arduino/app/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/constants2.dart';
import '../../app/shared_prefs.dart';
import '../../components/custom_textfiled.dart';

class MarsRoverEditScreen extends StatefulWidget {
  const MarsRoverEditScreen({super.key});

  @override
  State<MarsRoverEditScreen> createState() => _MarsRoverEditScreenState();
}

class _MarsRoverEditScreenState extends State<MarsRoverEditScreen> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _prefs = {};

  final TextEditingController _forwardController = TextEditingController();
  final TextEditingController _backwardController = TextEditingController();
  final TextEditingController _leftController = TextEditingController();
  final TextEditingController _rightController = TextEditingController();
  final TextEditingController _middleController = TextEditingController();
  final TextEditingController _topLeftController = TextEditingController();
  final TextEditingController _topRightController = TextEditingController();
  final TextEditingController _bottomLeftController = TextEditingController();

  final TextEditingController _bottomRightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _getKeyValues();
      },
    );
  }

  void _getKeyValues() async {
    final prefs = await SharedPrefsHelper().getData();
    if (prefs != null) {
      setState(() {
        _prefs = prefs;
        _forwardController.text = _prefs['mars_up_key'];
        _backwardController.text = _prefs['mars_down_key'];
        _leftController.text = _prefs['mars_left_key'];
        _rightController.text = _prefs['mars_right_key'];
        _topLeftController.text = _prefs['mars_top_left_key'];
        _topRightController.text = _prefs['mars_top_right_key'];
        _bottomLeftController.text = _prefs['mars_bottom_left_key'];
        _bottomRightController.text = _prefs['mars_bottom_right_key'];
        _middleController.text = _prefs['mars_middle_key'];
      });
    }
    print("##############################${_prefs}");
  }

  void _saveValues() async {
    // Create map with updated values
    Map<String, dynamic> updatedValues = {
      'mars_up_key': _forwardController.text,
      'mars_down_key': _backwardController.text,
      'mars_left_key': _leftController.text,
      'mars_right_key': _rightController.text,
      'mars_middle_key': _middleController.text,
      'mars_top_left_key': _topLeftController.text,
      'mars_top_right_key': _topRightController.text,
      'mars_bottom_left_key': _bottomLeftController.text,
      'mars_bottom_right_key': _bottomRightController.text,
    };

    // Save to SharedPreferences
    bool saved = await SharedPrefsHelper().saveData(updatedValues);
    if (saved) {
      if (mounted) {
        context.showMessage('Saved successfully');
        Navigator.pop(context, true);
      }
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Dispose controllers
    _forwardController.dispose();
    _backwardController.dispose();
    _leftController.dispose();
    _rightController.dispose();
    _middleController.dispose();
    _topLeftController.dispose();
    _topRightController.dispose();
    _bottomLeftController.dispose();
    _bottomRightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        title: const Text('Customize values'),
        actions: [
          TextButton(
            onPressed: () {
              _saveValues();
            },
            child: const Text(
              'Save',
              style: TextStyle(color: mWhiteColor, fontSize: 20),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                titleText: 'Up Key',
                controller: _forwardController,
                onSaved: (value) {
                  setState(() {
                    _forwardController.text = value!;
                  });
                },
              ),
              CustomTextField(
                titleText: 'Down Key',
                controller: _backwardController,
                onSaved: (value) {
                  setState(() {
                    _backwardController.text = value!;
                  });
                },
              ),
              CustomTextField(
                titleText: 'Left Key',
                controller: _leftController,
                onSaved: (value) {
                  setState(() {
                    _leftController.text = value!;
                  });
                },
              ),
              CustomTextField(
                titleText: 'Right Key',
                controller: _rightController,
                onSaved: (value) {
                  setState(() {
                    _rightController.text = value!;
                  });
                },
              ),
              CustomTextField(
                titleText: 'Stop Key',
                controller: _middleController,
                onSaved: (value) {
                  setState(() {
                    _middleController.text = value!;
                  });
                },
              ),
              CustomTextField(
                titleText: 'Top Left Key',
                controller: _topLeftController,
                onSaved: (value) {
                  setState(() {
                    _topLeftController.text = value!;
                  });
                },
              ),
              CustomTextField(
                titleText: 'Top Right Key',
                controller: _topRightController,
                onSaved: (value) {
                  setState(() {
                    _topRightController.text = value!;
                  });
                },
              ),
              CustomTextField(
                titleText: 'Bottom Left Key',
                controller: _bottomLeftController,
                onSaved: (value) {
                  setState(() {
                    _bottomLeftController.text = value!;
                  });
                },
              ),
              CustomTextField(
                titleText: 'Bottom Right Key',
                controller: _bottomRightController,
                onSaved: (value) {
                  setState(() {
                    _bottomRightController.text = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
