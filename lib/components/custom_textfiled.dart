// ignore_for_file: deprecated_member_use, unused_element

import 'package:flutter/material.dart';

import '../app/constants2.dart';
import '../app/validators.dart';

class CustomTextField extends StatefulWidget {
  final String? initialValue;
  final String? labelText, hintText;
  final TextEditingController? controller;
  final List<String? Function(String?)>? validators;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;
  final bool obscureText;
  final bool readOnly;
  final Function()? onTap;
  final Widget? prefixicon, suffixicon;
  final String? prefixText;
  final int? maxLines, maxLength;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final Color? color;
  final Gradient? gradient;
  final String? titleText;
  final double? width;
  final FocusNode? focusNode;
  const CustomTextField(
      {super.key,
      this.initialValue,
      this.labelText,
      this.hintText,
      this.controller,
      this.validators,
      this.onChanged,
      this.onSaved,
      this.obscureText = false,
      this.readOnly = false,
      this.textInputType = TextInputType.text,
      this.textInputAction = TextInputAction.next,
      this.onTap,
      this.prefixicon,
      this.suffixicon,
      this.prefixText,
      this.maxLines = 1,
      this.maxLength = 128,
      this.color,
      this.gradient,
      this.titleText,
      this.width,
      this.focusNode});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width ?? double.infinity,
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
            color: widget.color,
            gradient: widget.gradient,
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.titleText!,
              style: const TextStyle(
                  color: mBlackColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
            TextFormField(
              obscureText: widget.obscureText,
              keyboardType: widget.textInputType,
              readOnly: widget.readOnly,
              focusNode: widget.focusNode,
              initialValue: widget.initialValue,
              controller: widget.controller,
              onChanged: widget.onChanged,
              onSaved: widget.onSaved,
              onTap: widget.onTap,
              maxLines: widget.maxLines,
              textInputAction: widget.textInputAction,
              maxLength: widget.maxLength,
              style: const TextStyle(color: mBlackColor),
              validator: (value) => Validator.compose(value, widget.validators),
              decoration: InputDecoration(
                // filled: true,
                // fillColor: Colors.white.withOpacity(0.3),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                    color: mBlackColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
                //labelText: widget.labelText,
                prefixIcon: widget.prefixicon,
                suffixIcon: widget.suffixicon,
                suffixIconColor: mBlackColor,
                prefixText: widget.prefixText,
                prefixStyle: const TextStyle(color: mTitleColor, fontSize: 16),
                errorMaxLines: 2,
                counter: const SizedBox.shrink(),
              ),
            ),
          ],
        ));
  }
}

class OutlinedDropdown<T> extends StatelessWidget {
  final T? value;
  final String? labelText, hintText;
  final List<String? Function(String?)>? validators;
  final Function(T?)? onChanged;
  final Function(T?)? onSaved;
  final Function()? onTap;
  final Widget? prefixIcon, suffixIcon;
  final String? prefixText;
  final List<DropdownMenuItem<T>>? items;
  final Color? color;
  final Gradient? gradient;
  final String? titleText;
  final double? width;

  const OutlinedDropdown({
    super.key,
    this.value,
    this.labelText,
    this.hintText,
    this.validators,
    this.onChanged,
    this.onSaved,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.items,
    this.gradient,
    this.titleText,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    // Color selectedColor = (value != null) ? mWhiteColor : mBlackColor;
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleText!,
            style: TextStyle(
                color: mPrimaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 20),
          ),
          DropdownButtonFormField<T>(
            // dropdownColor: const Color(0xFF2B2C2E),
            value: value,
            validator: (value) {
              if (T == String) {
                return Validator.compose(value as String?, validators);
              }
              return null;
            },

            onChanged: onChanged,
            onSaved: onSaved,
            onTap: onTap,
            items: items,
            style: const TextStyle(color: mBlackColor, fontSize: 18),
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              hintStyle: const TextStyle(
                color: mHintTextColot,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              prefixText: prefixText,
              prefixStyle: const TextStyle(color: mTitleColor, fontSize: 16),
              errorMaxLines: 2,
              counter: const SizedBox.shrink(),
            ),
            isExpanded: true,
          ),
        ],
      ),
    );
  }
}

class CustomeOutlinedDropdownWithBorder<T> extends StatelessWidget {
  final T? value;
  final String? labelText, hintText;
  final List<String? Function(String?)>? validators;
  final Function(T?)? onChanged;
  final Function(T?)? onSaved;
  final Function()? onTap;
  final Widget? prefixIcon, suffixIcon;
  final String? prefixText;
  final List<DropdownMenuItem<T>>? items;
  final Color? color;
  final Gradient? gradient;
  final String? titleText;
  final double? width;
  const CustomeOutlinedDropdownWithBorder(
      {super.key,
      this.value,
      this.labelText,
      this.hintText,
      this.validators,
      this.onChanged,
      this.onSaved,
      this.onTap,
      this.prefixIcon,
      this.suffixIcon,
      this.prefixText,
      this.items,
      this.color,
      this.gradient,
      this.titleText,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleText!,
            style: const TextStyle(color: mTextColor2, fontSize: 18),
          ),
          DropdownButtonFormField<T>(
            // dropdownColor: const Color(0xFF2B2C2E),
            value: value,
            validator: (value) {
              if (T == String) {
                return Validator.compose(value as String?, validators);
              }
              return null;
            },
            onChanged: onChanged,
            onSaved: onSaved,
            onTap: onTap,
            items: items,
            style: const TextStyle(color: mBlackColor, fontSize: 18),
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              hintStyle: const TextStyle(
                color: mHintTextColot,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              prefixText: prefixText,
              prefixStyle: const TextStyle(color: mTitleColor, fontSize: 16),
              errorMaxLines: 2,
              counter: const SizedBox.shrink(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: mGreyColor, width: 1.0), // Reduced thickness
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: mGreyColor, width: 1), // Reduced thickness
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Colors.red, width: 1.0), // Reduced thickness
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Colors.red, width: 1), // Reduced thickness
              ),
            ),
            isExpanded: true,
          ),
        ],
      ),
    );
  }
}

