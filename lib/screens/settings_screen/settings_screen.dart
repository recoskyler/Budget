/// Made by Adil Atalay Hamamcıoğlu (Recoskyler), 2019
/// Please check the GitHub Page for usage rights.
/// https://github.com/recoskyler/Budget
///

import 'package:budget/main.dart';
import 'package:budget/modules/components.dart';
import 'package:budget/modules/theme_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import '../../modules/settings.dart';
import '../../modules/global.dart';
import 'package:budget/modules/functions.dart';

double _resetDialogState = 0;

PreferredSizeWidget settingsHead() {
    return appBarWithGradientTitle(
        lBase.titles.settings, 
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
    var controller = new MoneyMaskedTextController(precision: 0, decimalSeparator: '', thousandSeparator: ',',  initialValue: settings["monthlyAllowence"]);
    
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

    List<Widget> getButtons(int s, Function _top) {
        if (s == 0) {
            return [
                customButton(buttonTextSize, Colors.blueGrey, Colors.white, CustomIcons.rebel, lBase.buttons.rebel, () {_top(0);}, EdgeInsets.fromLTRB(0, 0, 0, 0), 40 * SizeConfig.safeBlockHorizontal, 50.0),
                SizedBox(width:5),
                customButton(buttonTextSize, Colors.grey[300], Colors.grey[900], CustomIcons.empire, lBase.buttons.empire, () {_top(1);}, EdgeInsets.fromLTRB(0, 0, 0, 0), 40 * SizeConfig.safeBlockHorizontal, 50.0)
            ];
        } else if (s == 1) {
            return [
                customButton(buttonTextSize, Colors.blueGrey[100], Colors.blueGrey[800], CustomIcons.rebel, lBase.buttons.rebel, () {_top(0);}, EdgeInsets.fromLTRB(0, 0, 0, 0), 40 * SizeConfig.safeBlockHorizontal, 50.0),
                SizedBox(width:5),
                customButton(buttonTextSize, Colors.grey[900], Colors.white, CustomIcons.empire, lBase.buttons.empire, () {_top(1);}, EdgeInsets.fromLTRB(0, 0, 0, 0), 40 * SizeConfig.safeBlockHorizontal, 50.0)
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
                    lBase.subTitles.allowanceAmount,
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
                            focusedBorder: new UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent[700])),
                            enabledBorder: new UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent[100]))
                        ),
                        cursorColor: Colors.greenAccent[700],
                        style: TextStyle(
                            fontSize: amountTextSize,
                            fontFamily: "Montserrat",
                            color: Colors.greenAccent[700]
                        ),
                        onSubmitted: (_t) {
                            setState(() {
                                _amount = controller.numberValue;
                                settings["monthlyAllowence"] = _amount;
                                saveSettings();
                            });
                        },
                        onChanged: (_t) {
                            setState(() {
                                _amount = controller.numberValue;
                                settings["monthlyAllowence"] = _amount;
                                saveSettings();
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
                        children: getMonthButtons(onSubDayClick, _date, 30, 100),
                        physics: AlwaysScrollableScrollPhysics(),
                    )
                ),
                SizedBox(height:30),
                Text(
                    lBase.subTitles.side,
                    style: subTitle
                ),
                SizedBox(height:10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: getButtons(theme, widget.themeButtonFunction),
                ),
                SizedBox(height:30),
                Text(
                    lBase.subTitles.currency,
                    style: subTitle
                ),
                SizedBox(height:10),
                Container(
                    margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: DropdownButton(
                        icon: Icon(Icons.monetization_on),
                        value: _currencyVal,
                        underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent[400],
                        ),
                        isExpanded: true,
                        onChanged: (String _newVal) {
                            setState(() {
                                currency = _newVal;
                                _currencyVal = _newVal;
                                settings["currency"] = currency;
                                controller = new MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', leftSymbol: currency, initialValue: settings["monthlyAllowence"]);
                                saveSettings();
                            });
                        },
                        items: currencies.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                    value,
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontFamily: "Montserrat",
                                        fontSize: regularTextSize
                                    ),
                                    textAlign: TextAlign.center,
                                ),
                            );
                        })
                        .toList()
                    ),
                ),
                SizedBox(height:30),
                Text(
                    lBase.subTitles.language,
                    style: subTitle
                ),
                SizedBox(height:10),
                Container(
                    margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: DropdownButton(
                        icon: Icon(Icons.translate),
                        value: languages[settingsStorage.getInt("lang")],
                        underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent[400],
                        ),
                        isExpanded: true,
                        onChanged: (String _newVal) {
                            setState(() {
                                settingsStorage.setInt("lang", languages.indexOf(_newVal)).then((_) {
                                    lBase.load(languageLocales[settingsStorage.getInt("lang")]).then((_) {
                                        initTransactionDescriptions();
                                    });
                                });
                            });
                        },
                        items: languages.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                    value,
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontFamily: "Montserrat",
                                        fontSize: regularTextSize
                                    ),
                                    textAlign: TextAlign.center,
                                ),
                            );
                        }).toList()
                    ),
                ),
                SizedBox(height: 40),
                RawMaterialButton(
                    onPressed: () {
                        launchURL("https://github.com/recoskyler/Budget");
                    }, // widget.resetSettingsAction
                    child: Text(
                        lBase.buttons.viewGithub,
                        style: TextStyle(
                            fontSize: subTitleTextSize,
                            fontFamily: "Montserrat",
                            letterSpacing: 3,
                            color: Colors.blueAccent[400],
                        ),
                        textAlign: TextAlign.center,
                    ),
                    elevation: 0.0,
                    highlightElevation: 1.0,
                    padding: EdgeInsets.all(10),
                ),
                SizedBox(height: 60),
                RawMaterialButton(
                    onPressed: () {
                        setState(() {
                            _resetDialogState = _resetDialogState == 0 ? 1 : 0;
                        });
                    }, // widget.resetSettingsAction
                    child: Text(
                        lBase.buttons.reset,
                        style: TextStyle(
                            fontSize: buttonTextSize,
                            fontFamily: "Montserrat",
                            letterSpacing: 3,
                            color: Colors.redAccent[400]
                        )
                    ),
                    elevation: 0.0,
                    highlightElevation: 1.0,
                    padding: EdgeInsets.all(10),
                ),
                AnimatedContainer(
                    margin: EdgeInsets.all(20),
                    height: _resetDialogState * 80,
                    duration: Duration(milliseconds: 120),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: dimTextColors[theme],
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                            RawMaterialButton(
                                onPressed: widget.resetSettingsAction,
                                child: Text(
                                    lBase.buttons.resetSure,
                                    style: TextStyle(
                                        fontSize: 5 * SizeConfig.safeBlockHorizontal,
                                        fontFamily: "Montserrat",
                                        letterSpacing: 3,
                                        color: Colors.redAccent[400],
                                        fontWeight: FontWeight.bold
                                    ),
                                ),      
                                elevation: 0.0,
                                highlightElevation: 1.0,
                                padding: EdgeInsets.all(10),
                            )
                        ],
                    ),
                )
            ],
        );
    }
}