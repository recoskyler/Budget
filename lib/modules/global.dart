import 'dart:io';
import 'package:budget/screens/stats_screen/stats_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'functions.dart';

var expenseList = new List(0);
var incomeList = new List(0);
int selectedNavMenu = 0;
int buttonStateIndex = 0;
int selectedID = -1;
int selectedSubID = -1;
var buttonStates = [[Icon(Icons.add), Icon(Icons.close)], [Colors.greenAccent[400], Colors.redAccent[400]]];
double expense = calculateExpenses();
double subexpense = calculateExpenses(true);
double budget = calculateAllowence();
double savings = calculateTotalSavings();
String currency = "";
int rentPage = -1;
int theme = 0;

void openStats(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => StatsScreen()));
}

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
    Colors.grey[600]
];

class GlobalFileHandler {
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

    Future<File> get expensesFile async {
        final path = await _localPath;
        return File('$path/$expensesFileName');
    }

    Future<File> get incomesFile async {
        final path = await _localPath;
        return File('$path/$incomesFileName');
    }

    Future<File> get fixedExpensesFile async {
        final path = await _localPath;
        return File('$path/$fixedExpensesFileName');
    }

    Future<File> get fixedIncomesFile async {
        final path = await _localPath;
        return File('$path/$fixedIncomesFileName');
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
}