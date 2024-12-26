import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_garden_app/common/widgets/buttons/small_button.dart';
import 'package:smart_garden_app/utils/constants/api_constants.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';

class SettingsController extends GetxController {
  var isDarkMode = false.obs;
  var isSoundEnabled = true.obs;
  var esp32IpAddress = ''.obs;


  @override
  void onInit() {
    super.onInit();
    loadEsp32Ip();
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleSound(bool value) {
    isSoundEnabled.value = value;
  }

  Future<void> loadEsp32Ip() async {
    final prefs = await SharedPreferences.getInstance();
    esp32IpAddress.value = prefs.getString(Constant.ESP32_IP_KEY) ?? '';
  }

  Future<void> saveEsp32Ip(String newIp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constant.ESP32_IP_KEY, newIp);
    esp32IpAddress.value = newIp;
  }

  void showIpEditDialog(BuildContext context) {
    final TextEditingController textController = TextEditingController(text: esp32IpAddress.value);

    Get.dialog(
      AlertDialog(
        title: const Text('Edit ESP32 IP Address'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            labelText: 'IP Address',
            hintText: 'Enter ESP32 IP Address',
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SmallButton(
                onPressed: () => Get.back(),
                text: "Cancel",
                textColor: TColor.primary,
                backgroundColor: Colors.transparent,
              ),
              SizedBox(width: TSize.spaceBetweenItemsMd,),

              SmallButton(
                onPressed: () {
                  saveEsp32Ip(textController.text);
                  Get.back();
                },
                text: 'Save',
              ),
            ],
          )
        ],
      ),
    );
  }
}