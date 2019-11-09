/// Made by Adil Atalay Hamamcıoğlu (Recoskyler), 2019
/// Please check the GitHub Page for usage rights.
/// https://github.com/recoskyler/Budget
///

import 'package:budget/modules/enums.dart';
import 'package:budget/modules/functions.dart';
import '../main.dart';
import 'classes.dart';
import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:intl/intl.dart';
import 'settings.dart';
import 'global.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

AppBar appBarWithGradientTitle(String txt, double size, Color c1, Color c2, Color background, [double elev = 1.0, bool center = true, String family = '', FontWeight weight = FontWeight.normal, double spacing = 1.0, bool statsButton = false, Function statsAction]) {
    return 
    AppBar(
        iconTheme: IconThemeData(color: Colors.grey[700]),
        title: GradientText(
            txt,
            gradient: LinearGradient(colors: [c1, c2]),
            style: TextStyle(
                fontSize: size,
                fontFamily: family,
                fontWeight: weight,
                letterSpacing: spacing
            ),
        ),
        backgroundColor: background,
        elevation: elev,
        centerTitle: center,
        actions: !statsButton ? [] : [
            RawMaterialButton(
                child: Icon(Icons.show_chart),
                elevation: 0.0,
                shape: CircleBorder(),
                onPressed: statsAction,
            )
        ],
    );
}

Container boxContGradient(double margin, double padding, double h, double radius, double borderWidth, Color borderColor, Alignment b, Alignment e, List<double> gradStops, List<Color> gradColors, Widget chld) {
    return
    Container(
        margin: EdgeInsets.all(margin),
        padding: EdgeInsets.all(padding),
        constraints: BoxConstraints.expand(
            height: h,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(radius)
            ),
            border: Border.all(
                width: borderWidth,
                color: borderColor
            ),
            gradient: LinearGradient(
                begin: b,
                end: e,
                stops: gradStops,
                colors: gradColors
            ),
        ),
        child: chld
    );
}

Column infoBlock(double _amount, String _currency, String _name, Color _color, CrossAxisAlignment _align, [int _decimals = 2, double _titleSize = 4.5, double _amountSize = 8]) {
    if (_currency == null) _currency = "";

    String _amountStr = _currency + _amount.toStringAsFixed(_decimals);

    return
    Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: _align,
        children: [
            Text(
                " $_name",
                style: TextStyle(
                    color: textColors[theme],
                    fontFamily: "Montserrat",
                    fontSize: _titleSize * SizeConfig.safeBlockHorizontal,
                    fontWeight: FontWeight.w300
                )
            ),
            Text(
                "$_amountStr",
                style: TextStyle(
                    color: _color,
                    fontFamily: "Montserrat",
                    fontSize: _amountSize * SizeConfig.safeBlockHorizontal,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1
                )
            )
        ]
    );
}

Container customButton(double s, Color backColor, Color c, IconData i, String txt, Function oP, EdgeInsets edge, [double w = 0, double h = 0]) {
    return Container(
        margin: edge,
        height: h == 0.0 ? null : h,
        width: w == 0.0 ? null : w,
        child: new RawMaterialButton(
            fillColor: backColor,
            shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular((w == 0 || h == 0 ? 50 : w * h))),
            elevation: 0.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    Icon(
                        i,
                        color: c,
                        size: s * 1.6
                    ),
                    Container(
                        child: Text(
                            txt, 
                            style: TextStyle(
                                fontSize: s, 
                                color: c,
                                fontFamily: "FiraCode"
                            ),
                            textAlign: TextAlign.center
                        )
                    )
                ],
            ),
            highlightElevation: 1,
            onPressed: oP,
        )
    );
}

