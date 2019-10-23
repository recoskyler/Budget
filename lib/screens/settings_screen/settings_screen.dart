import 'package:budget/main.dart';
import 'package:budget/modules/components.dart';
import 'package:budget/modules/theme_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import '../../modules/settings.dart';
import '../../modules/global.dart';

PreferredSizeWidget settingsHead() {
    return appBarWithGradientTitle(
        "SETTINGS", 
        25, 
        Colors.cyanAccent[400], 
        Colors.cyan[900], 
        themeColors[theme], 
        0.0,
        true, 
        'FiraCode', 
        FontWeight.w400, 
        1.5
    );
}

class SettingsScreen extends StatefulWidget {
    final Function themeButtonFunction;
    final Function resetSettingsAction;

    SettingsScreen({Key key, this.themeButtonFunction, this.resetSettingsAction}) : super(key: key);

    _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
    double _amount = settings["monthlyAllowence"];
    int _date = settings["budgetRenewalDay"];
    String _currencyVal = settings["currency"];
    final controller = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', leftSymbol: settings["currency"], initialValue: settings["monthlyAllowence"]);
    
    List<Widget> getMonthButtons(Function _op, int _indexVar, int s, int edition) {
        List<Widget> _buttons = new List<Widget>();

        _buttons.add(SizedBox(width:10));

        for (int i = 1; i <= s; i++) {
            _buttons.add(
                Container(
                    height: 50,
                    child: FloatingActionButton.extended(
                        heroTag: edition + i + 13,
                        backgroundColor: (i == _indexVar ? Colors.redAccent[400] : Colors.red[50]),
                        label: Text(
                            i.toString(),
                            style: TextStyle(
                                fontFamily: "FiraCode",
                                fontSize: 20,
                                color: (i != _indexVar ? Colors.redAccent[400] : Colors.white)
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

    List<Widget> getButtons(int s, Function _top) {
        if (s == 0) {
            return [
                customButton(20, Colors.red, Colors.white, CustomIcons.rebel, "REBEL", () {_top(0);}, EdgeInsets.fromLTRB(0, 0, 0, 0), 180.0, 50.0),
                SizedBox(width:5),
                customButton(20, Colors.grey[300], Colors.grey[900], CustomIcons.empire, "EMPIRE", () {_top(1);}, EdgeInsets.fromLTRB(0, 0, 0, 0), 180.0, 50.0)
            ];
        } else if (s == 1) {
            return [
                customButton(20, Colors.red[50], Colors.red, CustomIcons.rebel, "REBEL", () {_top(0);}, EdgeInsets.fromLTRB(0, 0, 0, 0), 180.0, 50.0),
                SizedBox(width:5),
                customButton(20, Colors.grey[900], Colors.white, CustomIcons.empire, "EMPIRE", () {_top(1);}, EdgeInsets.fromLTRB(0, 0, 0, 0), 180.0, 50.0)
            ];
        }

        return [];
    }

    void onSubDayClick(int index) {
        setState(() {
            _date = index;
            settings["budgetRenewalDay"] = _date;
            saveSettings();
        });
    }

    @override
    Widget build(BuildContext context) {
        SizeConfig().init(context);

        return ListView(
            children: <Widget>[
                SizedBox(height:10),
                Text(
                    " ALLOWENCE AMOUNT",
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
                            focusedBorder: new UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent[700])),
                            enabledBorder: new UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent[100]))
                        ),
                        cursorColor: Colors.greenAccent[700],
                        style: TextStyle(
                            fontSize: 40,
                            fontFamily: "Montserrat",
                            color: Colors.greenAccent[700]
                        ),
                        onSubmitted: (_t) {
                            setState(() {
                                _amount = double.parse(_t.replaceAll(',', '').replaceAll(settings["currency"], ""));
                                settings["monthlyAllowence"] = _amount;
                                saveSettings();
                            });
                        },
                        onChanged: (_t) {
                            setState(() {
                                _amount = double.parse(_t.replaceAll(',', '').replaceAll(settings["currency"], ""));
                                settings["monthlyAllowence"] = _amount;
                                saveSettings();
                            });
                        },
                    )
                ),
                SizedBox(height:30),
                Text(
                    " RENEWAL DAY",
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
                    height: 50,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: getMonthButtons(onSubDayClick, _date, 30, 100),
                        physics: AlwaysScrollableScrollPhysics(),
                    )
                ),
                SizedBox(height:30),
                Text(
                    " SIDE",
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w300,
                        color: textColors[theme],
                        letterSpacing: 2
                    )
                ),
                SizedBox(height:10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: getButtons(theme, widget.themeButtonFunction),
                ),
                SizedBox(height:30),
                Text(
                    " CURRENCY",
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
                    margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: DropdownButton(
                        icon: Container(),
                        value: _currencyVal,
                        elevation: 0,
                        underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent[400],
                        ),
                        onChanged: (String _newVal) {
                            setState(() {
                                currency = _newVal;
                                _currencyVal = _newVal;
                                settings["currency"] = currency;
                                saveSettings();
                            });
                        },
                        items: currencies.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                    value,
                                    style: TextStyle(
                                        color: textColors[theme],
                                        fontSize: 25,
                                        fontFamily: "Montserrat",
                                    ),
                                    textAlign: TextAlign.center,
                                ),
                            );
                        })
                        .toList()
                    ),
                ),                
                SizedBox(height:60),
                RawMaterialButton(
                    shape: new CircleBorder(),
                    onPressed: widget.resetSettingsAction,
                    child: Text(
                        "RESET SETTINGS",
                        style: TextStyle(
                            fontSize: 28,
                            fontFamily: "Montserrat",
                            letterSpacing: 3,
                            color: Colors.redAccent[400]
                        )
                    ),
                    elevation: 0.0,
                    highlightElevation: 1.0,
                    padding: EdgeInsets.all(10),
                ),
            ],
        );
    }
}