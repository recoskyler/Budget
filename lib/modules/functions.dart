import 'dart:io';
import 'dart:math';
import 'package:budget/screens/stats_screen/stats_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'settings.dart';
import 'package:flutter/material.dart';
import 'components.dart';
import 'classes.dart';
import 'enums.dart';
import 'global.dart';

final _random = new Random();

// * IO FUNCTIONS

bool fileExists(String path) {
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
        return false;
	}

    return true;
}

void createFile(String path, [String content = ""]) {
    new File(path).writeAsString(content);
}

// * PAYMENT FUNCTIONS

void deletePaymentByID(int id, Function dp) {
    int _index = -1;
    List<Payment> _t = List<Payment>.from(settings["transactions"]);

    _t.forEach((Payment _p) {
        if (_p.getID() == id) {
            _index = _t.indexOf(_p);
        }
    });
    
    if (_index != -1)
        _t.removeAt(_index);
    
    dp(_t);
}

bool deleteFixedPaymentByID(int id, Function dp) {
    int _index = -1;
    List<Payment> _t = List<Payment>.from(settings["fixedPayments"]);

    _t.forEach((Payment _p) {
        if (_p.getID() == id) {
            _index = _t.indexOf(_p);
        }
    });
    
    if (_index != -1)
        _t.removeAt(_index);
    
    dp(_t);

    return true;
}

// * WIDGETS

Widget transactionItemFromPayment(Payment _p, Function op, Function dp, Function fp, [DateTime _date]) {
    _date = _date == null ? _p.getDate() : _date;
    Function _delF = deletePaymentByID;
    Function _renF = dp;

    if (fixedPaymentTypes.contains(_p.getPaymentType())) {
        _delF = deleteFixedPaymentByID;
        _renF = fp;
    }

    return transactionItemBlock(_p.getDescription(), settings["currency"], _date, _p.getPaymentType(), _p.getAmount(), _p.getID(), op, _delF, _renF);
}

Widget subscriptionItemFromPayment(Payment _p, Function op, Function dp) {
    return subscriptionItemBlock(_p.getDescription(), settings["currency"], _p.getDate(), _p.getRenewalDay(), _p.getPaymentType(), _p.getAmount(), _p.getID(), op, deleteFixedPaymentByID, dp);
}

// * DATE FUNCTIONS

/// Returns the renewal date of a date. Takes January and December into consideration as well.
/// If _date is 15/03/2019, and _renewalDay is 10, the renewal date will be 10/03/2019.
/// If _date is 7/03/2019, and _renewalDay is 10, the renewal date will be 10/02/2019.
DateTime getRenewalDate(DateTime _date, int _renewalDay) {
    DateTime _pastDate = _date;

    if (_date.day >= _renewalDay) {
        _pastDate = new DateTime(_date.year, _date.month, _renewalDay);
    } else if (_date.day < _renewalDay && _date.month > 1) {
        _pastDate = new DateTime(_date.year, _date.month - 1, _renewalDay);
    } else if (_date.day < _renewalDay && _date.month == 1) {
        _pastDate = new DateTime(_date.year - 1, 12, _renewalDay);
    }

    return _pastDate;
}

/// Returns the next renewal date of a date. Takes January and December into consideration as well.
/// If _date is 15/03/2019, and _renewalDay is 10, the renewal date will be 10/04/2019.
/// If _date is 7/03/2019, and _renewalDay is 10, the renewal date will be 10/03/2019.
DateTime getNextRenewalDate(DateTime _date, int _renewalDay) {
    DateTime _pastDate = _date;

    if (_date.day < _renewalDay) {
        _pastDate = new DateTime(_date.year, _date.month - 1, _renewalDay);
    } else if (_date.day < _renewalDay && _date.month == 1) {
        _pastDate = new DateTime(_date.year - 1, 12, _renewalDay);
    } else if (_date.day >= _renewalDay && _date.month == 12) {
        _pastDate = new DateTime(_date.year + 1, 1, _renewalDay);
    } else if (_date.day >= _renewalDay) {
        _pastDate = new DateTime(_date.year, _date.month + 1, _renewalDay);
    }

    return _pastDate;
}

