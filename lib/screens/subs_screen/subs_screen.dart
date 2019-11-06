import 'package:budget/modules/enums.dart';
import 'package:budget/modules/functions.dart';
import 'package:budget/modules/settings.dart';
import 'package:flutter/material.dart';
import '../../modules/components.dart';
import '../../modules/global.dart';

PreferredSizeWidget subsHead() {
    return appBarWithGradientTitle(
        lBase.titles.fixedPayments, 
        25, 
        Colors.redAccent[400], 
        Colors.red[900], 
        themeColors[theme], 
        0.0, 
        true, 
        'FiraCode', 
        FontWeight.w400, 
        1.5
    );
}

class SubsScreen extends StatefulWidget {
    final Function onTransactionItemClick;
    final Function renewTransactions;
    final Function openEditPage;

    SubsScreen({Key key, this.onTransactionItemClick, this.renewTransactions, this.openEditPage}) : super(key: key);

    @override
    SubsScreenState createState() => SubsScreenState();
}

class SubsScreenState extends State<SubsScreen> {
    @override
	Widget build(BuildContext context) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                Divider(),
                SizedBox(height: 20),
                Row(
                    children: [
                        Expanded(child: infoBlock(budget, currency, lBase.subTitles.budget, Colors.greenAccent[700], CrossAxisAlignment.start, 0)),
                        Expanded(child: infoBlock(subexpense, currency, lBase.subTitles.fixedExpenses, Colors.red, CrossAxisAlignment.end)),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                ),
                SizedBox(height: 30),
                Row(
                    children: [
                        Expanded(child: infoBlock(calculateTotalFromPayment(PaymentType.FixedSavingDeposit, settings["fixedPayments"]), currency, lBase.subTitles.monthlySavings, Colors.amber[800], CrossAxisAlignment.start, 0)),
                        Expanded(child: infoBlock(budget - subexpense, currency, lBase.subTitles.remaining, budget - subexpense >= 0 ? Colors.blueAccent[700] : Colors.redAccent[700], CrossAxisAlignment.end)),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                ),
                SizedBox(height: 20),
                Divider(color: Colors.grey),
                SizedBox(height: 20),
                Text(
                    lBase.subTitles.fixedPayments,
                    style: subTitle
                ),
                SizedBox(height: 10),
                Divider(color: Colors.grey),
                Expanded(child: subscriptionsBlock(currency, widget.onTransactionItemClick, widget.renewTransactions))
            ]
        );
    }
}

class SubsButton extends StatefulWidget {
    final Function onActionPressed;

    SubsButton({Key key, this.onActionPressed}) : super(key: key);

    @override
    SubsButtonState createState() => SubsButtonState();
}

class SubsButtonState extends State<SubsButton> {
    @override
	Widget build(BuildContext context) {
        return GestureDetector(
            child: FloatingActionButton(
                mini: true,
                heroTag: "subsDone",
                child: buttonStates[0][buttonStateIndex % 2],
                backgroundColor: buttonStates[1][buttonStateIndex % 2],
                elevation: 0.0,
                onPressed: widget.onActionPressed,
                highlightElevation: 1.0,
            )
        );
    }
}