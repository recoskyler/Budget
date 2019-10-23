import 'functions.dart';
import 'dart:convert';
import 'classes.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Map<String, dynamic> defaultPrefs = const {
    "lastSaved" : "2019",
    "username" : "",
    "email" : "",
    "keyIndex" : 0,
    "monthlyAllowence" : 0.0,
    "budgetRenewalDay" : 1,
    "rentAmount" : 0.0,
    "utilitiesDay" : 1,
    "rentDay" : 1,
    "rentStartDate" : "",
    "transactionDescriptions" : ["Food", "Drink", "Groceries", "Tech", "Top-Up", "Clothes", "Makeup", "Cinema", "Travel", "Hotel", "Game", "App", "Other"],
    "currency" : "€",
    "transactions" : [],
    "rents" : [],
    "fixedPayments" : [],
    "rentPage" : 0,
    "firstTime" : true,
    "theme" : 0
};

SharedPreferences settingsStorage;
Map<String, dynamic> settings = Map<String, dynamic>.from(defaultPrefs);

bool checkSettings() {
    Map _defTemp = Map.from(defaultPrefs);

    defaultPrefs.forEach((_key, _val) {
        if (!settings.containsKey(_key)) {
            settings[_key] = _defTemp[_key];
        }
    });

    saveSettings();

    print("Checked and saved settings");

    return true;
}

Future<bool> resetSettings([bool _keepFirstState = true]) async {
    print("Resetting ...");

    bool _fs = true;

    if (settings.containsKey("firstTime"))
        _fs = settings["firstTime"];

    settings = Map.from(defaultPrefs);
    settings["firstTime"] = _keepFirstState ? _fs : false;

    await saveSettings();

    return true;
}

Future<bool> saveSettings() async {
    try {
        settings["lastSaved"] = DateTime.now().toString();

        List<Payment> _t = List<Payment>.from(settings["transactions"]);
        _t = orderByDateDescending(_t);

        settings["transactions"] = _t;

        /*
        writeToFile(settingsFile, jsonEncode(settings)).then((File _f) {
            print("Saved ...");
        });
        */

        bool _res = await settingsStorage.setString("settings", jsonEncode(settings));

        return _res;
    } catch (e) {
        print("SETTINGS.DART SAVE SETTINGS ERROR :\n" + e.toString());
        return false;
    }
}

void loadSettings([Function _f]) {
    try {
        String _s = settingsStorage.getString("settings");

        if (_s == null || _s == "" || _s == "{}") {
            resetSettings(false).then((_v) {return true;});
        }

        settings = jsonDecode(_s);

        if (settings.toString() == "{}") resetSettings();

        // Transactions

        List<dynamic> _sm = List.from(settings["transactions"]);
        List<Payment> _sp = new List<Payment>();

        _sm.forEach((_p) {
            _sp.add(Payment.fromJSON(_p));
            //print(_p.toString());
        });

        _sp = orderByDateDescending(_sp);

        settings["transactions"] = _sp;

        // Rental

        _sm = List.from(settings["rents"]);
        _sp = new List<Payment>();

        _sm.forEach((_p) {
            _sp.add(Payment.fromJSON(_p));
            //print(_p.toString());
        });

        settings["rents"] = _sp;

        // Fixed Payments

        _sm = List.from(settings["fixedPayments"]);
        _sp = new List<Payment>();

        _sm.forEach((_p) {
            _sp.add(Payment.fromJSON(_p));
            //print(_p.toString());
        });

        settings["fixedPayments"] = _sp;

        //print(settings.toString());
        print("Loaded Settings");
        print("Checking Settings ...");
        checkSettings();

        refreshStats();
        if (_f != null) _f(settings);
    } catch (e) {
        print("SETTINGS.DART LOAD SETTINGS ERROR :\n" + e.toString());
    }
}