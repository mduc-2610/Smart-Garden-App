import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/constants/enums.dart';
import 'package:smart_garden_app/utils/constants/icon_strings.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';
import 'package:smart_garden_app/utils/device/device_utility.dart';

class CSnackBar {
  static Flushbar? _currentFlushbar;

  static void show({
    required BuildContext context,
    required String message,
    required SnackBarType snackBarType,
    int duration = 2,
  }) {
    _currentFlushbar?.dismiss();
    _currentFlushbar = Flushbar(
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: TDeviceUtil.getScreenWidth() * 0.05
      ),
      messageText: Text(
        message,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: TColor.light),
      ),
      backgroundColor: _getFlushbarColor(snackBarType),
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      margin: EdgeInsets.only(
        top: kToolbarHeight,
        left: TDeviceUtil.getScreenWidth() * 0.05,
        right: TDeviceUtil.getScreenWidth() * 0.05,
      ),
      borderRadius: BorderRadius.circular(TSize.borderRadiusMd),
      duration: Duration(seconds: duration),
      isDismissible: true,
      icon: Icon(
        _getFlushbarIcon(snackBarType),
        color: TColor.light,
      ),
      shouldIconPulse: true,
    )..show(context);
  }

  static Color _getFlushbarColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return TColor.success;
      case SnackBarType.error:
        return TColor.error;
      case SnackBarType.info:
        return TColor.info;
      default:
        return TColor.warning;
    }
  }

  static IconData _getFlushbarIcon(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return TIcon.checkCircle;
      case SnackBarType.error:
        return TIcon.error;
      case SnackBarType.info:
        return TIcon.info;
      default:
        return TIcon.warning;
    }
  }
}
