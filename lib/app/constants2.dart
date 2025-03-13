import 'package:flutter/material.dart';

const mBackgroundColor = Color(0xFF030E1E);
const mBlueColor = Color(0xFF006df0);
const mGreyColor = Color(0xFFB4B0B0);
const mGreyColor2 = Color(0xFFD9D9D9);
const mTitleColor = Color(0xFF23374D);
const mSubtitleColor = Color(0xFF8E8E8E);
const mBorderColor = Color(0xFFE8E8F3);
const mFillColor = Color(0xffF1F0F5);
const mFillColor2 = Color(0xfff2f2f2);
const mCardTitleColor = Color(0xFF2E4ECF);
const mCardSubtitleColor = mTitleColor;

// const mTextColor = Color(0xFFBE1335);
const mTextColor2 = Color(0xFF504F4F);
const mHintTextColot = Color(0xFF5A6881);

const Color mBlackColor = Colors.black;
const Color mWhiteColor = Colors.white;

const Color mTransparent = Colors.transparent;

const mLightPrimaryColor = Color(0xFFf6f6f6);
Color mPrimaryColor = Color(0xFFBE1335);
const mSecondaryColor = Color(0xffaf0003);
const mSuccessColor = Color(0xff20923D);
const mErrorColor = Color(0xffE50001);
const mPendingColor = Colors.orange;

const mBoxShadow = [
  BoxShadow(
    color: Color(0XFFE0E0E0),
    blurRadius: 2,
    spreadRadius: 0.1,
    offset: Offset(0.0, 2.0),
  ),
];

const double defaultPadding = 16;
const double defaultSpacing = 16;

Gradient universalGradient =
    LinearGradient(colors: [Color(0xFFBE1335), Color(0xFF2C1938)]);

const bgColor1 = Color(0xFFf5e6fd);
const bgColor2 = Color(0xFFe3f8fb);
const bgColor3 = Color(0xFFfee5e1);
const bgColor4 = Color(0xFFe2e8ff);
const bgColor5 = Color(0xFFE7E8ED);

const fgColor1 = Color(0xFFbd63fc);
const fgColor2 = Color(0xFF23c6d4);
const fgColor3 = Color(0xFFfe573c);
const fgColor4 = Color(0xFF6c76c4);

const darkColor1 = Color(0xFF03399c);
const darkColor2 = Color(0xFF201d47);
const darkColor3 = Color(0xFF06617d);
const darkColor4 = Color(0xFF102230);

final RegExp emailValidatorRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp pswdValidatorRegExp =
    RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$');
final RegExp phoneValidatorRegExp = RegExp(r'^\d{10}$');
final RegExp otpValidatorRegExp = RegExp(r'^\d{6}$');
final RegExp panValidatorRegExp = RegExp(r"^[A-Z]{5}[0-9]{4}[A-Z]{1}$");
final RegExp gstValidatorRegExp =
    RegExp(r"^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$");

const String rupeeSymbol = "\u{20B9}";

String appVersion = '1.0.10+1';
String selectedEmail = '';
bool isUseridLogin = false;
