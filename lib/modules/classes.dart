import 'package:budget/modules/settings.dart';

import 'enums.dart';

Type paymentAsType = Payment;

class Payment {
	final String _description;
	double _amount;
	final DateTime _date;
    final int _id;
    int _paymentType;

	Payment(this._description, this._amount, this._date, this._paymentType, this._id) {
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

	double getAmount() {
		return num.parse(_amount.toStringAsFixed(2));
	}

    String getAmountAsString([bool decimals = true]) {
        if (decimals) return _amount.toStringAsFixed(2);

        return _amount.toStringAsFixed(0);
    }

    String getDescription() {
        return _description;
    }

    DateTime getDate() {
        if (fixedPaymentTypes.contains(this.getPaymentType())){
            return new DateTime(DateTime.now().year, DateTime.now().month, _date.day);
        }

        return _date;
    }

    DateTime getStartingDate() {
        return _date;
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
        _paymentType = json['paymentType'];

	Map<String, dynamic> toJson() => {
		'amount' : _amount,
		'date' : _date.toString(),
		'description' : _description,
        'id' : _id,
        'paymentType' : _paymentType
	};
}