Widget subscriptionItemBlock(String txt, String _currency, DateTime date, int renewal, PaymentType t, double amount, int id, Function op, Function bp, Function dp) {
    if (_currency == null) _currency = "";

    String _monS = _currency + amount.toStringAsFixed(2);
    String _remTxt = lBase.buttons.cancel;
    Color _monC = Colors.red;

    if (txt.length > 25) {
        txt = txt.substring(0, 24);
    }

    // * Set Amount Text Color

    if (savingPaymentTypes.contains(t))
        _monC = Colors.amber[800];
    
    return GestureDetector(
        onTap: () {op(id);},
        child: Container(
            decoration: BoxDecoration(
                color: selectedSubID == id ? selectedItemColors[theme] : themeColors[theme],
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            padding: EdgeInsets.only(top:10, right:10, left:10),
            child: 
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            Expanded(
                                child: 
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(
                                            "${lBase.subTitles.day} ${renewal.toString()} | ${DateFormat('dd/MM/yyyy').format(date)}",
                                            style: TextStyle(
                                                color: dimTextColors[theme],
                                                fontSize: 3.3 * SizeConfig.safeBlockHorizontal,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1.1
                                            )
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                            txt,
                                            style: TextStyle(
                                                color: textColors[theme],
                                                fontSize: 4 * SizeConfig.safeBlockHorizontal,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1.1
                                            )
                                        )
                                    ]
                                )
                            ),
                            Expanded(
                                child: Text(
                                    _monS,
                                    style: TextStyle(
                                        color: _monC,
                                        fontSize: 6 * SizeConfig.safeBlockHorizontal,
                                        fontFamily: "Montserrat",
                                        letterSpacing: 1.5,
                                    ),
                                    textAlign: TextAlign.right,
                                )
                            )
                        ],
                    ),
                    AnimatedContainer(
                        height: selectedSubID == id ? 80 : 0,
                        duration: Duration(milliseconds: 120),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                                RawMaterialButton(
                                    shape: new CircleBorder(),
                                    onPressed: () {bp(id, dp);},
                                    child: Text(
                                        _remTxt,
                                        style: TextStyle(
                                            fontSize: 8 * SizeConfig.safeBlockHorizontal,
                                            fontFamily: "Montserrat",
                                            letterSpacing: 3,
                                            color: Colors.redAccent[400]
                                        )
                                    ),
                                    elevation: 0.0,
                                    highlightElevation: 1.0,
                                    padding: EdgeInsets.all(10),
                                )
                            ],
                        ),
                    )
                ],
            )
        )
    );
}

