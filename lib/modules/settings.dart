import 'functions.dart';
import 'global.dart';
import 'dart:convert';
import 'dart:io';
import 'classes.dart';

final GlobalFileHandler global = new GlobalFileHandler();

var settings = {};

const defaultPrefs = const {
    "lastSaved" : "2002-02-02",
    "username" : "",
    "email" : "",
    "keyIndex" : 0,
    "monthlyAllowence" : 0.0,
    "budgetRenewalDay" : 1,
    "rentAmount" : 0.0,
    "utilitiesDay" : 1,
    "rentDay" : 1,
    "rentStartDate" : "2019-02-02",
    "transactionDescriptions" : ["Food", "Drink", "Groceries", "Tech", "Top-Up", "Clothes", "Makeup", "Cinema", "Travel", "Hotel", "Game", "App", "Other"],
    "notifications" : [],
    "currency" : "€",
    "transactions" : [],
    "rentPage" : 0,
    "firstTime" : true,
    "theme" : 0
};

void checkSettings() {
    Map _defTemp = Map.from(defaultPrefs);

    defaultPrefs.forEach((_key, _val) {
        if (!settings.containsKey(_key)) {
            settings[_key] = _defTemp[_key];
        }
    });

    saveSettings();

    print("Checked and saved settings");
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

        global.writeToFile(global.settingsFile, jsonEncode(settings)).then((File _f) {
            print("Saved ...");
        });
    } catch (e) {
        print("SETTINGS.DART SAVE SETTINGS ERROR :\n" + e.toString());
        return false;
    }

    return true;
}

Future<bool> loadSettings() async {
    try {
        await global.readFromFile(global.settingsFile).then((String _s) {
            if (_s == null || _s == "" || _s == "{}") {
                global.writeToFile(global.settingsFile, "").then((File _f) {
                    resetSettings(false).then((_v) {return true;});
                });
            }

            settings = jsonDecode(_s);

            if (settings.toString() == "{}") resetSettings();

            List<dynamic> _sm = List.from(settings["transactions"]);
            List<Payment> _sp = new List<Payment>();

            _sm.forEach((_p) {
                _sp.add(Payment.fromJSON(_p));
                print(_p.toString());
            });

            _sp = orderByDateDescending(_sp);

            settings["transactions"] = _sp;

            print(settings.toString());
            print("Loaded Settings");
            print("Checking Settings ...");
            checkSettings();

            return true;
        });
    } catch (e) {
        print("SETTINGS.DART LOAD SETTINGS ERROR :\n" + e.toString());
        return false;
    }

    return false;
}