/// Checks if a Date is between this and next renewal date.
bool thisMonths(DateTime _date, int _renewalDay, DateTime _compDate) {
    if (getRenewalDate(_date, _renewalDay).compareTo(getRenewalDate(_compDate, _renewalDay)) == 0 || (_date.isBefore(getNextRenewalDate(_compDate, _renewalDay)) && _date.isAfter(getRenewalDate(_compDate, _renewalDay)))) {
        return true;
    }

    return false;
}

/// Returns a List<DateTime> of all the Renewal Dates where there was a payment, no matter what kind.
List<DateTime> getAllDates([List _l1, int _day]) {
    List<Payment> _ls;
	_day = _day == null ? settings["budgetRenewalDay"] : _day;

    List<DateTime> _res = new List<DateTime>();

    if (_l1 == null) {
        _ls = List<Payment>.from(settings["transactions"]);
        _ls.addAll(List<Payment>.from(settings["fixedPayments"]));

        if (_ls.length == 0) {
            _res.add(getRenewalDate(DateTime.now(), _day));

            return _res;
        }
    } else {
        _ls = List<Payment>.from(_l1);
    }

	_ls.forEach((Payment _p) {
		DateTime _date = getRenewalDate(_p.getDate(), _day);

        if (fixedPaymentTypes.contains(_p.getPaymentType())) {
            DateTime _next = getRenewalDate(_date, _day);

            while (_next.compareTo(getRenewalDate(DateTime.now(), _day)) < 0) {
                if (!_res.contains(_next)) _res.add(_next);

                _next = getNextRenewalDate(_next, _day);
            }
        } else if (!_res.contains(_date)) _res.add(_date);
	});

	return _res;
}

int getAllDateCount([List _ls, int _day]) {
	return getAllDates(_ls, _day).length;
}

int getMonthCount([List _l1, int _day]) {
    List<Payment> _ls;
	_day = _day == null ? settings["budgetRenewalDay"] : _day;

    if (_l1 == null) {
        _ls = List<Payment>.from(settings["transactions"]);
        _ls.addAll(List<Payment>.from(settings["fixedPayments"]));
    } else {
        _ls = List<Payment>.from(_l1);
    }

    List<DateTime> _dates = getAllDates(_ls, _day);

    if (_dates.length == 0) return 1;

    _dates.sort((a, b) => a.compareTo(b));

    int _count = 1;
    DateTime _next = getRenewalDate(_dates[0], _day);

    while (_next.compareTo(getRenewalDate(DateTime.now(), _day)) < 0) {
        _next = getNextRenewalDate(_next, _day);
        _count++;
    }

    return _count;
}

// * TESTING FUNCTION

/// Adds a random Payment to settings["transactions"]. It will be visible only on Budget related screens/lists.
void addRandomTransaction() {
    List _tr = List.from(settings["transactions"]);
    List _desc = transactionDescriptions;
    DateTime _date = DateTime.now();
    int _key = settings["keyIndex"];

    Payment _p = new Payment(_desc[next(0, _desc.length)], next(1, 1000).toDouble(), _date, next(0, PaymentType.values.length), _key);

    _tr.add(_p);

    settings["transactions"] = _tr;
    settings["keyIndex"] = _key + 1;
    
    saveSettings();
}

// * CALCULATORS

double calculateExpenses([bool _onlySubs = false, DateTime _date]) {
    double _res = 0.0;
    List<Payment> _transactions = List<Payment>.from(settings["transactions"]);
    int _renewalDay = settings["budgetRenewalDay"];

    _transactions.addAll(List<Payment>.from(settings["fixedPayments"]));

    bool _pushBreak = false;
    if (_date == null) _pushBreak = true;

    _date = _date == null ? DateTime.now() : _date;

    if (_transactions.length == 0) {
        return _res;
    }

    if (_onlySubs) {
        _transactions.clear();
        _transactions = List.from(settings["fixedPayments"]);

        _transactions.forEach((Payment _p){
            _res += _p.getAmount();
        });

        return _res;
    }

    for (int i = 0; i < _transactions.length; i++) {
        Payment _p = _transactions[i];

        if (!thisMonths(_p.getDate(), _renewalDay, _date) && _pushBreak && !fixedPaymentTypes.contains(_p.getPaymentType())) {
            break;
        }

        if (thisMonths(_p.getDate(), _renewalDay, _date) && expensePaymentTypes.contains(_p.getPaymentType()) && _p.getPaymentType() != PaymentType.Subscription) {
            _res += _p.getAmount();
        } else if (_p.getPaymentType() == PaymentType.Subscription && _p.getDate().compareTo(_date) <= 0 && _p.getRenewalDay() <= _date.day && _pushBreak) {
            _res += _p.getAmount();
        } else if (_p.getPaymentType() == PaymentType.Subscription && _p.getDate().compareTo(_date) <= 0 && !_pushBreak) {
            _res += _p.getAmount();
        }
    }

    return _res;
}

