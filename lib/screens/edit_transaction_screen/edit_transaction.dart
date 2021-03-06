import 'package:budget/main.dart';
/// Made by Adil Atalay Hamamcıoğlu (Recoskyler), 2019
/// Please check the GitHub Page for usage rights.
/// https://github.com/recoskyler/Budget
///

import 'package:flutter/material.dart';
import '../../modules/global.dart';
import 'package:budget/modules/enums.dart';
import '../../modules/components.dart';
import '../../modules/settings.dart';
import '../../modules/classes.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../modules/functions.dart';

class EditTransaction extends StatefulWidget {
    EditTransaction({Key key}) : super(key: key);

    @override
    _EditTransactionState createState() => _EditTransactionState();
}


class _EditTransactionState extends State<EditTransaction> {
    int _selectedButtonIndex = 0;
    int _selectedNameIndex = 0;
    double _amount = 0.0;
    DateTime _date = DateTime.now();
    String _desc = "";
    String _hint = "";
    final controller = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', precision: 2);

    Future _selectDate() async {
        DateTime picked = await showDatePicker(
            context: context,
            initialDate: _date,
            firstDate: DateTime(DateTime.now().year - 5),
            lastDate: DateTime.now()
        );
        if(picked != null) setState(() => _date = picked);
    }

    List<Widget> getButtons(int s) {
        if (s == 1 && _amount > calculateTotalSavings()) {
            setState(() {
                _hint = lBase.hints.savingExpenseOverflow;
            });
        } else {
            setState(() {
                _hint = "";
            });
        }
        
        if (s == 0) {
            return [
                customButton(buttonTextSize, Colors.purpleAccent[400], Colors.white, Icons.account_balance_wallet, lBase.buttons.budget, () {setState(() {
                    _selectedButtonIndex = 0;
                });}, EdgeInsets.fromLTRB(0, 20, 0, 40), SizeConfig.blockSizeHorizontal * 35, 50.0),
                SizedBox(width:5),
                customButton(buttonTextSize, Colors.orange[50], Colors.amber[800], Icons.archive, lBase.buttons.savings, () {setState(() {
                    _selectedButtonIndex = 1;
                });}, EdgeInsets.fromLTRB(0, 20, 0, 40), SizeConfig.blockSizeHorizontal * 35, 50.0)
            ];
        } else if (s == 1) {
            return [
                customButton(buttonTextSize, Colors.purple[50], Colors.purpleAccent[400], Icons.account_balance_wallet, lBase.buttons.budget, () {setState(() {
                    _selectedButtonIndex = 0;
                });}, EdgeInsets.fromLTRB(0, 20, 0, 40), SizeConfig.blockSizeHorizontal * 35, 50.0),
                SizedBox(width:5),
                customButton(buttonTextSize, Colors.amber[800], Colors.white, Icons.archive, lBase.buttons.savings, () {setState(() {
                    _selectedButtonIndex = 1;
                });}, EdgeInsets.fromLTRB(0, 20, 0, 40), SizeConfig.blockSizeHorizontal * 35, 50.0)
            ];
        }

        return [];
    }

    void onActionPressed() {
        if ((_amount > 0.0 && _selectedButtonIndex == 0) || (_selectedButtonIndex == 1 && _amount > 0)) {
            setState(() {
                List<dynamic> _ls = List.from(settings["transactions"]);

                if (_desc.replaceAll(" ", "").length == 0) {
                    _desc = transactionDescriptions[_selectedNameIndex];
                }

                if (_selectedNameIndex != transactionDescriptions.length - 1) {
                    _desc = _selectedNameIndex.toString();
                }

                if (_selectedButtonIndex == 1 && _amount > calculateTotalSavings()) {
                    Payment _sp = new Payment("budgetpaymentexpenseasstring.${PaymentType.SavingExpense.index}", calculateTotalSavings(), _date, PaymentType.SavingExpense.index, settings["keyIndex"]);
                    Payment _rp = new Payment("budgetpaymentexpenseasstring.${PaymentType.SavingExpense.index}", _amount - calculateTotalSavings(), _date, PaymentType.Withdraw.index, settings["keyIndex"]);

                    _ls.add(_sp);
                    _ls.add(_rp);
                } else {
                    Payment _p = new Payment(_selectedButtonIndex == 0 ? _desc : "budgetpaymentexpenseasstring.${PaymentType.SavingExpense.index}", _amount, _date, _selectedButtonIndex == 0 ? PaymentType.Withdraw.index : PaymentType.SavingExpense.index, settings["keyIndex"]);

                    _ls.add(_p);
                }

                settings["transactions"] = _ls;
                saveSettings();

                _amount = 0.0;
                _date = DateTime.now();
                _selectedButtonIndex = 0;
                _selectedNameIndex = 0;
                _desc = "";

                Navigator.pop(context);
            });
        }
    }

