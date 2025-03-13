import 'package:bluetooth_arduino/app/constants2.dart';
import 'package:bluetooth_arduino/app/extensions.dart';
import 'package:flutter/material.dart';

import '../../app/shared_prefs.dart';
import '../../components/custom_textfiled.dart';

class ArrowKeysEditScreen extends StatefulWidget {
  const ArrowKeysEditScreen({super.key});

  @override
  State<ArrowKeysEditScreen> createState() => _ArrowKeysEditScreenState();
}

class _ArrowKeysEditScreenState extends State<ArrowKeysEditScreen> {
  Map<String, dynamic> _prefs = {};

  final TextEditingController _forwardController = TextEditingController();
  final TextEditingController _backwardController = TextEditingController();
  final TextEditingController _leftController = TextEditingController();
  final TextEditingController _rightController = TextEditingController();

  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

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
        _forwardController.text = _prefs['up_key'];
        _backwardController.text = _prefs['down_key'];
        _leftController.text = _prefs['left_key'];
        _rightController.text = _prefs['right_key'];
      });
    }
    print("##############################${_prefs}");
  }

  void _saveValues() async {
    // Create map with updated values
    Map<String, dynamic> updatedValues = {
      'up_key': _forwardController.text,
      'down_key': _backwardController.text,
      'left_key': _leftController.text,
      'right_key': _rightController.text,
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
    // Dispose controllers
    _forwardController.dispose();
    _backwardController.dispose();
    _leftController.dispose();
    _rightController.dispose();
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
