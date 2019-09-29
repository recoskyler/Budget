import 'package:budget/modules/enums.dart';
import 'package:budget/modules/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../modules/components.dart';
import '../../modules/settings.dart';
import 'package:budget/modules/classes.dart';

PreferredSizeWidget rentHead() {
    return appBarWithGradientTitle(
        "RENT", 
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

    RentScreen({Key key, this.controller}) : super(key: key);

    @override
    RentScreenState createState() => RentScreenState();
}

class RentScreenState extends State<RentScreen> {
    void setPaid({Key key, int rentID, int utilityID, bool rentPaid, bool utilityPaid}) {
        List _t = List.from(settings["transactions"]);
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
            settings["transactions"] = _t;
            saveSettings();
        });
    }

    void setUtilityAmount(int _id, double _amount) {
        List _t = List.from(settings["transactions"]);
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

        setState(() {
            settings["transactions"] = _t;
            saveSettings();
        });
    }

    @override
	Widget build(BuildContext context) {
        List<Widget> _rentCards = getRentCards(setPaid, setUtilityAmount);

        return PageView(
            scrollDirection: Axis.horizontal,
            children: _rentCards,
            physics: AlwaysScrollableScrollPhysics(),
            controller: widget.controller,
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