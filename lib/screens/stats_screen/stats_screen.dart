import 'package:budget/main.dart';
import 'package:budget/modules/components.dart';
import 'package:budget/modules/enums.dart';
import 'package:budget/modules/functions.dart';
import 'package:budget/modules/global.dart';
import 'package:budget/modules/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';

class StatsScreen extends StatefulWidget {
    StatsScreen({Key key}) : super(key: key);

    _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: appBarWithGradientTitle("STATS", 25, Colors.cyanAccent[400], Colors.cyan[800], themeColors[theme], 0.0, true, 'FiraCode', FontWeight.w400, 1.5),
            backgroundColor: themeColors[theme],
            body: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                            infoBlock(calculateTotalFromPayment(PaymentType.Withdraw) / getMonthCount(), currency, "AVERAGE EXPENSES", Colors.red, CrossAxisAlignment.start),
                            SizedBox(height: 30),
                            infoBlock(calculateTotalFromPayment(PaymentType.PaidUtility) / getMonthCount(settings["rents"], settings["utilitiesDay"]), currency, "AVERAGE UTILITIES", Colors.indigoAccent[700], CrossAxisAlignment.start)
                        ],
                    ),
                ],
            ),
        );
    }
}