Widget transactionItemBlock(String txt, String _currency, DateTime date, PaymentType t, double amount, int id, Function op, Function bp, Function dp) {
    if (_currency == null) _currency = "";

    String _monS = _currency + amount.toStringAsFixed(2);
    String _datS = DateFormat('dd/MM/yyyy').format(date);
    Color _monC = Colors.red;
    String _remTxt = lBase.buttons.remove;

    if (txt.length > 25) {
        txt = txt.substring(0, 24);
    }

    if (fixedPaymentTypes.contains(t))
        _remTxt = lBase.buttons.cancel;

    // * Set Amount Text Color

    if (t == PaymentType.Deposit) 
        _monC = Colors.greenAccent[700];
    else if (savingPaymentTypes.contains(t))
        _monC = Colors.amber[800];
    else if (t == PaymentType.SavingExpense)
        _monC = Colors.deepPurpleAccent;
    else if (t == PaymentType.SavingToBudget)
        _monC = Colors.indigo[900];
    

    /*
    return Dismissible(
        key: Key(id.toString() + txt),
        background: Container(alignment: Alignment.center, color: Colors.red, child: Icon(Icons.delete, color: Colors.white,)),
        direction: DismissDirection.horizontal,
        onDismissed: (_) {
            if (dp != null) bp(id, dp); 
            selectedID = -1;
        },
        child: Container(
            decoration: BoxDecoration(
                color: selectedID == id ? selectedItemColors[theme] : themeColors[theme],
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            padding: EdgeInsets.only(top:10, right:10, left:10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            Expanded(
                                child: 
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(
                                            _datS,
                                            style: TextStyle(
                                                color: dimTextColors[theme],
                                                fontSize: 3.3 * SizeConfig.safeBlockHorizontal,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1.1
                                            )
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                            txt,
                                            style: TextStyle(
                                                color: textColors[theme],
                                                fontSize: 4 * SizeConfig.safeBlockHorizontal,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1.1
                                            )
                                        )
                                    ]
                                )
                            ),
                            Expanded(
                                child: Text(
                                    _monS,
                                    style: TextStyle(
                                        color: _monC,
                                        fontSize: 6 * SizeConfig.safeBlockHorizontal,
                                        fontFamily: "Montserrat",
                                        letterSpacing: 1.5,
                                    ),
                                    textAlign: TextAlign.right,
                                )
                            )
                        ],
                    ),
                    transactionItemDivider(),
                ],
            )
        ),
    );
    */

    return GestureDetector(
        onTap: () {
            if (op != null) op(id);
        },
        child: Container(
            decoration: BoxDecoration(
                color: selectedID == id ? selectedItemColors[theme] : themeColors[theme],
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            padding: EdgeInsets.only(top:10, right:10, left:10),
            child: 
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            Expanded(
                                child: 
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(
                                            _datS,
                                            style: TextStyle(
                                                color: dimTextColors[theme],
                                                fontSize: 3.3 * SizeConfig.safeBlockHorizontal,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1.1
                                            )
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                            txt,
                                            style: TextStyle(
                                                color: textColors[theme],
                                                fontSize: 4 * SizeConfig.safeBlockHorizontal,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1.1
                                            )
                                        )
                                    ]
                                )
                            ),
                            Expanded(
                                child: Text(
                                    _monS,
                                    style: TextStyle(
                                        color: _monC,
                                        fontSize: 6 * SizeConfig.safeBlockHorizontal,
                                        fontFamily: "Montserrat",
                                        letterSpacing: 1.5,
                                    ),
                                    textAlign: TextAlign.right,
                                )
                            )
                        ],
                    ),
                    AnimatedContainer(
                        height: selectedID == id ? 80 : 0,
                        duration: Duration(milliseconds: 120),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                                RawMaterialButton(
                                    onPressed: () {
                                        if (dp != null) bp(id, dp);
                                        selectedID = -1;
                                    },
                                    child: Text(
                                        _remTxt,
                                        style: TextStyle(
                                            fontSize: 8 * SizeConfig.safeBlockHorizontal,
                                            fontFamily: "Montserrat",
                                            letterSpacing: 3,
                                            color: Colors.redAccent[400]
                                        )
                                    ),      
                                    elevation: 0.0,
                                    highlightElevation: 1.0,
                                    padding: EdgeInsets.all(10),
                                )
                            ],
                        ),
                    )
                ],
            )
        )
    );
}

// TODO Fix this part

List<Widget> getMonthTransactions(Function op, Function dp, Function fp, [DateTime _date]) {
    List<Widget> _tr = new List<Widget>();
    List<Payment> _pt = new List<Payment>();
    List _t = orderByDateDescending(List<Payment>.from(settings["transactions"]));
    int _renewalDay = settings["budgetRenewalDay"];
    bool _pushBreak = false;

    _t.addAll(List<Payment>.from(settings["fixedPayments"]));

    if (_date == null) _pushBreak = true;

    _date = _date == null ? DateTime.now() : _date;

    for (int i = 0; i < _t.length; i++) {
        Payment _p = _t[i];

        if (!thisMonths(_p.getDate(), _renewalDay, _date) && _pushBreak && !fixedPaymentTypes.contains(_p.getPaymentType())) {
            //break;
        }

        if (fixedPaymentTypes.contains(_p.getPaymentType()) && _p.getDate().compareTo(_date) > 0) continue;

        if (!fixedPaymentTypes.contains(_p.getPaymentType()) && thisMonths(_p.getDate(), _renewalDay, _date)) {
            _pt.add(_p);
        } else if (fixedPaymentTypes.contains(_p.getPaymentType()) && thisMonths(_p.getFPRenewalDate(_date), _renewalDay, _date) && _p.getDate().compareTo(_date) <= 0) {
            _pt.add(_p);
        } else if (fixedPaymentTypes.contains(_p.getPaymentType()) && _p.getDate().compareTo(_date) <= 0 && _p.getRenewalDay() <= _date.day) {
            //_pt.add(_p);
        } else if (fixedPaymentTypes.contains(_p.getPaymentType()) && _p.getDate().compareTo(_date) <= 0 && !_pushBreak) {
            //_pt.add(_p);
        }
    }

    _pt = orderByDateDescending(_pt);

    _pt.forEach((_p) {
        if (fixedPaymentTypes.contains(_p.getPaymentType())) {
            _tr.add(transactionItemFromPayment(_p, op, dp, fp, new DateTime(_date.year, _date.month, _p.getRenewalDay())));
        } else {
            _tr.add(transactionItemFromPayment(_p, op, dp, fp));
        }

        _tr.add(transactionItemDivider());
    });

    _tr.add(SizedBox(height:100));

    return _tr;
}

