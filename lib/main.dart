import 'package:admob_flutter/admob_flutter.dart';
/// Made by Adil Atalay Hamamcıoğlu (Recoskyler), 2019
/// Please check the GitHub Page for usage rights.
/// https://github.com/recoskyler/Budget
///
///ca-app-pub-3535033684460003~8165291019

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

        globalInsetPercent = 25;
        buttonTextSize = SizeConfig.safeBlockHorizontal * 4.2;
        regularTextSize = SizeConfig.safeBlockHorizontal * 4.3;
        subTitleTextSize = SizeConfig.safeBlockHorizontal * 4.5;
        amountPercentSize = 8;
        amountTextSize = SizeConfig.safeBlockHorizontal * 7;
        smolTextSize = SizeConfig.safeBlockHorizontal * 3;
    }
}

void main() {
    WidgetsFlutterBinding.ensureInitialized();
    Admob.initialize("ca-app-pub-3535033684460003~8165291019");
    //TestWidgetsFlutterBinding.ensureInitialized();

    SharedPreferences.getInstance().then((SharedPreferences _sp) {
        settingsStorage = _sp;

        if (!settingsStorage.containsKey("lang")) {
            settingsStorage.setInt("lang", 0);
        }

        lBase.load(languageLocales[settingsStorage.getInt("lang")]).then((_) {
            loadSettings();

            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) { // Force Portrait orientation
                return runApp(new App());
            });
        });
    });
}