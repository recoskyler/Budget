import 'dart:io';
import 'dart:math';
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
    List<dynamic> _t = List.from(settings["transactions"]);

    _t.forEach((_p) {
        if (_p.getID() == id) {
            _index = _t.indexOf(_p);
        }
    });
    
    if (_index != -1)
        _t.removeAt(_index);
    
    dp(_t);
}



// * WIDGETS

GestureDetector transactionItemFromPayment(Payment _p, Function op, Function dp) {
    return transactionItemBlock(_p.getDescription(), settings["currency"], _p.getDate(), _p.getPaymentType(), _p.getAmount(), _p.getID(), op, deletePaymentByID, dp);
}

GestureDetector subscriptionItemFromPayment(Payment _p, Function op, Function dp) {
    return subscriptionItemBlock(_p.getDescription(), settings["currency"], _p.getDate(), _p.getPaymentType(), _p.getAmount(), _p.getID(), op, deletePaymentByID, dp);
}

// * DATE FUNCTIONS

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

bool thisMonths(DateTime _date, int _renewalDay, DateTime _compDate) {
    if (getRenewalDate(_date, _renewalDay).compareTo(getRenewalDate(_compDate, _renewalDay)) == 0 || (_date.isBefore(getNextRenewalDate(_compDate, _renewalDay)) && _date.isAfter(getRenewalDate(_compDate, _renewalDay)))) {
        return true;
    }

    return false;
}

List<DateTime> getAllDates([List<Payment> _ls, int _day]) {
	_ls = _ls == null ? List<Payment>.from(settings["transactions"]) : _ls;
	_day = _day == null ? settings["budgetRenewalDay"] : _day;

	List<DateTime> _res = new List<DateTime>();

	_ls.forEach((Payment _p) {
		DateTime _date = getRenewalDate(_p.getDate(), _day);

		if (!_res.contains(_date)) _res.add(_date);
	});

	return _res;
}

// Yeah, really...
int getAllDateCount([List<Payment> _ls, int _day]) {
	return getAllDates(_ls, _day).length;
}

int getMonthCount([List<Payment> _ls, int _day]) {
    _ls = _ls == null ? List<Payment>.from(settings["transactions"]) : _ls;
	_day = _day == null ? settings["budgetRenewalDay"] : _day;

    List<DateTime> _dates = getAllDates(_ls, _day);

    if (_dates.length == 0) return 1;

    _dates.sort((a, b) => a.compareTo(b));

    int _count = 0;
    DateTime _next = getRenewalDate(_dates[0], _day);

    while (_next.compareTo(getRenewalDate(DateTime.now(), _day)) < 0) {
        _next = getNextRenewalDate(_next, _day);
        _count++;
    }

    return _count;
}

// * TESTING FUNCTION

void addRandomTransaction() {
    List _tr = List.from(settings["transactions"]);
    List _desc = List.from(settings["transactionDescriptions"]);
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
    _date = _date == null ? DateTime.now() : _date;
    _transactions = orderByDateDescending(_transactions);

    if (_transactions.length == 0) {
        return _res;
    }

    if (_onlySubs) {
        _transactions = List.from(settings["fixedPayments"]);

        _transactions.forEach((Payment _p){
            _res += _p.getAmount();
        });

        return _res;
    }

    for (int i = 0; i < _transactions.length; i++) {
        Payment _p = _transactions[i];

        if (!thisMonths(_p.getDate(), _renewalDay, _date)) {
            break;
        }

        if (thisMonths(_p.getDate(), _renewalDay, _date) && expensePaymentTypes.contains(_p.getPaymentType())) {
            _res += _p.getAmount();
        } else if (_p.getDate().compareTo(_date) <= 0) {
            _res += _p.getAmount();
        }
    }

    return _res;
}

double calculateSavings([DateTime _date]) {
    double _res = 0.0;
    List _transactions = List.from(settings["transactions"]);
    int _renewalDay = settings["budgetRenewalDay"];
    _date = _date == null ? DateTime.now() : _date;

    if (_transactions.length == 0) {
        return _res;
    }

    for (int i = 0; i < _transactions.length; i++) {
        Payment _p = _transactions[i];

        if (!thisMonths(_p.getDate(), _renewalDay, _date)) {
            break;
        }

        if (thisMonths(_p.getDate(), _renewalDay, _date) && savingPaymentTypes.contains(_p.getPaymentType())) {
            _res += _p.getAmount();
        }

        if (thisMonths(_p.getDate(), _renewalDay, _date) && (_p.getPaymentType() == PaymentType.SavingExpense || _p.getPaymentType() == PaymentType.SavingToBudget)) {
            _res -= _p.getAmount();
        }

        if (_p.getPaymentType() == PaymentType.FixedSavingDeposit) {
            _res += _p.getAmount();
        }
    }

    return _res;
}

double calculateAllowence([DateTime _date]) {
    double _res = settings["monthlyAllowence"];
    List _transactions = List.from(settings["transactions"]);
    int _renewalDay = settings["budgetRenewalDay"];
    _date = _date == null ? DateTime.now() : _date;

    if (_transactions.length == 0) {
        return _res;
    }

    for (int i = 0; i < _transactions.length; i++) {
        Payment _p = _transactions[i];

        if (!thisMonths(_p.getDate(), _renewalDay, _date)) {
            break;
        }

        if (thisMonths(_p.getDate(), _renewalDay, DateTime.now()) && (_p.getPaymentType() == PaymentType.Deposit || _p.getPaymentType() == PaymentType.SavingToBudget)) {
            _res += _p.getAmount();
        }

        if (thisMonths(_p.getDate(), _renewalDay, DateTime.now()) && savingPaymentTypes.contains(_p.getPaymentType()) && _p.getPaymentType() != PaymentType.ExistingSaving) {
            _res -= _p.getAmount();
        }

        if (_p.getPaymentType() == PaymentType.FixedSavingDeposit) {
            _res -= _p.getAmount();
        }
    }

    return _res;
}

double calculateTotalSavings() {
    double _res = 0.0;
    List _transactions = List.from(settings["transactions"]);

    if (_transactions.length == 0) {
        return _res;
    }

    for (int i = 0; i < _transactions.length; i++) {
        Payment _p = _transactions[i];

        if (_p.getPaymentType() == PaymentType.FixedSavingDeposit) {
            double _fs = 0.0;
            DateTime _td = _p.getStartingDate();
            _td = getNextRenewalDate(_td, settings["budgetRenewalDay"]);

            print(_td.toString());

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

double calculateTotalFromPayment(PaymentType _type, [List<Payment> _ls, int _day]) {
	_ls = _ls == null ? List<Payment>.from(settings["transactions"]) : _ls;
	_day = _day == null ? settings["budgetRenewalDay"] : _day;
	
	double _res = 0.0;

	_ls.forEach((Payment _p) {
		if (_p.getPaymentType() == _type) _res += _p.getAmount();
	});

	return _res;
}

double calculateTotalFromPayments(List<PaymentType> _type, [List<Payment> _ls, int _day]) {
	_ls = _ls == null ? List<Payment>.from(settings["transactions"]) : _ls;
	_day = _day == null ? settings["budgetRenewalDay"] : _day;
	
	double _res = 0.0;

	_ls.forEach((Payment _p) {
		if (_type.contains(_p.getPaymentType())) _res += _p.getAmount();
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

String formatAmount(double _amount, [int decimals = 2, bool showCurrency = true, String _currency]) {
    
}