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

class EditSaving extends StatefulWidget {
    EditSaving({Key key}) : super(key: key);

    @override
    _EditSavingState createState() => _EditSavingState();
}


class _EditSavingState extends State<EditSaving> {
    int _selectedButtonIndex = 0;
    double _amount = 0.0;
    DateTime _date = DateTime.now();
    final controller = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', leftSymbol: settings["currency"]);

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
                customButton(20, Colors.purpleAccent[400], Colors.white, Icons.account_balance_wallet, "BUDGET", () {setState(() {
                    _selectedButtonIndex = 0;
                });}, EdgeInsets.fromLTRB(0, 20, 0, 40), 180.0, 50.0),
                SizedBox(width:5),
                customButton(20, Colors.greenAccent[100], Colors.green[800], Icons.person, "SELF", () {setState(() {
                    _selectedButtonIndex = 1;
                });}, EdgeInsets.fromLTRB(0, 20, 0, 40), 180.0, 50.0),
            ];
        } else if (s == 1) {
            return [
                customButton(20, Colors.purple[50], Colors.purpleAccent[400], Icons.account_balance_wallet, "BUDGET", () {setState(() {
                    _selectedButtonIndex = 0;
                });}, EdgeInsets.fromLTRB(0, 20, 0, 40), 180.0, 50.0),
                SizedBox(width:5),
                customButton(20, Colors.greenAccent[700], Colors.white, Icons.person, "SELF", () {setState(() {
                    _selectedButtonIndex = 1;
                });}, EdgeInsets.fromLTRB(0, 20, 0, 40), 180.0, 50.0),
            ];
        }

        return [];
    }

    void onActionPressed() {
        if ((_selectedButtonIndex == 1 && _amount > 0) || (calculateExpenses() + _amount <= calculateAllowence() && _amount > 0 && _selectedButtonIndex == 0)) {
            setState(() {
                List _ls = List.from(settings["transactions"]);
                PaymentType _pt = _selectedButtonIndex == 0 ? PaymentType.Saving : PaymentType.ExistingSaving;

                Payment _p = new Payment(asString[_pt.index], _amount, _date, _pt.index, settings["keyIndex"]);
                
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
            appBar: appBarWithGradientTitle("SAVE", 25, Colors.amberAccent[700], Colors.amber[900], themeColors[theme], 0.0, true, 'FiraCode', FontWeight.w400, 1.5),
            body: ListView(
                children: [
                    Divider(),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            Text(
                                " SOURCE",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w300,
                                    color: textColors[theme],
                                    letterSpacing: 2
                                )
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: getButtons(_selectedButtonIndex)
                            ),
                            SizedBox(height:10),
                            Text(
                                " AMOUNT",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w300,
                                    color: textColors[theme],
                                    letterSpacing: 2
                                )
                            ),
                            Container(
                                alignment: Alignment.center,
                                height: 80,
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: TextField(
                                    controller: controller,
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        focusedBorder: new UnderlineInputBorder(borderSide: BorderSide(color: _selectedButtonIndex == 0 ? Colors.purpleAccent[700] : Colors.greenAccent[700])),
                                        enabledBorder: new UnderlineInputBorder(borderSide: BorderSide(color: _selectedButtonIndex == 0 ? Colors.purpleAccent[100]  : Colors.greenAccent[200]))
                                    ),
                                    cursorColor: _selectedButtonIndex == 0 ? Colors.purpleAccent[700] : Colors.greenAccent[700],
                                    style: TextStyle(
                                        fontSize: 40,
                                        fontFamily: "Montserrat",
                                        color: _selectedButtonIndex == 0 ? Colors.purpleAccent[700] : Colors.greenAccent[700]
                                    ),
                                    onSubmitted: (_t) {
                                        setState(() {
                                            _amount = double.parse(_t.replaceAll(',', '').replaceAll(settings["currency"], ""));
                                        });
                                    },
                                    onChanged: (_t) {
                                        setState(() {
                                            _amount = double.parse(_t.replaceAll(',', '').replaceAll(settings["currency"], ""));
                                        });
                                    },
                                )
                            ),
                            SizedBox(height:30),
                            Text(
                                " DATE",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w300,
                                    color: textColors[theme],
                                    letterSpacing: 2
                                )
                            ),
                            SizedBox(height:10),
                            Container(
                                margin: EdgeInsets.fromLTRB(30, 20, 30, 10),
                                child: FloatingActionButton.extended(
                                    elevation: 0.0,
                                    highlightElevation: 1.0,
                                    heroTag: 4,
                                    onPressed: _selectDate,
                                    backgroundColor: Colors.blueAccent[400],
                                    label: Text(
                                        DateFormat("dd/MM/yyyy").format(_date),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: "Montserrat"
                                        )
                                    ),
                                )
                            )
                        ]                    
                    )
                ]
            ),
            floatingActionButton: GestureDetector(
                child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: FloatingActionButton(
                        heroTag: 3,
                        child: Icon(Icons.done),
                        backgroundColor: (_amount > 0.0 && _selectedButtonIndex == 1) || (_selectedButtonIndex == 0 && calculateTotalSavings() - _amount >= 0 && _amount > 0) ? Colors.greenAccent[400] : Colors.blueGrey[600],
                        elevation: 0.0,
                        onPressed: onActionPressed,
                        highlightElevation: 1.0,
                        tooltip: "Done",
                    ),
                )
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            resizeToAvoidBottomInset: false,
        );
    }
}