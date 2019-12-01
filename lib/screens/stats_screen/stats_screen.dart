/// Made by Adil Atalay Hamamcıoğlu (Recoskyler), 2019
/// Please check the GitHub Page for usage rights.
/// https://github.com/recoskyler/Budget
///

import 'package:budget/modules/components.dart';
import 'package:budget/modules/enums.dart';
import 'package:budget/modules/functions.dart';
import 'package:budget/modules/global.dart';
import 'package:budget/modules/settings.dart';
import 'package:budget/screens/stats_screen/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatsScreen extends StatefulWidget {
    StatsScreen({Key key}) : super(key: key);

    _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
    GlobalKey _statTopKey = GlobalKey();
    Size _size = new Size(0, 0);

    @override
    void initState() {
        WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
        super.initState();
    }

    _afterLayout(_) {
        setState(() {
            _size = getSize();
        });       
    }

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

    Size getSize() {
        final RenderBox renderBoxRed = _statTopKey.currentContext.findRenderObject();
        final Size _ressize = renderBoxRed.size;

        print(_ressize);
        
        return _ressize;
    }

    @override
    Widget build(BuildContext context) {
        List<Widget> _transactionCards = getTransactionCards(onTransactionItemClick, renewTransactions, renewFixedPayments);

        return Scaffold(
            appBar: appBarWithGradientTitle(lBase.titles.stats, 25, Colors.cyanAccent[400], Colors.cyan[800], themeColors[theme], 0.0, true, 'FiraCode', FontWeight.w400, 1.5),
            backgroundColor: themeColors[theme],
            body: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                    brokenWidget(),
                    Container(
                        margin: globalInset,
                        child: Column(
                            key: _statTopKey,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                                SizedBox(height: 20),
                                Divider(color: Colors.grey),
                                SizedBox(height: 20),
                                Text(
                                    lBase.subTitles.expenses,
                                    style: subTitle,
                                    textAlign: TextAlign.center
                                ),
                                Container(
                                    height: 150,
                                    child: SimpleTimeSeriesChart(generateList())
                                ),
                                SizedBox(height: 20),
                                Divider(color: Colors.grey),
                                SizedBox(height: 20),
                                Text(
                                    lBase.subTitles.utilities,
                                    style: subTitle,
                                    textAlign: TextAlign.center
                                ),
                                Container(
                                    height: 150,
                                    child: SimpleTimeSeriesChart(generateList(true))
                                ),
                                SizedBox(height: 20),
                                Divider(color: Colors.grey),
                                SizedBox(height: 20),
                                Text(
                                    lBase.subTitles.average,
                                    style: subTitle,
                                    textAlign: TextAlign.center
                                ),
                                SizedBox(height: 10),
                                Divider(color: Colors.grey),
                                SizedBox(height: 10),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                        children: [
                                            infoBlock(calculateTotalFromPayments([PaymentType.Withdraw, PaymentType.Subscription]) / getMonthCount(), currency, lBase.subTitles.avgExpenses, Colors.red, CrossAxisAlignment.start),
                                            infoBlock(calculateTotalFromPayment(PaymentType.PaidUtility, settings["rents"]) / getMonthCount(settings["rents"], settings["utilitiesDay"]), currency, lBase.subTitles.avgUtilities, Colors.indigoAccent[700], CrossAxisAlignment.end),
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    ),
                                ),
                                SizedBox(height: 10),
                                Divider(color: Colors.grey),
                                SizedBox(height: 20),
                                Text(
                                    lBase.subTitles.transactionHistory,
                                    style: subTitle
                                ),
                                SizedBox(height: 10),
                                Divider(color: Colors.grey),
                            ],
                        ),
                    ),
                    CarouselSlider(
                        height: 500,
                        autoPlay: false,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        initialPage: _transactionCards.length - 1,
                        items: _transactionCards
                    ),
                ],
            ),
        );
    }
}