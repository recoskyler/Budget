/// Made by Adil Atalay Hamamcıoğlu (Recoskyler), 2019
/// Please check the GitHub Page for usage rights.
/// https://github.com/recoskyler/Budget
///

import 'package:budget/modules/components.dart';
import 'package:budget/modules/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import '../../main.dart';
import '../../modules/theme_icons.dart';

double _amount = 0.0;
int _date = 1;

PreferredSizeWidget setupHead() {
    return appBarWithGradientTitle(
        lBase.titles.setup, 
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

class SetupScreen extends StatefulWidget {
    final Function themeButtonFunction;

    SetupScreen({Key key, this.themeButtonFunction}) : super(key: key);

    _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
    final controller = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', );
    
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
                                fontSize: buttonTextSize,
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
                customButton(buttonTextSize, Colors.red, Colors.white, CustomIcons.rebel, lBase.buttons.rebel, () {_top(0);}, EdgeInsets.fromLTRB(0, 0, 0, 0), SizeConfig.blockSizeHorizontal * 35, 50.0),
                SizedBox(width:5),
                customButton(buttonTextSize, Colors.grey[300], Colors.grey[900], CustomIcons.empire, lBase.buttons.empire, () {_top(1);}, EdgeInsets.fromLTRB(0, 0, 0, 0), SizeConfig.blockSizeHorizontal * 35, 50.0)
            ];
        } else if (s == 1) {
            return [
                customButton(buttonTextSize, Colors.red[50], Colors.red, CustomIcons.rebel, lBase.buttons.rebel, () {_top(0);}, EdgeInsets.fromLTRB(0, 0, 0, 0), SizeConfig.blockSizeHorizontal * 35, 50.0),
                SizedBox(width:5),
                customButton(buttonTextSize, Colors.grey[900], Colors.white, CustomIcons.empire, lBase.buttons.empire, () {_top(1);}, EdgeInsets.fromLTRB(0, 0, 0, 0), SizeConfig.blockSizeHorizontal * 35, 50.0)
            ];
        }

        return [];
    }

    void onSubDayClick(int index) {
        setState(() {
            _date = index;
        });
    }

    @override
    Widget build(BuildContext context) {
        SizeConfig().init(context);

        return Container(
            margin: globalInset,
            child: ListView(
                children: [
                    Divider(),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            SizedBox(height:10),
                            Text(
                                lBase.subTitles.allowanceAmount,
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
                                        fontSize: amountTextSize,
                                        fontFamily: "Montserrat",
                                        color: Colors.greenAccent[700]
                                    ),
                                    onSubmitted: (_t) {
                                        _amount = controller.numberValue;
                                    },
                                    onChanged: (_t) {
                                        _amount = controller.numberValue;
                                    },
                                )
                            ),
                            SizedBox(height:30),
                            Text(
                                lBase.subTitles.renewalDay,
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
                                lBase.subTitles.side,
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
                        ]                    
                    )
                ]
            )
        );
    }
}

class SetupButton extends StatefulWidget {
    final Function onActionPressed;

    SetupButton({Key key, this.onActionPressed}) : super(key: key);

    @override
    SetupButtonState createState() => SetupButtonState();
}

class SetupButtonState extends State<SetupButton> {
    @override
	Widget build(BuildContext context) {        
        return GestureDetector(
            child: FloatingActionButton(
                heroTag: "setupScreenButton",
                child: Icon(Icons.done),
                backgroundColor: buttonStates[1][buttonStateIndex % 2],
                elevation: 0.0,
                onPressed: () {widget.onActionPressed(_amount, _date);},
                highlightElevation: 1.0,
            )
        );
    }
}