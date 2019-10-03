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

AppBar appBarWithGradientTitle(String txt, double size, Color c1, Color c2, Color background, [double elev = 1.0, bool center = true, String family = '', FontWeight weight = FontWeight.normal, double spacing = 1.0]) {
    return 
    AppBar(
        iconTheme: IconThemeData(color: Colors.grey[700]),
        title: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: GradientText(
                txt,
                gradient: LinearGradient(colors: [c1, c2]),
                style: TextStyle(
                    fontSize: size,
                    fontFamily: family,
                    fontWeight: weight,
                    letterSpacing: spacing
                ),
            )
        ),
        backgroundColor: background,
        elevation: elev,
        centerTitle: center
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

Column expenseBlock(double expense, String _currency) {
    if (_currency == null) _currency = "";

    String _expenseStr = _currency + expense.toStringAsFixed(2);

    return
    Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
            Text(
                "EXPENSE ",
                style: TextStyle(
                    color: textColors[theme],
                    fontFamily: "Montserrat",
                    fontSize: 5 * SizeConfig.safeBlockHorizontal,
                    fontWeight: FontWeight.w300
                )
            ),
            Text(
                "$_expenseStr",
                style: TextStyle(
                    color: Colors.red,
                    fontFamily: "Montserrat",
                    fontSize: 10 * SizeConfig.safeBlockHorizontal,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1
                )
            )
        ]
    );
}

Column subsExpenseBlock(double expense, String _currency) {
    if (_currency == null) _currency = "";

    String _expenseStr = _currency + subexpense.toStringAsFixed(2);

    return
    Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
            Text(
                "FIXED PAYMENTS ",
                style: TextStyle(
                    color: textColors[theme],
                    fontFamily: "Montserrat",
                    fontSize: 5 * SizeConfig.safeBlockHorizontal,
                    fontWeight: FontWeight.w300
                )
            ),
            Text(
                "$_expenseStr",
                style: TextStyle(
                    color: Colors.red,
                    fontFamily: "Montserrat",
                    fontSize: 10 * SizeConfig.safeBlockHorizontal,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1
                )
            )
        ]
    );
}

Column incomeBlock(double income, String _currency) {
    if (_currency == null) _currency = "";

    String _incomeStr = _currency + income.toStringAsFixed(2);

    return
    Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(
                " BUDGET",
                style: TextStyle(
                    color: textColors[theme],
                    fontFamily: "Montserrat",
                    fontSize: 5 * SizeConfig.safeBlockHorizontal,
                    fontWeight: FontWeight.w300
                )
            ),
            Text(
                "$_incomeStr",
                style: TextStyle(
                    color: Colors.greenAccent[700],
                    fontFamily: "Montserrat",
                    fontSize: 10 * SizeConfig.safeBlockHorizontal,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1
                )
            )
        ]
    );
}