double calculateSavings([DateTime _date]) {
    double _res = 0.0;
    List<Payment> _transactions = List<Payment>.from(settings["transactions"]);
    _transactions.addAll(List<Payment>.from(settings["fixedPayments"]));
    int _renewalDay = settings["budgetRenewalDay"];

    bool _pushBreak = false;
    if (_date == null) _pushBreak = true;

    _date = _date == null ? DateTime.now() : _date;

    if (_transactions.length == 0) {
        return _res;
    }

    for (int i = 0; i < _transactions.length; i++) {
        Payment _p = _transactions[i];

        if (!thisMonths(_p.getDate(), _renewalDay, _date) && _pushBreak) {
            break;
        }

        if (thisMonths(_p.getDate(), _renewalDay, _date) && savingPaymentTypes.contains(_p.getPaymentType()) && _p.getPaymentType() != PaymentType.FixedSavingDeposit) {
            _res += _p.getAmount();
        }

        if (thisMonths(_p.getDate(), _renewalDay, _date) && (_p.getPaymentType() == PaymentType.SavingExpense || _p.getPaymentType() == PaymentType.SavingToBudget)) {
            _res -= _p.getAmount();
        }

        if (_p.getPaymentType() == PaymentType.FixedSavingDeposit && _p.getDate().compareTo(_date) <= 0 && !_pushBreak) {
            _res += _p.getAmount();
        }
    }

    return _res;
}

double calculateAllowence([DateTime _date]) {
    double _res = settings["monthlyAllowence"];
    List<Payment> _transactions = List<Payment>.from(settings["transactions"]);
    _transactions.addAll(List<Payment>.from(settings["fixedPayments"]));
    int _renewalDay = settings["budgetRenewalDay"];

    bool _pushBreak = false;
    if (_date == null) _pushBreak = true;

    _date = _date == null ? DateTime.now() : _date;

    if (_transactions.length == 0) {
        return _res;
    }

    for (int i = 0; i < _transactions.length; i++) {
        Payment _p = _transactions[i];

        if (!thisMonths(_p.getDate(), _renewalDay, _date) && _pushBreak && _p.getPaymentType() != PaymentType.FixedSavingDeposit) {
            break;
        }

        if (thisMonths(_p.getDate(), _renewalDay, _date) && (_p.getPaymentType() == PaymentType.Deposit || _p.getPaymentType() == PaymentType.SavingToBudget)) {
            _res += _p.getAmount();
        }

        if (thisMonths(_p.getDate(), _renewalDay, _date) && _p.getPaymentType() == PaymentType.Saving) {
            _res -= _p.getAmount();
        }

        if (_p.getPaymentType() == PaymentType.FixedSavingDeposit && _p.getDate().compareTo(_date) <= 0 && _p.getRenewalDay() <= _date.day && _pushBreak) {
            _res -= _p.getAmount();
        } else if (_p.getPaymentType() == PaymentType.FixedSavingDeposit && _p.getDate().compareTo(_date) <= 0 && !_pushBreak) {
            _res -= _p.getAmount();
        }
    }

    return _res;
}

