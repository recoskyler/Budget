/// Made by Adil Atalay Hamamcıoğlu (Recoskyler), 2019
/// Please check the GitHub Page for usage rights.
/// https://github.com/recoskyler/Budget
///

import 'package:budget/modules/functions.dart';
import 'package:budget/modules/global.dart';
import 'package:budget/modules/settings.dart';
import 'enums.dart';

Type paymentAsType = Payment;

class Payment {
	final String _description;
	double _amount;
	final DateTime _date;
    final int _id;
    final int _renewalDay;
    int _paymentType;

	Payment(this._description, this._amount, this._date, this._paymentType, this._id, [this._renewalDay]) {
        settings["keyIndex"] += 1;
    }

    set paymentType(PaymentType _t) {
        _paymentType = PaymentType.values.indexOf(_t);
    }
    
    set amount(double _a) {
        _amount = _a;
    }

    int getID() {
        return _id;
    }

    int getRenewalDay() {
        if (_renewalDay == null) return 1;
        
        return _renewalDay;
    }

	double getAmount() {
		return num.parse(_amount.toStringAsFixed(2));
	}

    String getAmountAsString([bool decimals = true]) {
        if (decimals) return _amount.toStringAsFixed(2);

        return _amount.toStringAsFixed(0);
    }

    String getDescription() {
        if (isNumeric(_description)) {
            return transactionDescriptions[int.parse(_description)];
        }

        if (_description.contains("budgetpaymentexpenseasstring")) {
            List<String> _l = _description.split(".");
            int _ind = int.parse(_l[1]);

            return asString[_ind];
        }

        return _description;
    }

    DateTime getDate() {
        return _date;
    }

    DateTime getFPRenewalDate(DateTime _date) {
        DateTime _res = new DateTime(_date.year, _date.month, this._renewalDay);

        if (getRenewalDate(_date, settings["budgetRenewalDay"]).compareTo(getRenewalDate(DateTime.now(), settings["budgetRenewalDay"])) >= 0) {
            //_res = getNextRenewalDate(_res, this._renewalDay);
        }

        return _res;
    }

	bool isFixed() {
        return fixedPaymentTypes.contains(this.getPaymentType());
	}

    bool isExpense() {
        return expensePaymentTypes.contains(this.getPaymentType());
    }

    bool isSaving() {
        return savingPaymentTypes.contains(this.getPaymentType());
    }

    PaymentType getPaymentType() {
        return PaymentType.values[_paymentType];
    }

    void printAsString() {
        print("{desc : \"$_description\" , amount : $_amount , type : \"$_paymentType\" , date : \"$_date\" }");
    }

    bool isPaid() {
        return PaymentType.values[_paymentType] == PaymentType.PaidRent || PaymentType.values[_paymentType] == PaymentType.PaidUtility;
    }

	Payment.fromJSON(Map<String, dynamic> json) : 
		_amount = json['amount'],
		_date = DateTime.parse(json['date']),
        _id = json['id'],
		_description = json['description'],
        _paymentType = json['paymentType'],
        _renewalDay = json['renewalDay'];

	Map<String, dynamic> toJson() => {
		'amount' : _amount,
		'date' : _date.toString(),
		'description' : _description,
        'id' : _id,
        'paymentType' : _paymentType,
        'renewalDay' : _renewalDay
	};
}

class ChartEntry {
    final int value;
    final DateTime date;

    ChartEntry(this.value, this.date);
}