Column totalSavingsBlock(double savings, String _currency, ) {
    if (_currency == null) _currency = "";

    String _savingsStr = _currency + savings.toStringAsFixed(2);

    return
    Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(
                " TOTAL SAVINGS",
                style: TextStyle(
                    color: textColors[theme],
                    fontFamily: "Montserrat",
                    fontSize: 5 * SizeConfig.safeBlockHorizontal,
                    fontWeight: FontWeight.w300
                )
            ),
            Text(
                "$_savingsStr",
                style: TextStyle(
                    color: Colors.amber[800],
                    fontFamily: "Montserrat",
                    fontSize: 10 * SizeConfig.safeBlockHorizontal,
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

Column remainingBlock(double remaining, String _currency) {
    if (_currency == null) _currency = "";

    String _remainingStr = _currency + remaining.toStringAsFixed(2);
    Color remC = Colors.blueAccent[700];
    Color remT = textColors[theme];

    if (remaining < 0) {
        remC = Colors.redAccent[700];
        remT = Colors.red;
    }

    return
    Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
            Text(
                "REMAINING ",
                style: TextStyle(
                    color: remT,
                    fontFamily: "Montserrat",
                    fontSize: 5 * SizeConfig.safeBlockHorizontal,
                    fontWeight: FontWeight.w300
                )
            ),
            Text(
                "$_remainingStr",
                style: TextStyle(
                    color: remC,
                    fontFamily: "Montserrat",
                    fontSize: 10 * SizeConfig.safeBlockHorizontal,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1
                )
            )
        ]
    );
}

GestureDetector subscriptionItemBlock(String txt, String _currency, DateTime date, PaymentType t, double amount, int id, Function op, Function bp, Function dp) {
    if (_currency == null) _currency = "";

    String _monS = _currency + amount.toStringAsFixed(2);
    String _remTxt = "CANCEL";
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
                            child: Text(
                                txt,
                                style: TextStyle(
                                    color: textColors[theme],
                                    fontSize: 22 * SizeConfig.safeBlockHorizontal,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.1
                                )
                            )
                        ),
                        Expanded(
                            child: Text(
                                _monS,
                                style: TextStyle(
                                    color: _monC,
                                    fontSize: 25 * SizeConfig.safeBlockHorizontal,
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
                                        fontSize: 2 * SizeConfig.safeBlockHorizontal,
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

GestureDetector transactionItemBlock(String txt, String _currency, DateTime date, PaymentType t, double amount, int id, Function op, Function bp, Function dp) {
    if (_currency == null) _currency = "";

    String _monS = _currency + amount.toStringAsFixed(2);
    String _datS = DateFormat('dd/MM/yyyy').format(date);
    Color _monC = Colors.red;
    String _remTxt = "REMOVE";

    if (txt.length > 25) {
        txt = txt.substring(0, 24);
    }

    if (fixedPaymentTypes.contains(t))
        _remTxt = "CANCEL";

    // * Set Amount Text Color

    if (t == PaymentType.Deposit) 
        _monC = Colors.greenAccent[700];
    else if (savingPaymentTypes.contains(t))
        _monC = Colors.amber[800];
    else if (t == PaymentType.SavingExpense)
        _monC = Colors.deepPurpleAccent;
    else if (t == PaymentType.SavingToBudget)
        _monC = Colors.indigo[900];
    
    return GestureDetector(
        onTap: () {op(id);},
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
                                            fontSize: 3.5 * SizeConfig.safeBlockHorizontal,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.1
                                        )
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                        txt,
                                        style: TextStyle(
                                            color: textColors[theme],
                                            fontSize: 5 * SizeConfig.safeBlockHorizontal,
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
                                    fontSize: 7 * SizeConfig.safeBlockHorizontal,
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

List<Widget> getMonthTransactions(Function op, Function dp) {
    List<Widget> _tr = new List<Widget>();
    List<Payment> _pt = new List<Payment>();
    List _t = List.from(settings["transactions"]);
    int _renewalDay = settings["budgetRenewalDay"];

    for (int i = 0; i < _t.length; i++) {
        Payment _p = _t[i];

        if (fixedPaymentTypes.contains(_p.getPaymentType()) && _p.getDate().compareTo(DateTime.now()) > 0) continue;

        if (thisMonths(_p.getDate(), _renewalDay, DateTime.now()) && !rentalPaymentTypes.contains(_p.getPaymentType())) {
            _pt.add(_p);
        }
    }

    _pt = orderByDateDescending(_pt);

    _pt.forEach((_p) {
        _tr.add(transactionItemFromPayment(_p, op, dp));
        _tr.add(transactionItemDivider());
    });

    return _tr;
}

List<Widget> getMonthSubscriptions(Function op, Function dp) {
    List<Widget> _tr = new List<Widget>();
    List<Payment> _pt = new List<Payment>();
    List _t = List.from(settings["transactions"]);

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

    return _tr;
}

ListView transactionsBlock(String _currency, Function op, Function dp) {
    return 
    ListView(
        children: getMonthTransactions(op, dp)
    );
}

ListView subscriptionsBlock(String _currency, Function op, Function dp) {
    return 
    ListView(
        children: getMonthSubscriptions(op, dp)
    );
}

Divider transactionItemDivider() {
    return Divider(indent: 10, endIndent: 10, color: Colors.grey[400]);
}

ListView namesBlock(Function _op, int _indexVar) {
    List<Widget> _items = new List<Widget>();
    List _names = settings["transactionDescriptions"];
    int i = 0;

    _items.add(SizedBox(width: 10));

    _names.forEach((var _name) {
        Container _btn = Container(
            height: 50,
            child: FloatingActionButton.extended(
                heroTag: i + 5,
                backgroundColor: (i == _indexVar ? Colors.redAccent[400] : Colors.red[50]),
                label: Text(
                    _name,
                    style: TextStyle(
                        fontFamily: "FiraCode",
                        fontSize: 20,
                        color: (i != _indexVar ? Colors.redAccent[400] : Colors.white)
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
    List _t = List.from(settings["transactions"]);

    rentPage = -1;
    int _page = -1;

    print(settings["rentAmount"]);

    if (settings["rentAmount"] == 0.0) {
        settings["rentPage"] = 0;
        saveSettings();

        return [
            Container(
                alignment: Alignment.center,
                child: Text(
                    "Tap the button below to set up rent and utilities.",
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
                    height: 200,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300], width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    margin: EdgeInsets.fromLTRB(25, 5, 25, 50),
                    padding: EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                            SizedBox(height: 10),
                            Text(
                                DateFormat("MM/yyyy").format(_p.getDate()),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontFamily: "Montserrat",
                                    fontSize: 20 * SizeConfig.safeBlockHorizontal
                                ),
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
                                                "RENT",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontFamily: "Montserrat",
                                                    fontSize: 22 * SizeConfig.safeBlockHorizontal
                                                ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                                settings["currency"] + _p.getAmount().toStringAsFixed(2),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: _p.getPaymentType() == PaymentType.Rent ? Colors.red : Colors.greenAccent[700],
                                                    fontFamily: "Montserrat",
                                                    fontSize: 34 * SizeConfig.safeBlockHorizontal
                                                ),
                                            ),
                                        ],
                                    ),
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                            Text(
                                                "UTILITIES ",
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontFamily: "Montserrat",
                                                    fontSize: 22 * SizeConfig.safeBlockHorizontal
                                                ),
                                            ),
                                            Container(
                                                alignment: Alignment.centerRight,
                                                height: 70,
                                                width: 150,
                                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                child: TextField(
                                                    textAlign: TextAlign.end,
                                                    expands: false,
                                                    controller: new MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', initialValue: _u.getAmount(), leftSymbol: settings["currency"]),
                                                    keyboardType: TextInputType.number,
                                                    decoration: new InputDecoration(
                                                        focusedBorder: new UnderlineInputBorder(borderSide: BorderSide(color: _u.getPaymentType() == PaymentType.Utility ? Colors.red : Colors.greenAccent[700])),
                                                        enabledBorder: new UnderlineInputBorder(borderSide: BorderSide(color: _u.getPaymentType() == PaymentType.Utility ? Colors.red : Colors.greenAccent[700]))
                                                    ),
                                                    cursorColor: _u.getPaymentType() == PaymentType.Utility ? Colors.red : Colors.greenAccent[700],
                                                    style: TextStyle(
                                                        fontSize: 34 * SizeConfig.safeBlockHorizontal,
                                                        fontFamily: "Montserrat",
                                                        color: _u.getPaymentType() == PaymentType.Utility ? Colors.red : Colors.greenAccent[700]
                                                    ),
                                                    onSubmitted: (_t) {
                                                        setUtilityAmount(_u.getID(), double.parse(_t.replaceAll(',', '').replaceAll(settings["currency"], "")));
                                                    }
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
                                        width: 150,
                                        child: customButton(
                                            20 * SizeConfig.safeBlockHorizontal,
                                            _p.isPaid() ? Colors.indigoAccent[700] : Colors.blue[100],
                                            _p.isPaid() ? Colors.white : Colors.indigo[700],
                                            _p.isPaid() ? Icons.done : Icons.close,
                                            _p.isPaid() ? "Paid" : "Not Paid",
                                            () {
                                                setPaid(rentID: _p.getID(), rentPaid: !_p.isPaid(), utilityID: _u.getID(), utilityPaid: _u.isPaid());
                                            },
                                            null
                                        )
                                    ),
                                    Container(
                                        width: 150,
                                        child: customButton(
                                            20 * SizeConfig.safeBlockHorizontal,
                                            _u.isPaid() ? Colors.deepOrangeAccent[400] : Colors.deepOrange[100],
                                            _u.isPaid() ? Colors.white : Colors.deepOrangeAccent[400],
                                            _u.isPaid() ? Icons.done : Icons.close,
                                            _u.isPaid() ? "Paid" : "Not Paid",
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