/// Made by Adil Atalay Hamamcıoğlu (Recoskyler), 2019
/// Please check the GitHub Page for usage rights.
/// https://github.com/recoskyler/Budget
///

import 'package:budget/modules/functions.dart';
import 'package:flutter/material.dart';
import '../../modules/global.dart';
import 'package:budget/modules/enums.dart';
import '../../modules/components.dart';
import '../../modules/settings.dart';
import '../../modules/classes.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';

class EditSubs extends StatefulWidget {
    EditSubs({Key key}) : super(key: key);

    @override
    _EditSubsState createState() => _EditSubsState();
}


class _EditSubsState extends State<EditSubs> {
    int _selectedButtonIndex = 0;
    double _amount = 0.0;
    int _renewalDay = 1;
    String _desc = "";
    DateTime _date = DateTime.now();
    final controller = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', );

    Future _selectDate() async {
        DateTime picked = await showDatePicker(
            context: context,
            initialDate: _date,
            firstDate: DateTime(DateTime.now().year - 1),
            lastDate: DateTime.now()
        );
        if(picked != null) setState(() => _date = picked);
    }

    List<Widget> getButtons(int s) {
        if (s == 0) {
            return [
                customButton(buttonTextSize, Colors.purpleAccent[400], Colors.white, Icons.subject, lBase.buttons.contract, () {setState(() {
                    _selectedButtonIndex = 0;
                });}, EdgeInsets.fromLTRB(0, 20, 0, 40), 180.0, 50.0),
                SizedBox(width:5),
                customButton(buttonTextSize, Colors.orange[50], Colors.amber[800], Icons.archive, lBase.buttons.saving, () {setState(() {
                    _selectedButtonIndex = 1;
                });}, EdgeInsets.fromLTRB(0, 20, 0, 40), 180.0, 50.0)
            ];
        } else if (s == 1) {
            return [
                customButton(buttonTextSize, Colors.purple[50], Colors.purpleAccent[400], Icons.subject, lBase.buttons.contract, () {setState(() {
                    _selectedButtonIndex = 0;
                });}, EdgeInsets.fromLTRB(0, 20, 0, 40), 180.0, 50.0),
                SizedBox(width:5),
                customButton(buttonTextSize, Colors.amber[800], Colors.white, Icons.archive, lBase.buttons.saving, () {setState(() {
                    _selectedButtonIndex = 1;
                });}, EdgeInsets.fromLTRB(0, 20, 0, 40), 180.0, 50.0)
            ];
        }

        return [];
    }

    List<Widget> getMonthButtons(Function _op, int _indexVar, int s, int edition) {
        List<Widget> _buttons = new List<Widget>();

        _buttons.add(SizedBox(width:10));

        for (int i = 1; i <= s; i++) {
            _buttons.add(
                Container(
                    height: 50,
                    child: FloatingActionButton.extended(
                        heroTag: edition + i + 13,
                        backgroundColor: (i == _indexVar ? Colors.redAccent[400] : dayButtonColors[theme]),
                        label: Text(
                            i.toString(),
                            style: TextStyle(
                                fontFamily: "FiraCode",
                                fontSize: buttonTextSize,
                                color: (i != _indexVar ? dayButtonTextColors[theme] : Colors.white)
                            ),
                            textAlign: TextAlign.center
                        ),
                        onPressed: () {_op(i);},
                        elevation: 0.0,
                        highlightElevation: 1.0,
                    )
                )
            );
            _buttons.add(SizedBox(width:10));
        }

        return _buttons;
    }

    void onActionPressed() {
        if (_amount > 0.0 && (((settings["monthlyAllowence"] - calculateSavings() - _amount >= 0.0 && _selectedButtonIndex == 1)) || (_selectedButtonIndex == 0 && _amount > 0.0)) && _desc.replaceAll(" ", "") != "") {
            setState(() {
                List _ls = List.from(settings["fixedPayments"]);

                Payment _p = new Payment(_desc, _amount, _date, _selectedButtonIndex == 0 ? PaymentType.Subscription.index : PaymentType.FixedSavingDeposit.index, settings["keyIndex"], _renewalDay);
                
                _ls.add(_p);
                settings["fixedPayments"] = _ls;
                saveSettings();

                _amount = 0.0;
                _selectedButtonIndex = 0;
                _desc = "";
                _renewalDay = 1;

                Navigator.pop(context);
            });
        }
    }

    void onNavClick(int index) {
        setState(() {
            selectedNavMenu = index;
        });
    }

    void onSubDayClick(int index) {
        setState(() {
            _renewalDay = index;
        });
    }

    @override
	Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: themeColors[theme],
            appBar: appBarWithGradientTitle(lBase.titles.addFixed, 25, Colors.redAccent[400], Colors.red[900], themeColors[theme], 0.0, true, 'FiraCode', FontWeight.w400, 1.5),
            body: Container(
                padding: globalInset,
                child: ListView(
                    children: [
                        Divider(),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                Text(
                                    lBase.subTitles.type,
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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                            Text(
                                                lBase.subTitles.description,
                                                style: subTitle
                                            ),
                                            Container(
                                                alignment: Alignment.center,
                                                height: 80,
                                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                child: TextField(
                                                    maxLines: 1,
                                                    maxLength: 18,
                                                    maxLengthEnforced: true,
                                                    keyboardType: TextInputType.text,
                                                    decoration: new InputDecoration(
                                                        focusedBorder: new UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent[400])),
                                                        enabledBorder: new UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent[100]))
                                                    ),
                                                    cursorColor: Colors.redAccent[400],
                                                    style: TextStyle(
                                                        fontSize: amountTextSize,
                                                        fontFamily: "Montserrat",
                                                        color: Colors.redAccent[400]
                                                    ),
                                                    onSubmitted: (_t) {
                                                        setState(() {
                                                            _desc = _t;
                                                        });
                                                    },
                                                    onChanged: (_t) {
                                                        setState(() {
                                                            _desc = _t;
                                                        });
                                                    },
                                                )
                                            ),
                                        ],
                                    ),
                                ),
                                SizedBox(height:30),
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
                                    lBase.subTitles.renewalDay,
                                    style: subTitle
                                ),
                                SizedBox(height:10),
                                Container(
                                    height: 50,
                                    child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: getMonthButtons(onSubDayClick, _renewalDay, 30, 100),
                                        physics: AlwaysScrollableScrollPhysics(),
                                    )
                                ),
                                SizedBox(height:30),
                                Text(
                                    lBase.subTitles.startingDate,
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
                                ),
                                SizedBox(height: 150),
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
                        backgroundColor: (((settings["monthlyAllowence"] - calculateSavings() - _amount >= 0.0 && _selectedButtonIndex == 1)) || (_selectedButtonIndex == 0 && _amount > 0.0)) && _desc.replaceAll(" ", "") != "" ? Colors.greenAccent[400] : Colors.blueGrey[600],
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