double calculateTotalSavings() {
    double _res = 0.0;
    List<Payment> _transactions = List<Payment>.from(settings["transactions"]);
    _transactions.addAll(List<Payment>.from(settings["fixedPayments"]));

    if (_transactions.length == 0) {
        return _res;
    }

    for (int i = 0; i < _transactions.length; i++) {
        Payment _p = _transactions[i];

        if (_p.getPaymentType() == PaymentType.FixedSavingDeposit) {
            double _fs = 0.0;
            DateTime _td = _p.getDate();
            _td = getNextRenewalDate(_td, settings["budgetRenewalDay"]);

            while (getRenewalDate(_td, settings["budgetRenewalDay"]).compareTo(getRenewalDate(DateTime.now(), settings["budgetRenewalDay"])) == 0) {
                _fs += _p.getAmount();
                _td = getNextRenewalDate(_td, settings["budgetRenewalDay"]);
            }

            _res += _fs;
        }

        if (savingPaymentTypes.contains(_p.getPaymentType()))
            _res += _p.getAmount();

        if (_p.getPaymentType() == PaymentType.SavingExpense || _p.getPaymentType() == PaymentType.SavingToBudget)
            _res -= _p.getAmount();
    }

    return _res;
}

double calculateTotalFromPayment(PaymentType _type, [List _l, int _day]) {
	List<Payment> _ls;
	_day = _day == null ? settings["budgetRenewalDay"] : _day;

    if (_l == null) {
        _ls = List<Payment>.from(settings["transactions"]);
        _ls.addAll(List<Payment>.from(settings["fixedPayments"]));
    } else {
        _ls = List<Payment>.from(_l);
    }
	
	double _res = 0.0;

	_ls.forEach((Payment _p) {
		if (_p.getPaymentType() == _type) _res += _p.getAmount();
	});

	return _res;
}

double calculateTotalFromPayments(List<PaymentType> _type, [List _l, int _day]) {
	List<Payment> _ls;

	_day = _day == null ? settings["budgetRenewalDay"] : _day;

    if (_l == null) {
        _ls = List<Payment>.from(settings["transactions"]);
        _ls.addAll(List<Payment>.from(settings["fixedPayments"]));
    } else {
        _ls = List<Payment>.from(_l);
    }
	
	double _res = 0.0;

	_ls.forEach((Payment _p) {
        if (fixedPaymentTypes.contains(_p.getPaymentType()) && _type.contains(_p.getPaymentType())) {
            double _fs = _p.getAmount();
            DateTime _td = _p.getDate();
            _td = getRenewalDate(_td, settings["budgetRenewalDay"]);

            DateTime _next = getRenewalDate(_td, _day);

            while (_next.compareTo(getRenewalDate(DateTime.now(), _day)) < 0) {
                _next = getNextRenewalDate(_next, _day);
                _res += _p.getAmount();
            }

            _res += _fs;
        } else if (_type.contains(_p.getPaymentType())) _res += _p.getAmount();
	});

	return _res;
}

// * MISC

List<Payment> orderByDateDescending(List<Payment> _ul) {
    List<Payment> _ol = _ul;

    _ol.sort((b, a) => a.getDate().compareTo(b.getDate()));

    return _ol;
}

void refreshStats() {
    expense = calculateExpenses();
    budget = calculateAllowence();
    savings = calculateTotalSavings();
    subexpense = calculateExpenses(true);
    currency = settings["currency"];
    theme = settings["theme"];
}

int next(int min, int max) => min + _random.nextInt(max - min);

void openStats(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => StatsScreen())).then((_tmp) {selectedID = -1;});
}

String getNumberText(int _num) {
    if (_num % 100 <= 20 && _num % 100 >= 10) return "th";

    switch (_num % 10) {
        case 1:
            return "st";
        case 2:
            return "nd";
        case 3:
            return "rd";
        default:
            return "th";
    }
}

void launchURL(String url) async {
    if (await canLaunch(url)) {
        await launch(url);
    } else {
        throw 'Could not launch $url';
    }
}

void initTransactionDescriptions() {
    transactionDescriptions = [
        lBase.descriptions.food,
        lBase.descriptions.drink,
        lBase.descriptions.groceries,
        lBase.descriptions.clothes,
        lBase.descriptions.makeup,
        lBase.descriptions.topUp,
        lBase.descriptions.cinema,
        lBase.descriptions.tech,
        lBase.descriptions.hobby,
        lBase.descriptions.travel,
        lBase.descriptions.hotel,
        lBase.descriptions.app,
        lBase.descriptions.game,
        lBase.descriptions.hardware,
        lBase.descriptions.furniture,
        lBase.descriptions.household,
        lBase.descriptions.other
    ];
}

bool isNumeric(String str) {
    if(str == null) {
        return false;
    }
    return double.tryParse(str) != null;
}