List<Widget> getMonthSubscriptions(Function op, Function dp) {
    List<Widget> _tr = new List<Widget>();
    List<Payment> _pt = new List<Payment>();
    List _t = List.from(settings["fixedPayments"]);

    for (int i = 0; i < _t.length; i++) {
        Payment _p = _t[i];

        if (fixedPaymentTypes.contains(_p.getPaymentType())) {
            _pt.add(_p);
        }
    }

    _pt.forEach((_p) {
        _tr.add(subscriptionItemFromPayment(_p, op, dp));
        _tr.add(transactionItemDivider());
    });

    _tr.add(SizedBox(height:100));

    return _tr;
}

ListView transactionsBlock(String _currency, Function op, Function dp, Function fp, [DateTime _date]) {
    return 
    ListView(
        children: getMonthTransactions(op, dp, fp, _date)
    );
}

ListView subscriptionsBlock(String _currency, Function op, Function dp) {
    return 
    ListView(
        children: getMonthSubscriptions(op, dp)
    );
}

Widget transactionItemDivider() {
    return Divider(indent: 10, endIndent: 10, color: dimTextColors[theme], thickness: 1);
}

ListView namesBlock(Function _op, int _indexVar) {
    List<Widget> _items = new List<Widget>();
    List _names = transactionDescriptions;
    int i = 0;

    _items.add(SizedBox(width: 10));

    _names.forEach((var _name) {
        Container _btn = Container(
            height: 50,
            child: FloatingActionButton.extended(
                heroTag: i + 5,
                backgroundColor: (i == _indexVar ? Colors.redAccent[400] : dayButtonColors[theme]),
                label: Text(
                    _name,
                    style: TextStyle(
                        fontFamily: "FiraCode",
                        fontSize: buttonTextSize,
                        color: (i != _indexVar ? dayButtonTextColors[theme] : Colors.white)
                    ),
                    textAlign: TextAlign.center
                ),
                onPressed: () {_op(_names.indexOf(_name));},
                elevation: 0.0,
                highlightElevation: 1.0,
            )
        );
        
        _items.add(_btn);
        _items.add(SizedBox(width: 10));

        i++;
    });

    _items.add(SizedBox(width: 10));

    return ListView(
        scrollDirection: Axis.horizontal,
        children: _items
    );
}

