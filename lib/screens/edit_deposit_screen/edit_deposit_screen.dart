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

class EditDeposit extends StatefulWidget {
    EditDeposit({Key key}) : super(key: key);

    @override
    _EditDepositState createState() => _EditDepositState();
}


class _EditDepositState extends State<EditDeposit> {
    int _selectedButtonIndex = 0;
    double _amount = 0.0;
    DateTime _date = DateTime.now();
    final controller = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', );

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
        if (s == 0) {
            return [
                customButton(buttonTextSize, Colors.greenAccent[700], Colors.white, Icons.person, lBase.buttons.self, () {setState(() {
                    _selectedButtonIndex = 0;
                });}, EdgeInsets.fromLTRB(0, 20, 0, 40), SizeConfig.blockSizeHorizontal * 35, 50.0),
                SizedBox(width:5),
                customButton(buttonTextSize, Colors.orange[50], Colors.amber[800], Icons.archive, lBase.buttons.savings, () {setState(() {
                    _selectedButtonIndex = 1;
                });}, EdgeInsets.fromLTRB(0, 20, 0, 40), SizeConfig.blockSizeHorizontal * 35, 50.0)
            ];
        } else if (s == 1) {
            return [
                customButton(buttonTextSize, Colors.greenAccent[100], Colors.green[700], Icons.person, lBase.buttons.self, () {setState(() {
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
        if ((_amount > 0.0 && _selectedButtonIndex == 0) || (_selectedButtonIndex == 1 && calculateTotalSavings() - _amount >= 0 && _amount > 0)) {
            setState(() {
                List _ls = List.from(settings["transactions"]);
                PaymentType _pt = _selectedButtonIndex == 0 ? PaymentType.Deposit : PaymentType.SavingToBudget;

                Payment _p = new Payment("budgetpaymentexpenseasstring.${_pt.index}", _amount, _date, _pt.index, settings["keyIndex"]);
                
                _ls.add(_p);
                settings["transactions"] = _ls;
                saveSettings();

                _amount = 0.0;
                _date = DateTime.now();
                _selectedButtonIndex = 0;

                Navigator.pop(context);
            });
        }
    }

    void onNavClick(int index) {
        setState(() {
            selectedNavMenu = index;
        });
    }

    @override
	Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: themeColors[theme],
            appBar: appBarWithGradientTitle(lBase.titles.deposit, 25, Colors.greenAccent[700], Colors.green[800], themeColors[theme], 0.0, true, 'FiraCode', FontWeight.w400, 1.5),
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
                                            focusedBorder: new UnderlineInputBorder(borderSide: BorderSide(color: _selectedButtonIndex == 0 ? Colors.greenAccent[700] : Colors.amber[800])),
                                            enabledBorder: new UnderlineInputBorder(borderSide: BorderSide(color: _selectedButtonIndex == 0 ? Colors.greenAccent[200] : Colors.amber[200]))
                                        ),
                                        cursorColor: _selectedButtonIndex == 0 ? Colors.greenAccent[700] : Colors.amber[800],
                                        style: TextStyle(
                                            fontSize: amountTextSize,
                                            fontFamily: "Montserrat",
                                            color: _selectedButtonIndex == 0 ? Colors.greenAccent[700] : Colors.amber[800]
                                        ),
                                        onSubmitted: (_t) {
                                            _amount = controller.numberValue;
                                            
                                            setState(() {
                                                _amount = controller.numberValue;
                                            });
                                        },
                                        onChanged: (_t) {
                                            _amount = controller.numberValue;

                                            setState(() {
                                                _amount = controller.numberValue;
                                            });
                                        },
                                    )
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
                                        heroTag: 7,
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
                                )
                            ]                    
                        )
                    ]
                ),
            ),
            floatingActionButton: GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: FloatingActionButton(
                      heroTag: 6,
                      child: Icon(Icons.done),
                      backgroundColor: (_amount > 0.0 && _selectedButtonIndex == 0) || (_selectedButtonIndex == 1 && calculateTotalSavings() - _amount >= 0 && _amount > 0) ? Colors.greenAccent[400] : Colors.blueGrey[600],
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