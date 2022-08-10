import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Util {
  static const Color mainColor = Color.fromRGBO(0, 179, 141, 1);
  static const Color outlineColor = Colors.white;
  static const Color focusedOutlineColor = Colors.white;
  static double smallPhoneSize = 320;
  static double smallPadSize = 768;
  static double padSize = 1024;
  static double smallPhoneRate = .7;
  static double phoneRate = 1;
  static double smallPadRate = 1.3;
  static double padRate = 1.5;
  static SharedPreferences? sharedPreferences;

  static double responsiveSize(BuildContext context, double size) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= smallPhoneSize)
      return size * smallPhoneRate;
    else if (screenWidth <= smallPadSize)
      return size * phoneRate;
    else if (screenWidth <= padRate)
      return size * smallPadRate;
    else
      return size * padRate;
  }

  static Future<void> checkGPSPermission(BuildContext context,
      {Function? onGranted, Function? onFailed}) async {
    PermissionStatus status = await Permission.location.status;
    if (status.isGranted) {
      if (onGranted != null) {
        onGranted();
      }
    } else if (status.isDenied) {
      if (await Permission.location.request().isGranted) {
        if (onGranted != null) {
          onGranted();
        }
      }
    }
    if (status.isPermanentlyDenied ||
        status.isDenied ||
        status.isRestricted ||
        status.isLimited) {
      if (onFailed != null) {
        onFailed();
      } else {
        showPlatformDialog(
            context: context,
            builder: (_) => PlatformAlertDialog(
                    title: Text("GPS Permission".tr()),
                    content: Text(
                        'Request For GPS Permission For Scanning QR Code'.tr()),
                    actions: <Widget>[
                      PlatformDialogAction(
                        child: PlatformText("Deny".tr()),
                        onPressed: () => Navigator.pop(context),
                      ),
                      PlatformDialogAction(
                        child: PlatformText("Allow".tr()),
                        onPressed: () {
                          openAppSettings();
                          Navigator.pop(context);
                        },
                      ),
                    ]));
      }
    }
  }

  static Future<void> checkCameraPermission(BuildContext context,
      {Function? onGranted, Function? onFailed}) async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isGranted) {
      if (onGranted != null) {
        onGranted();
      }
    } else if (status.isDenied) {
      if (await Permission.camera.request().isGranted) {
        if (onGranted != null) {
          onGranted();
        }
      }
    } else if (status.isPermanentlyDenied) {
      if (onFailed != null) {
        onFailed();
      } else {
        showPlatformDialog(
            context: context,
            builder: (_) => PlatformAlertDialog(
                    title: Text("Camera Permission".tr()),
                    content: Text(
                        'Request For Camera Permission For Scanning QR Code'
                            .tr()),
                    actions: <Widget>[
                      PlatformDialogAction(
                        child: PlatformText("Deny".tr()),
                        onPressed: () => Navigator.pop(context),
                      ),
                      PlatformDialogAction(
                        child: PlatformText("Allow".tr()),
                        onPressed: () {
                          openAppSettings();
                          Navigator.pop(context);
                        },
                      ),
                    ]));
      }
    }
  }

  static double ratioHeight(BuildContext context, double ratio) {
    return MediaQuery.of(context).size.height * ratio;
  }

  static double ratioWidth(BuildContext context, double ratio) {
    return MediaQuery.of(context).size.width * ratio;
  }

  static String dateFormat(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static void showAlertDialog(BuildContext context, String content,
      {String? title, Function? onPress}) {
    showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
              title: Text(title ?? "Error").tr(),
              content: Text(content).tr(),
              actions: <Widget>[
                PlatformDialogAction(
                  child: PlatformText('Dismiss'.tr()),
                  onPressed: () {
                    if (onPress == null)
                      Navigator.pop(context);
                    else
                      onPress();
                  },
                ),
              ],
            ));
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Center(
              child: PlatformCircularProgressIndicator(),
            ),
          );
        });
  }

  static void showConfirmDialog(BuildContext context,
      {String title = "", String content = "", required VoidCallback onPress}) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text(title).tr(),
        content: Text(content).tr(),
        actions: <Widget>[
          PlatformDialogAction(
            material: (_, __) => MaterialDialogActionData(),
            cupertino: (_, __) => CupertinoDialogActionData(),
            child: PlatformText('Cancel'.tr()),
            onPressed: () => Navigator.pop(context),
          ),
          PlatformDialogAction(
            child: PlatformText('Confirm'.tr()),
            onPressed: () {
              Navigator.pop(context);
              onPress();
            },
          ),
        ],
      ),
    );
  }

  static Future<File> createFileFromString(
      String encodedStr, String ext) async {
    try {
      Uint8List bytes = base64.decode(encodedStr);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File("$dir/" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          "." +
          ext);
      return await file.writeAsBytes(bytes);
    } catch (e) {
      throw e;
    }
  }

  static String generateRandomString(int numCharacter) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    return String.fromCharCodes(Iterable.generate(
        numCharacter, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  static showToast(String text, Color? color, Color? fontColor) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: color ?? Util.mainColor,
        textColor: fontColor ?? Colors.white,
        fontSize: 16.0);
  }

  static hashPassword(String password) {
    return sha256.convert(utf8.encode(password));
  }

  static bool isAuthenticated() {
    return Util.sharedPreferences?.getObject("currentUser") != "";
  }

  static void clearUser() async {
    await Util.sharedPreferences?.setString("currentUser", "");
    await Util.sharedPreferences?.setString("token", "");
  }

  static void showModalSheet(BuildContext context, String title,
      Widget Function(BuildContext context, StateSetter setState) builder,
      {Widget? leading,
      Widget? actions,
      Color? colorTone,
      double height = 0.8}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (context) {
          return Wrap(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * height,
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Material(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Container(
                          height: Util.responsiveSize(context, 56.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              leading ??
                                  IconButton(
                                    icon: Icon(Icons.arrow_back,
                                        color: colorTone ?? Colors.blue),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                              Text(
                                title,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Util.responsiveSize(context, 20)),
                              ),
                              // Expanded(child: SizedBox()),
                              actions ??
                                  SizedBox(
                                    width: 24,
                                  ),
                            ],
                          ),
                        ),
                        // Text("Header"),
                        Expanded(child: builder(context, setState)),
                      ],
                    ),
                  );
                }),
              ),
            ],
          );
        });
  }
}

extension SharedPreferenceExtension on SharedPreferences {
  Future<bool> setObject(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, jsonEncode(value.toJson()));
  }

  Future<Map<String, dynamic>> getObject<T extends dynamic>(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(key) == null)
      throw Exception("Getting Null In SharedPreference");
    return jsonDecode(prefs.getString(key)!);
  }
}