List<Widget> getRentCards(Function setPaid, Function setUtilityAmount) {
    List<Widget> _tr = new List<Widget>();
    List<Payment> _t = List<Payment>.from(settings["rents"]);

    rentPage = -1;
    int _page = -1;

    if (settings["rentAmount"] == 0.0) {
        settings["rentPage"] = 0;
        saveSettings();

        return [
            Container(
                alignment: Alignment.center,
                child: Text(
                    lBase.misc.tapRent,
                    style: TextStyle(
                        fontSize: 4 * SizeConfig.safeBlockHorizontal,
                        fontFamily: "Montserrat",
                        color: Colors.grey[400]
                    ),
                    textAlign: TextAlign.center,
                ),
            )
        ];
    }

    for (int i = 0; i < _t.length; i++) {
        Payment _p = _t[i];
        Payment _u = _t[i];

        if (i + 1 < _t.length)
            _u = _t[i + 1];

        if (rentalPaymentTypes.contains(_p.getPaymentType()) && _p.getPaymentType() != PaymentType.PaidUtility && _p.getPaymentType() != PaymentType.Utility) {
            _page++;

            _tr.add(
                Container(
                    alignment: Alignment.center,
                    height: SizeConfig.blockSizeVertical * 80,
                    decoration: BoxDecoration(
                        border: Border.all(color: dimTextColors[theme], width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    margin: EdgeInsets.fromLTRB(25, 5, 25, 50),
                    padding: EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                            SizedBox(height: 10),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    Icon(i == 1 ? null : Icons.keyboard_arrow_left, color: dimTextColors[theme]),
                                    Text(
                                        DateFormat('MM/yyyy').format(_p.getDate()),
                                        textAlign: TextAlign.center,
                                        style: subTitle
                                    ),
                                    Icon(i == _t.length - 2 ? null : Icons.keyboard_arrow_right, color: dimTextColors[theme]),
                                ],
                            ),
                            SizedBox(height: 100),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                            Text(
                                                lBase.subTitles.rent,
                                                textAlign: TextAlign.left,
                                                style: subTitle
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                                settings["currency"] + _p.getAmount().toStringAsFixed(0),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: _p.getPaymentType() == PaymentType.Rent ? Colors.red : Colors.greenAccent[700],
                                                    fontFamily: "Montserrat",
                                                    fontSize: amountTextSize
                                                ),
                                            ),
                                        ],
                                    ),
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                            Text(
                                                lBase.subTitles.utilities,
                                                textAlign: TextAlign.right,
                                                style: subTitle
                                            ),
                                            Container(
                                                alignment: Alignment.centerRight,
                                                height: 60,
                                                width: SizeConfig.blockSizeHorizontal * 35,
                                                child: TextField(
                                                    textAlign: TextAlign.end,
                                                    expands: false,
                                                    controller: new MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', initialValue: _u.getAmount(), ),
                                                    keyboardType: TextInputType.number,
                                                    decoration: new InputDecoration(
                                                        focusedBorder: new UnderlineInputBorder(borderSide: BorderSide(color: _u.getPaymentType() == PaymentType.Utility ? Colors.red : Colors.greenAccent[700])),
                                                        enabledBorder: new UnderlineInputBorder(borderSide: BorderSide(color: _u.getPaymentType() == PaymentType.Utility ? Colors.red : Colors.greenAccent[700]))
                                                    ),
                                                    cursorColor: _u.getPaymentType() == PaymentType.Utility ? Colors.red : Colors.greenAccent[700],
                                                    style: TextStyle(
                                                        fontSize: amountTextSize,
                                                        fontFamily: "Montserrat",
                                                        color: _u.getPaymentType() == PaymentType.Utility ? Colors.red : Colors.greenAccent[700]
                                                    ),
                                                    onSubmitted: (_t) {
                                                        setUtilityAmount(_u.getID(), double.parse(_t.replaceAll(',', '').replaceAll(settings["currency"], "")));
                                                    },
                                                    onChanged: (_t) {
                                                        setUtilityAmount(_u.getID(), double.parse(_t.replaceAll(',', '').replaceAll(settings["currency"], "")), false);
                                                    },
                                                )
                                            ),
                                        ],
                                    ),
                                ],
                            ),
                            SizedBox(height: 30),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    Container(
                                        width: 35 * SizeConfig.safeBlockHorizontal,
                                        child: customButton(
                                            buttonTextSize,
                                            _p.isPaid() ? Colors.indigoAccent[700] : Colors.blue[100],
                                            _p.isPaid() ? Colors.white : Colors.indigo[700],
                                            _p.isPaid() ? Icons.done : Icons.close,
                                            _p.isPaid() ? lBase.buttons.paid : lBase.buttons.notPaid,
                                            () {
                                                setPaid(rentID: _p.getID(), rentPaid: !_p.isPaid(), utilityID: _u.getID(), utilityPaid: _u.isPaid());
                                            },
                                            null
                                        )
                                    ),
                                    Container(
                                        width: 35 * SizeConfig.safeBlockHorizontal,
                                        child: customButton(
                                            buttonTextSize,
                                            _u.isPaid() ? Colors.deepOrangeAccent[400] : Colors.deepOrange[100],
                                            _u.isPaid() ? Colors.white : Colors.deepOrangeAccent[400],
                                            _u.isPaid() ? Icons.done : Icons.close,
                                            _u.isPaid() ? lBase.buttons.paid : lBase.buttons.notPaid,
                                            () {
                                                setPaid(utilityID: _u.getID(), utilityPaid: !_u.isPaid(), rentID: _p.getID(), rentPaid: _p.isPaid());
                                            },
                                            null
                                        )
                                    )
                                ],
                            )
                        ],
                    ),
                )
            );

            if (_p.getPaymentType() == PaymentType.Rent && rentPage == -1) {
                rentPage = _page;
                settings["rentPage"] = _page;
                saveSettings();
            }
        }
    }

    return _tr;
}