    void onNavClick(int index) {
        setState(() {
            selectedNavMenu = index;
        });
    }

    void onDescClick(int index) {
        setState(() {
            _selectedNameIndex = index;
        });
    }

    @override
	Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: themeColors[theme],
            appBar: appBarWithGradientTitle(lBase.titles.spend, 25, Colors.redAccent[400], Colors.red[900], themeColors[theme], 0.0, true, 'FiraCode', FontWeight.w400, 1.5),
            body: Container(
                margin: globalInset,
                child: ListView(
                    children: [
                        Divider(),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                Text(
                                    lBase.subTitles.source,
                                    style: subTitle
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: getButtons(_selectedButtonIndex)
                                ),
                                SizedBox(height:10),
                                Container(
                                    height: 120,
                                    child: Column(
                                        mainAxisSize: _selectedButtonIndex == 0 ? MainAxisSize.max : MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                            Text(
                                                lBase.subTitles.description,
                                                style: subTitle
                                            ),
                                            Container(
                                                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                                height: 50,
                                                child: _selectedButtonIndex == 0 ? namesBlock(onDescClick, _selectedNameIndex) : Container(
                                                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                    height: 50,
                                                    child: FloatingActionButton.extended(
                                                        heroTag: 5,
                                                        backgroundColor: Colors.redAccent[400],
                                                        label: Text(
                                                            asString[PaymentType.SavingExpense.index],
                                                            style: TextStyle(
                                                                fontFamily: "FiraCode",
                                                                fontSize: buttonTextSize,
                                                                color: Colors.white
                                                            ),
                                                            textAlign: TextAlign.center
                                                        ),
                                                        onPressed: () {},
                                                        elevation: 0.0,
                                                        highlightElevation: 1.0,
                                                    )
                                                )
                                            ),
                                        ],
                                    ),
                                ),
                                SizedBox(height:10),
                                Visibility(
                                    visible: _selectedNameIndex == transactionDescriptions.length - 1 && _selectedButtonIndex == 0 ? true : false,
                                    child: Text(
                                        lBase.subTitles.customDesc,
                                        style: subTitle
                                    ),
                                ),
                                SizedBox(height:10),
                                Visibility(
                                    visible: _selectedNameIndex == transactionDescriptions.length - 1 && _selectedButtonIndex == 0 ? true : false,
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: 80,
                                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: TextField(
                                            enabled: _selectedNameIndex == transactionDescriptions.length - 1 && _selectedButtonIndex == 0 ? true : false,
                                            maxLines: 1,
                                            maxLength: 24,
                                            maxLengthEnforced: true,
                                            keyboardType: TextInputType.text,
                                            decoration: new InputDecoration(
                                                focusedBorder: new UnderlineInputBorder(borderSide: BorderSide(color: _selectedButtonIndex == 0 ? Colors.purpleAccent[700] : Colors.amber[800])),
                                                enabledBorder: new UnderlineInputBorder(borderSide: BorderSide(color: _selectedButtonIndex == 0 ? Colors.purpleAccent[100] : Colors.amber[200]))
                                            ),
                                            cursorColor: _selectedButtonIndex == 0 ? Colors.purpleAccent[700] : Colors.amber[800],
                                            style: TextStyle(
                                                fontSize: amountTextSize,
                                                fontFamily: "Montserrat",
                                                color: _selectedButtonIndex == 0 ? Colors.purpleAccent[700] : Colors.amber[800]
                                            ),
                                            onSubmitted: (_t) {
                                                _desc = _t;
                                            },
                                            onChanged: (_t) {
                                                _desc = _t;
                                            },
                                        )
                                    )
                                ),
                                Text(
                                    lBase.subTitles.amount,
                                    style: subTitle
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    height: 80,
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: TextField(
                                        controller: controller,
                                        keyboardType: TextInputType.number,
                                        decoration: new InputDecoration(
                                            focusedBorder: new UnderlineInputBorder(borderSide: BorderSide(color: _selectedButtonIndex == 0 ? Colors.purpleAccent[700] : Colors.amber[800])),
                                            enabledBorder: new UnderlineInputBorder(borderSide: BorderSide(color: _selectedButtonIndex == 0 ? Colors.purpleAccent[100] : Colors.amber[200]))
                                        ),
                                        cursorColor: _selectedButtonIndex == 0 ? Colors.purpleAccent[700] : Colors.amber[800],
                                        style: TextStyle(
                                            fontSize: amountTextSize,
                                            fontFamily: "Montserrat",
                                            color: _selectedButtonIndex == 0 ? Colors.purpleAccent[700] : Colors.amber[800]
                                        ),
                                        onSubmitted: (_t) {
                                            _amount = controller.numberValue;

                                            if (_selectedButtonIndex == 1 && _amount > calculateTotalSavings()) {
                                                setState(() {
                                                    _hint = lBase.hints.savingExpenseOverflow;
                                                });
                                            } else {
                                                setState(() {
                                                    _hint = "";
                                                });
                                            }

                                            setState(() {
                                                _amount = controller.numberValue;
                                            });
                                        },
                                        onChanged: (_t) {
                                            _amount = controller.numberValue;

                                            if (_selectedButtonIndex == 1 && _amount > calculateTotalSavings()) {
                                                setState(() {
                                                    _hint = lBase.hints.savingExpenseOverflow;
                                                });
                                            } else {
                                                setState(() {
                                                    _hint = "";
                                                });
                                            }

                                            setState(() {
                                                _amount = controller.numberValue;
                                            });
                                        },
                                    )
                                ),
                                SizedBox(height: 10),
                                Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Text(
                                        _hint,
                                        style: tfHintStyle,
                                        textAlign: TextAlign.justify,
                                    ),
                                ),
                                SizedBox(height:30),
                                Text(
                                    lBase.subTitles.date,
                                    style: subTitle
                                ),
                                SizedBox(height:10),
                                Container(
                                    margin: EdgeInsets.fromLTRB(30, 20, 30, 10),
                                    child: FloatingActionButton.extended(
                                        elevation: 0.0,
                                        highlightElevation: 1.0,
                                        heroTag: 2,
                                        onPressed: _selectDate,
                                        backgroundColor: Colors.blueAccent[400],
                                        label: Text(
                                            DateFormat("dd/MM/yyyy").format(_date),
                                            style: TextStyle(
                                                fontSize: buttonTextSize,
                                                fontFamily: "Montserrat"
                                            )
                                        ),
                                    )
                                ),
                                SizedBox(height:150)
                            ]                    
                        )
                    ]
                ),
            ),
            floatingActionButton: GestureDetector(
                child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: FloatingActionButton(
                        heroTag: 1,
                        child: Icon(Icons.done),
                        backgroundColor: (_amount > 0.0 && _selectedButtonIndex == 0) || (_selectedButtonIndex == 1 && _amount > 0) ? Colors.greenAccent[400] : Colors.blueGrey[600],
                        elevation: 0.0,
                        onPressed: onActionPressed,
                        highlightElevation: 1.0,
                    ),
                )
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            resizeToAvoidBottomInset: false,
        );
    }
}