class OutlinedTextField extends StatelessWidget {
  final String? initialValue;
  final String? labelText, hintText;
  final List<String? Function(String?)>? validators;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool readOnly;
  final Function()? onTap;
  final Widget? prefixIcon, suffixIcon;
  final String? prefixText;
  final int? maxLines, maxLength;
  final FocusNode? focusNode;
  final String? titleText;

  const OutlinedTextField({
    super.key,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.validators,
    this.onChanged,
    this.onSaved,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.maxLines = 1,
    this.maxLength = 128,
    this.focusNode,
    this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText!,
          style: const TextStyle(color: mBlackColor, fontSize: 20),
        ),
        TextFormField(
          initialValue: initialValue,
          focusNode: focusNode,
          keyboardType: textInputType,
          validator: (value) => Validator.compose(value, validators),
          onChanged: onChanged,
          onSaved: onSaved,
          obscureText: obscureText,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          textInputAction: textInputAction,
          maxLength: maxLength,
          style: TextStyle(color: mPrimaryColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.3),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            hintText: hintText,
            hintStyle: TextStyle(color: mPrimaryColor),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            prefixText: prefixText,
            prefixStyle: const TextStyle(color: mBlackColor, fontSize: 16),
            errorMaxLines: 2,
            counter: const SizedBox.shrink(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: mGreyColor, width: 1.0), // Reduced thickness
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: mGreyColor, width: 1.5), // Reduced thickness
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: Colors.red, width: 1.0), // Reduced thickness
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: Colors.red, width: 1.5), // Reduced thickness
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTextFieldWithBorder extends StatefulWidget {
  final String? initialValue;
  final String? labelText, hintText;
  final TextEditingController? controller;
  final List<String? Function(String?)>? validators;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;
  final bool obscureText;
  final bool readOnly;
  final Function()? onTap;
  final Widget? prefixicon, suffixicon;
  final String? prefixText;
  final int? maxLines, maxLength;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final Color? color;
  final Gradient? gradient;
  final String? titleText;
  final double? width;
  final FocusNode? focusNode;
  const CustomTextFieldWithBorder(
      {super.key,
      this.initialValue,
      this.labelText,
      this.hintText,
      this.controller,
      this.validators,
      this.onChanged,
      this.onSaved,
      this.obscureText = false,
      this.readOnly = false,
      this.textInputType = TextInputType.text,
      this.textInputAction = TextInputAction.next,
      this.onTap,
      this.prefixicon,
      this.suffixicon,
      this.prefixText,
      this.maxLines = 1,
      this.maxLength = 128,
      this.color,
      this.gradient,
      this.titleText,
      this.width,
      this.focusNode});

  @override
  State<CustomTextFieldWithBorder> createState() =>
      _CustomTextFieldWithBorderState();
}

class _CustomTextFieldWithBorderState extends State<CustomTextFieldWithBorder> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width ?? double.infinity,
        decoration: BoxDecoration(
            color: widget.color,
            gradient: widget.gradient,
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.titleText!,
              style: const TextStyle(color: mTextColor2, fontSize: 18),
            ),
            SizedBox(height: 8),
            TextFormField(
              readOnly: widget.readOnly,
              focusNode: widget.focusNode,
              initialValue: widget.initialValue,
              controller: widget.controller,
              obscureText: widget.obscureText,
              onChanged: widget.onChanged,
              keyboardType: widget.textInputType,
              onSaved: widget.onSaved,
              onTap: widget.onTap,
              maxLines: widget.maxLines,
              textInputAction: widget.textInputAction,
              maxLength: widget.maxLength,
              style: const TextStyle(color: mBlackColor),
              validator: (value) => Validator.compose(value, widget.validators),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                    color: mHintTextColot,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
                prefixIcon: widget.prefixicon,
                suffixIcon: widget.suffixicon,
                prefixText: widget.prefixText,
                prefixStyle: const TextStyle(color: mTitleColor, fontSize: 16),
                errorMaxLines: 2,
                counter: const SizedBox.shrink(),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: mGreyColor, width: 1.0), // Reduced thickness
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: mGreyColor, width: 1.5), // Reduced thickness
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: Colors.red, width: 1.0), // Reduced thickness
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: Colors.red, width: 1.5), // Reduced thickness
                ),
              ),
            ),
          ],
        ));
  }
}
