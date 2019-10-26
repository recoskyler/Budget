import 'package:budget/generated/locale_base.dart';
import 'package:budget/modules/global.dart';
import 'package:budget/modules/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen/home_screen.dart';
import 'modules/settings.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
    
    // For different size displays
    // If not used, UI may vary from device to device.
    // Can't say I understand this concept clearly, nor I'm able to use it properly :/

    static MediaQueryData _mediaQueryData;
    static double screenWidth;
    static double screenHeight;
    static double blockSizeHorizontal;
    static double blockSizeVertical;
    static double _safeAreaHorizontal;
    static double _safeAreaVertical;
    static double safeBlockHorizontal;
    static double safeBlockVertical;

    void init(BuildContext context) {
        _mediaQueryData = MediaQuery.of(context);
        screenWidth = _mediaQueryData.size.width;
        screenHeight = _mediaQueryData.size.height;
        blockSizeHorizontal = screenWidth / 100;
        blockSizeVertical = screenHeight / 100;
        _safeAreaHorizontal = _mediaQueryData.padding.left + 
        _mediaQueryData.padding.right;
        _safeAreaVertical = _mediaQueryData.padding.top +
        _mediaQueryData.padding.bottom;
        safeBlockHorizontal = (screenWidth -
        _safeAreaHorizontal) / 100;
        safeBlockVertical = (screenHeight -
        _safeAreaVertical) / 100;
    }
}

void main() async {
    lBase = LocaleBase();
    
    settingsStorage = await SharedPreferences.getInstance();

    if (!settingsStorage.containsKey("lang")) {
        settingsStorage.setString("lang", "locale/EN_US.json");
    }

    await lBase.load(settingsStorage.getString("lang"));
    
    loadSettings();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) { // Force Portrait orientation
        return runApp(new App());
    });
}