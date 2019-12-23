import 'package:budget/main.dart';
/// Made by Adil Atalay Hamamcıoğlu (Recoskyler), 2019
/// Please check the GitHub Page for usage rights.
/// https://github.com/recoskyler/Budget
///

import 'package:budget/modules/enums.dart';
import 'package:budget/modules/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../modules/components.dart';
import '../../modules/settings.dart';
import 'package:budget/modules/classes.dart';

PreferredSizeWidget rentHead([BuildContext context]) {
    return appBarWithGradientTitle(
        lBase.titles.rent, 
        25,
        Colors.indigoAccent[700], 
        Colors.indigo[900], 
        themeColors[theme], 
        0.0, 
        true, 
        'FiraCode', 
        FontWeight.w400, 
        1.5
    );
}

class RentScreen extends StatefulWidget {
    final PageController controller;
    final Function onActionPressed;
    final double dialogState;

    RentScreen({Key key, this.controller, this.onActionPressed, this.dialogState}) : super(key: key);

    @override
    RentScreenState createState() => RentScreenState();
}

class RentScreenState extends State<RentScreen> {
    void setPaid({Key key, int rentID, int utilityID, bool rentPaid, bool utilityPaid}) {
        List _t = List.from(settings["rents"]);
        int _ri = 0;
        int _ui = 0;
        Payment _rp;
        Payment _up;

        for (int i = 0; i < _t.length; i++) {
            Payment _p = _t[i];

            if (_p.getID() == rentID) {
                _p.paymentType = rentPaid ? PaymentType.PaidRent : PaymentType.Rent;
                _ri = i;
                _rp = _p;
            } else if (_p.getID() == utilityID) {
                _p.paymentType = utilityPaid ? PaymentType.PaidUtility : PaymentType.Utility;
                _ui = i;
                _up = _p;
            }
        }

        _t[_ri] = _rp;
        _t[_ui] = _up;

        setState(() {
            settings["rents"] = _t;
            saveSettings();
        });
    }

    void setUtilityAmount(int _id, double _amount, [bool _perm = true]) {
        List _t = List.from(settings["rents"]);
        int _ui = 0;
        Payment _up;

        for (int i = 0; i < _t.length; i++) {
            Payment _p = _t[i];

            if (_p.getID() == _id) {
                _p.amount = _amount;
                _ui = i;
                _up = _p;
            }
        }

        _t[_ui] = _up;

        if (_perm) {
            setState(() {
                settings["rents"] = _t;
                saveSettings();
            });
        } else {
            settings["rents"] = _t;
            saveSettings();
        }
    }

    @override
	Widget build(BuildContext context) {
        List<Widget> _rentCards = getRentCards(setPaid, setUtilityAmount);

        return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
                Container(
                    height: SizeConfig.blockSizeVertical * 65,
                    child: PageView(
                        scrollDirection: Axis.horizontal,
                        children: _rentCards,
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: widget.controller,
                    ),
                ),
                AnimatedContainer(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 40),
                    height: widget.dialogState * 10 * SizeConfig.safeBlockVertical,
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
                                onPressed: widget.onActionPressed,
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

class RentButton extends StatefulWidget {
    final Function onActionPressed;

    RentButton({Key key, this.onActionPressed}) : super(key: key);

    @override
    RentButtonState createState() => RentButtonState();
}

class RentButtonState extends State<RentButton> {
    @override
	Widget build(BuildContext context) {
        return GestureDetector(
            child: FloatingActionButton(
                mini: true,
                heroTag: "rentscreen",
                child: Icon(settings["rentAmount"] == 0.0 ? Icons.add : Icons.close),
                backgroundColor: settings["rentAmount"] == 0.0 ? Colors.greenAccent[400] : Colors.redAccent[400],
                elevation: 0.0,
                onPressed: widget.onActionPressed,
                highlightElevation: 1.0,
                tooltip: settings["rentAmount"] == 0.0 ? "Set up rent and utilities" : "Remove rent and utility configuration",
            )
        );
    }
}