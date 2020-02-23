/// Made by Adil Atalay Hamamcıoğlu (Recoskyler), 2019
/// Please check the GitHub Page for usage rights.
/// https://github.com/recoskyler/Budget
///

import 'package:budget/generated/locale_base.dart';
import 'package:flutter/material.dart';
import 'functions.dart';

// For the old code down below
//
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';

int selectedNavMenu = 0;  // Navigation menu/page
int buttonStateIndex = 0; // For the BUDGET screen floating action button.
int selectedID = -1;      // Budget screen selected transaction item ID
int selectedIDStats = -1; // Stats screen selected transaction item ID
int selectedSubID = -1;   // Subs screen selected transaction item ID
var buttonStates = [[Icon(Icons.add), Icon(Icons.close)], [Colors.greenAccent[400], Colors.redAccent[400]]]; // For the BUDGET screen floating action button.
double expense = calculateExpenses();
double subexpense = calculateExpenses(true);
double budget = calculateAllowence();
double savings = calculateTotalSavings();
String currency = "";
String adUID = "ca-app-pub-3535033684460003/4034474319";
int rentPage = -1;        // Rent screen selected card index
int theme = 0;            // 0 - Light : 1 - Dark
LocaleBase lBase = LocaleBase();
int foobar = 0; // just a variable to update state when asyn functions used

List<String> currencies = ['€', '\$', '£', '¥', '₩', '₺', ' '];

// * STYLES

double globalInsetPercent;
double buttonTextSize;
double regularTextSize;
double subTitleTextSize;
double amountPercentSize = 8;
double amountTextSize;
double smolTextSize;
EdgeInsets globalInset = new EdgeInsets.fromLTRB(globalInsetPercent, 0, globalInsetPercent, 0);

List<Color> themeColors = [
    Colors.grey[50],
    Colors.black,
];

List<Color> navBarColors = [
    Colors.grey[100],
    Colors.grey[900],
];

List<Color> selectedItemColors = [
    Colors.blueGrey[100],
    Colors.blueGrey[900]
];

List<Color> dimTextColors = [
    Colors.grey[500],
    Colors.grey[800]
];

List<Color> textColors = [
    Colors.grey[800],
    Colors.grey[500]
];

List<Color> dayButtonColors = [
    Colors.red[50],
    Colors.redAccent[100]
];

List<Color> dayButtonTextColors = [
    Colors.redAccent[400],
    Colors.redAccent[700]
];

TextStyle subTitle = new TextStyle(
    color: textColors[theme],
    fontFamily: "Montserrat",
    fontSize: subTitleTextSize,
    fontWeight: FontWeight.w300
);

TextStyle regular = new TextStyle(
    color: textColors[theme],
    fontSize: regularTextSize,
    fontFamily: "Montserrat",
);

TextStyle dim = new TextStyle(
    color: dimTextColors[theme],
    fontSize: regularTextSize,
    fontFamily: "Montserrat",
);

TextStyle tfHintStyle = new TextStyle(
    color: Colors.red,
    fontSize: smolTextSize,
    fontFamily: "FiraCode",
);

// * DESC/LANG

List<String> transactionDescriptions;
List<String> monthNames;

List<String> languages = [
    "English",
    "Türkçe"
];

List<String> languageLocales = [
    "locales/EN.json",
    "locales/TR.json"
];

//
// Old code, implemented 'shared_preferences' package instead
//
/*
final String settingsFileName = "settings.json";
final String expensesFileName = "expenses.json";
final String incomesFileName = "incomes.json";
final String fixedExpensesFileName = "fixedExpenses.json";
final String fixedIncomesFileName = "fixedIncomes.json";
String directory;
Directory dir;

Future<String> get _localPath async {
    dir = await getApplicationDocumentsDirectory();
    directory = dir.path;
    return directory;
}

Future<File> get settingsFile async {
    final path = await _localPath;
    return File('$path/$settingsFileName');
}

Future<File> writeToFile(Future<File> futureFile, String context) async {
    final file = await futureFile;
    return file.writeAsString(context);
}

Future<String> readFromFile(Future<File> futureFile) async {
    try {
        final file = await futureFile;

        // Read the file.
        String contents = await file.readAsString();

        return contents;
    } catch (e) {
        return "";
    }
}
*/