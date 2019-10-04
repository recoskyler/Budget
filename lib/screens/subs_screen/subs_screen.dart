import 'package:flutter/material.dart';
import '../../modules/components.dart';
import '../../modules/global.dart';

PreferredSizeWidget subsHead() {
    return appBarWithGradientTitle(
        "FIXED PAYMENTS", 
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
                        Expanded(child: infoBlock(budget, currency, "BUDGET", Colors.greenAccent[700], CrossAxisAlignment.start)),
                        Expanded(child: infoBlock(subexpense, currency, "FIXED EXPENSES", Colors.red, CrossAxisAlignment.end)),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                ),
                SizedBox(height: 30),
                Row(
                    children: [
                        Expanded(child: infoBlock(savings, currency, "TOTAL SAVINGS", Colors.amber[800], CrossAxisAlignment.start)),
                        Expanded(child: infoBlock(budget - subexpense, currency, "REMAINING", budget - subexpense >= 0 ? Colors.blueAccent[700] : Colors.redAccent[700], CrossAxisAlignment.end)),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                ),
                SizedBox(height: 20),
                Divider(color: Colors.grey),
                SizedBox(height: 20),
                Text(
                    " FIXED PAYMENTS",
                    style: TextStyle(
                        color: textColors[theme],
                        fontFamily: "Montserrat",
                        fontSize: 22.0,
                        fontWeight: FontWeight.w300
                    )
                ),
                SizedBox(height: 10),
                transactionItemDivider(),
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
                tooltip: "Add Fixed Payment",
            )
        );
    }
}