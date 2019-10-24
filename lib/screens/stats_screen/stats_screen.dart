import 'package:budget/modules/components.dart';
import 'package:budget/modules/enums.dart';
import 'package:budget/modules/functions.dart';
import 'package:budget/modules/global.dart';
import 'package:budget/modules/settings.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class StatsScreen extends StatefulWidget {
    StatsScreen({Key key}) : super(key: key);

    _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
    void onTransactionItemClick(int id) {
        if (selectedID == id) {
            setState(() {
                selectedID = -1;
            });
        } else {
            setState(() {
                selectedID = id;
            });
        }
    }

    void renewTransactions(List<dynamic> _pt) {
        setState(() {
            refreshStats();
            settings["transactions"] = _pt;
        });

        saveSettings();
    }

    void renewFixedPayments(List<dynamic> _pt) {
        setState(() {
            refreshStats();
            settings["fixedPayments"] = _pt;
            selectedID = -1;
        });

        saveSettings();
    }

    @override
    Widget build(BuildContext context) {
        List<Widget> _transactionCards = getTransactionCards(onTransactionItemClick, renewTransactions, renewFixedPayments);

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
                            Container(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                    children: [
                                        infoBlock(calculateTotalFromPayments([PaymentType.Withdraw, PaymentType.Subscription]) / getMonthCount(), currency, "AVG EXPENSES", Colors.red, CrossAxisAlignment.start),
                                        infoBlock(calculateTotalFromPayment(PaymentType.PaidUtility, settings["rents"]) / getMonthCount(settings["rents"], settings["utilitiesDay"]), currency, "AVG UTILITIES", Colors.indigoAccent[700], CrossAxisAlignment.end),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                ),
                            ),
                            SizedBox(height: 20),
                            Divider(color: Colors.grey),
                            SizedBox(height: 20),
                            Text(
                                " TRANSACTION HISTORY",
                                style: TextStyle(
                                    color: textColors[theme],
                                    fontFamily: "Montserrat",
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w300
                                )
                            ),
                            SizedBox(height: 10),
                            Divider(color: Colors.grey),
                            CarouselSlider(
                                height: 450,
                                autoPlay: false,
                                enableInfiniteScroll: false,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                                initialPage: _transactionCards.length - 1,
                                items: _transactionCards
                            ),
                        ],
                    ),
                ],
            ),
        );
    }
}