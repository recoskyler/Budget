enum PaymentType {
    Deposit,
    Withdraw,
    FixedSavingDeposit,
    FixedWithdraw,
    Rent,
    PaidRent,
    Utility,
    PaidUtility,
    Subscription,
    Saving,
    SavingExpense,
    SavingToBudget,
    ExistingSaving
}

var fixedPaymentTypes = [PaymentType.Subscription, PaymentType.FixedSavingDeposit, PaymentType.FixedWithdraw];
var nonFixedPaymentTypes = [PaymentType.Rent, PaymentType.Utility, PaymentType.Withdraw, PaymentType.Deposit, PaymentType.Saving];
var expensePaymentTypes = [PaymentType.Subscription, PaymentType.PaidRent, PaymentType.PaidUtility, PaymentType.FixedWithdraw, PaymentType.Rent, PaymentType.Utility, PaymentType.Withdraw];
var savingPaymentTypes = [PaymentType.Saving, PaymentType.FixedSavingDeposit, PaymentType.ExistingSaving];
var rentalPaymentTypes = [PaymentType.Rent, PaymentType.PaidRent, PaymentType.Utility, PaymentType.PaidUtility];

List<String> asString = [
    "Deposit",
    "Expense",
    "Fixed Saving Deposit",
    "Fixed Expense",
    "Rent Payment",
    "Finished Rent Payment",
    "Utility Payment",
    "Finished Utility Payment",
    "Subscription",
    "Saving Deposit",
    "Saving Expense",
    "Saving To Budget",
    "Existing Saving"
];