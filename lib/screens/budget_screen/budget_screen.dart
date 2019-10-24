import 'package:budget/modules/functions.dart';
import 'package:flutter/material.dart';
import '../../modules/components.dart';
import '../../modules/global.dart';

PreferredSizeWidget budgetHead([BuildContext context]) {
    return appBarWithGradientTitle(
        "BUDGET",
        25,
        Colors.purpleAccent[400],
        Colors.purple[800],
        themeColors[theme],
        0.0,
        true,
        'FiraCode',
        FontWeight.w400,
        1.5,
        true, 
        () {
            selectedID = -1;
            openStats(context);
        }
    );
}

class BudgetScreen extends StatefulWidget {
    final Function onTransactionItemClick;
    final Function renewTransactions;
    final Function openEditPage;

    BudgetScreen({Key key, this.onTransactionItemClick, this.renewTransactions, this.openEditPage}): super(key: key);

    @override
    BudgetScreenState createState() => BudgetScreenState();
}

class BudgetScreenState extends State<BudgetScreen> {
    @override
    Widget build(BuildContext context) {
        refreshStats();
        
        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                Divider(),
                SizedBox(height: 20),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                        Row(
                            children: [
                                Expanded(child: infoBlock(budget, currency, "BUDGET", Colors.greenAccent[700], CrossAxisAlignment.start)),
                                Expanded(child: infoBlock(expense, currency, "EXPENSE", Colors.red, CrossAxisAlignment.end)),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        SizedBox(height: 30),
                        Row(
                            children: [
                                Expanded( child: infoBlock(savings, currency, "TOTAL SAVINGS", Colors.amber[800], CrossAxisAlignment.start)),
                                Expanded(
                                    child: infoBlock(
                                        budget - expense,
                                        currency,
                                        "REMAINING",
                                        budget - expense >= 0
                                            ? Colors.blueAccent[700]
                                            : Colors.redAccent[700],
                                        CrossAxisAlignment.end
                                    ),
                                ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                        ),
                    ],
                ),
                SizedBox(height: 20),
                Divider(color: Colors.grey),
                SizedBox(height: 20),
                Text(" TRANSACTIONS",
                    style: TextStyle(
                        color: textColors[theme],
                        fontFamily: "Montserrat",
                        fontSize: 22.0,
                        fontWeight: FontWeight.w300
                    )
                ),
                SizedBox(height: 10),
                Divider(color: Colors.grey),
                Expanded( child: transactionsBlock(currency, widget.onTransactionItemClick, widget.renewTransactions)),
                AnimatedContainer(
                    curve: Curves.easeInOut,
                    duration: Duration(milliseconds: 200),
                    height: (buttonStateIndex * 130).toDouble(),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: navBarColors[theme],
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            customButton(
                                16, 
                                Colors.amber[800], 
                                Colors.grey[50], 
                                Icons.archive, 
                                "Save", 
                                () {
                                    widget.openEditPage(0);
                                }, 
                                EdgeInsets.fromLTRB(0, 20, 0, 40), 
                                120.0, 
                                50.0
                            ),
                            SizedBox(width: 5),
                            customButton(
                                16, 
                                Colors.red, 
                                Colors.grey[50], 
                                Icons.remove, 
                                "Spend",
                                () {
                                    widget.openEditPage(1);
                                }, 
                                EdgeInsets.fromLTRB(0, 20, 0, 40), 
                                120.0, 
                                50.0
                            ),
                            SizedBox(width: 5),
                            customButton(
                                16, 
                                Colors.greenAccent[400], 
                                Colors.grey[50],
                                Icons.add, 
                                "Deposit", 
                                () {
                                    widget.openEditPage(2);
                                }, 
                                EdgeInsets.fromLTRB(0, 20, 0, 40), 
                                120.0, 
                                50.0
                            ),
                        ],
                    ),
                ),
            ],
        );
    }
}

class BudgetButton extends StatefulWidget {
    final Function onActionPressed;

    BudgetButton({Key key, this.onActionPressed}) : super(key: key);

    @override
    BudgetButtonState createState() => BudgetButtonState();
}

class BudgetButtonState extends State<BudgetButton> {
    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            child: FloatingActionButton(
                mini: true,
                heroTag: "budgetActions",
                child: buttonStates[0][buttonStateIndex % 2],
                backgroundColor: buttonStates[1][buttonStateIndex % 2],
                elevation: 0.0,
                onPressed: widget.onActionPressed,
                highlightElevation: 1.0,
                tooltip: "Actions",
            )
        );
    }
}