List<Widget> getTransactionCards(Function op, Function dp, Function fp) {
    List<Widget> _tr = new List<Widget>();
    List<DateTime> _dates = getAllDates();
    _dates.sort((a, b) => a.compareTo(b));

    _dates.forEach((DateTime _date) {
        Color _color = getRenewalDate(_date, settings["budgetRenewalDay"]) == getRenewalDate(DateTime.now(), settings["budgetRenewalDay"]) ? Colors.cyanAccent[700] : dimTextColors[theme];
        DateTime _paramDate = _date;
        String _nextDateString = "${settings["budgetRenewalDay"]}/${DateFormat("MM/yyyy").format(getNextRenewalDate(_date, settings["budgetRenewalDay"])).toString()}";

        if (getRenewalDate(_date, settings["budgetRenewalDay"]) == getRenewalDate(DateTime.now(), settings["budgetRenewalDay"])) {
            _nextDateString = lBase.subTitles.today;
        }

        if (getRenewalDate(_date, settings["budgetRenewalDay"]).compareTo(getRenewalDate(DateTime.now(), settings["budgetRenewalDay"])) == 0) {
            _paramDate = null;
        }

        _tr.add(
            Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: _color, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                ),constraints: BoxConstraints.expand(),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                        Container(
                            height: 20,
                            child: Text(
                                "${settings["budgetRenewalDay"]}/${DateFormat("MM/yyyy").format(_date).toString()} - $_nextDateString",
                                style: subTitle,
                                textAlign: TextAlign.center,
                            )
                        ),
                        Divider(color: _color),
                        Row(
                            children: [
                            Expanded(
                                child: infoBlock(calculateAllowence(_paramDate), currency, lBase.subTitles.budget,
                                    Colors.greenAccent[700], CrossAxisAlignment.start, 0, 3.5, 7)),
                            Expanded(
                                child: infoBlock(calculateExpenses(false, _paramDate), currency, lBase.subTitles.expenses, Colors.red,
                                    CrossAxisAlignment.end, 2, 3.5, 7)),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        SizedBox(height: 30),
                        Row(
                            children: [
                            Expanded(
                                child: infoBlock(calculateSavings(_paramDate), currency, lBase.subTitles.savings,
                                    Colors.amber[800], CrossAxisAlignment.start, 0, 3.5, 7)),
                            Expanded(
                                child: infoBlock(budget - calculateExpenses(false, _paramDate), currency, lBase.subTitles.remaining,
                                    budget - calculateExpenses(false, _paramDate) >= 0
                                        ? Colors.blueAccent[700]
                                        : Colors.redAccent[700],
                                    CrossAxisAlignment.end, 2, 3.5, 7)),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        SizedBox(height: 20),
                        Divider(color: _color),
                        SizedBox(height: 20),
                        Text(
                            lBase.subTitles.transactions,
                            style: subTitle
                        ),
                        SizedBox(height: 10),
                        Divider(color: _color),
                        Expanded(child: transactionsBlock(currency, op, dp, fp, _paramDate)),
                    ],
                ),
            ),
        );
    });

    return _tr;
}

Widget brokenWidget() {
    return Text(
        lBase.misc.broken,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.red,
            fontFamily: "FiraCode",
            fontSize: SizeConfig.safeBlockHorizontal * 4,
        ),
    );
}