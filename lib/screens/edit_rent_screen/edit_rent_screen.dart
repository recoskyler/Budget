import 'package:budget/modules/functions.dart';
import 'package:budget/modules/global.dart';
import 'package:budget/screens/rent_screen/rent_screen.dart';
import 'package:flutter/material.dart';
import 'package:budget/modules/enums.dart';
import '../../modules/settings.dart';
import '../../modules/classes.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class EditRent extends StatefulWidget {
    EditRent({Key key}) : super(key: key);

    @override
    _EditRentState createState() => _EditRentState();
}


class _EditRentState extends State<EditRent> {
    int _selectedutilityDay = settings["utilitiesDay"];
    int _selectedRentDay = settings["rentDay"];
    int _selectedDuration = 1;
    double _amount = settings["rentAmount"];
    DateTime _date = DateTime.now();
    final controller = MoneyMaskedTextController(decimalSeparator: '', thousandSeparator: ',', initialValue: settings["rentAmount"], precision: 0);

    Future _selectDate() async {
        DateTime picked = await showDatePicker(
            context: context,
            initialDate: _date,
            firstDate: DateTime(DateTime.now().year - 5),
            lastDate: DateTime(DateTime.now().year + 1)
        );

        if(picked != null) setState(() => _date = picked);
    }

    void onRentDayClick(int index) {
        setState(() {
            _selectedRentDay = index;
        });
    }

    void onutilityDayClick(int index) {
        setState(() {
            _selectedutilityDay = index;
        });
    }

    void onDurationClick(int index) {
        setState(() {
            _selectedDuration = index;
        });
    }

    List<Widget> getButtons(Function _op, int _indexVar, int s, int edition) {
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
        if (_amount > 0.0) {
            setState(() {
                settings["rentDay"] = _selectedRentDay;
                settings["utilitiesDay"] = _selectedutilityDay;
                settings["rentAmount"] = _amount;
                settings["rentStartDate"] = _date.toString();
                settings["rentPage"] = 0;

                List _ls = List.from(settings["transactions"]);
                PaymentType _rpt = PaymentType.Rent;
                PaymentType _upt = PaymentType.Utility;
                DateTime _tempDate = new DateTime(_date.year, _date.month, 1);

                for (int i = 0; i <= _selectedDuration * 12; i++) {
                    Payment _rp = new Payment(asString[_rpt.index], _amount, _tempDate, _rpt.index, settings["keyIndex"]);
                    Payment _up = new Payment(asString[_upt.index], 0.0, _tempDate, _upt.index, settings["keyIndex"]);
                    _tempDate = getNextRenewalDate(_tempDate, 1);
                
                    _ls.add(_rp);
                    _ls.add(_up);
                }

                settings["rents"] = _ls;

                saveSettings();

                _amount = 0.0;
                _date = DateTime.now();
                _selectedRentDay = 1;
                _selectedutilityDay = 1;
                
                Navigator.pop(context);
            });
        }
    }

    @override
	Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: themeColors[theme],
            appBar: rentHead(),
            body: Container(
                padding: globalInset,
                child: ListView(
                    children: [
                        Divider(),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                //
                                // Disabled until notifications are added (not guaranteed)
                                /*
                                Text(
                                    " RENT DAY",
                                    style: subTitle
                                ),
                                SizedBox(height:10),
                                Container(
                                    height: 50,
                                    child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: getButtons(onRentDayClick, _selectedRentDay, 30, 0),
                                        physics: AlwaysScrollableScrollPhysics(),
                                    )
                                ),
                                SizedBox(height:30),
                                */
                                //
                                Text(
                                    lBase.subTitles.rentAmount,
                                    style: subTitle
                                ),
                                SizedBox(height:10),
                                Container(
                                    alignment: Alignment.center,
                                    height: 80,
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: TextField(
                                        controller: controller,
                                        keyboardType: TextInputType.number,
                                        decoration: new InputDecoration(
                                            focusedBorder: new UnderlineInputBorder(borderSide: BorderSide(color: Colors.indigoAccent[700])),
                                            enabledBorder: new UnderlineInputBorder(borderSide: BorderSide(color: Colors.indigoAccent[100]))
                                        ),
                                        cursorColor: Colors.indigoAccent[700],
                                        style: TextStyle(
                                            fontSize: amountTextSize,
                                            fontFamily: "Montserrat",
                                            color: Colors.indigoAccent[700]
                                        ),
                                        onSubmitted: (_t) {
                                            setState(() {
                                                _amount = controller.numberValue;
                                            });
                                        },
                                        onChanged: (_t) {
                                            setState(() {
                                                _amount = controller.numberValue;
                                            });
                                        },
                                    )
                                ),
                                //
                                // Disabled until notifications are added (not guaranteed)
                                /*
                                SizedBox(height:30),
                                Text(
                                    " UTILITIES DAY",
                                    style: subTitle
                                ),
                                SizedBox(height:10),
                                Container(
                                    height: 50,
                                    child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: getButtons(onutilityDayClick, _selectedutilityDay, 30, 32),
                                        physics: AlwaysScrollableScrollPhysics(),
                                    )
                                ),
                                */
                                //
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
                                        heroTag: "rentdate",
                                        onPressed: _selectDate,
                                        backgroundColor: Colors.blueAccent[400],
                                        label: Text(
                                            DateFormat("MM/yyyy").format(_date),
                                            style: TextStyle(
                                                fontSize: buttonTextSize,
                                                fontFamily: "Montserrat"
                                            )
                                        ),
                                    )
                                ),
                                SizedBox(height:30),
                                Text(
                                    lBase.subTitles.duration,
                                    style: subTitle
                                ),
                                SizedBox(height:10),
                                Container(
                                    height: 50,
                                    child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: getButtons(onDurationClick, _selectedDuration, 5, 65),
                                        physics: AlwaysScrollableScrollPhysics(),
                                    )
                                ),
                            ]                    
                        )
                    ]
                ),
            ),
            floatingActionButton: GestureDetector(
                child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: FloatingActionButton(
                        heroTag: "rentedit",
                        child: Icon(Icons.done),
                        backgroundColor: _amount > 0.0 ? Colors.greenAccent[400] : Colors.blueGrey[600],
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