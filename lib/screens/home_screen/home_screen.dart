/// Made by Adil Atalay Hamamcıoğlu (Recoskyler), 2019
/// Please check the GitHub Page for usage rights.
/// https://github.com/recoskyler/Budget
///

import 'package:budget/main.dart';
import 'package:budget/modules/functions.dart';
import 'package:budget/screens/edit_transaction_screen/edit_transaction.dart';
import 'package:budget/screens/settings_screen/settings_screen.dart';
import 'package:budget/screens/setup_screen/setup_screen.dart';
import 'package:budget/screens/subs_screen/subs_screen.dart';
import 'package:flutter/material.dart';
import '../../modules/settings.dart';
import '../../modules/global.dart';
import 'package:budget/screens/edit_deposit_screen/edit_deposit_screen.dart';
import 'package:budget/screens/edit_saving_screen/edit_saving_screen.dart';
import 'package:budget/screens/rent_screen/rent_screen.dart';
import 'package:budget/screens/budget_screen/budget_screen.dart';
import 'package:budget/screens/edit_rent_screen/edit_rent_screen.dart';
import 'package:budget/modules/classes.dart';
import 'package:budget/screens/edit_subs_screen/edit_subs_screen.dart';

class App extends StatelessWidget {
    @override
    Widget build(BuildContext context) { 
        return MaterialApp(
            title: "Budget",
            home: MySApp(),
            theme: ThemeData(accentColor: Colors.purpleAccent),
        );
    }
}

class MySApp extends StatefulWidget {
    MySApp({Key key}) : super(key: key);

    @override
    _MyApp createState() => _MyApp();
}

class _MyApp extends State<MySApp> {
    List<Widget> bodiesInWater = new List<Widget>();
    List<PreferredSizeWidget> headsInWater = new List<PreferredSizeWidget>();
    List<Widget> buttonsInWater = new List<Widget>();
    PageController controller = PageController(keepPage: true, initialPage: settings["rentPage"]);

    void openEditPage(int _i) {
        switch (_i) {
            case 0:
                Navigator.push(context,MaterialPageRoute(builder: (context) => EditSaving())).then((_tmp) {
                    refreshStats();
                });
                setState(() {
                    buttonStateIndex = 0;
                });
                break;
            
            case 1:
                Navigator.push(context,MaterialPageRoute(builder: (context) => EditTransaction())).then((_tmp) {
                    refreshStats();
                });
                setState(() {
                    buttonStateIndex = 0;
                });
                break;

            case 2:
                Navigator.push(context,MaterialPageRoute(builder: (context) => EditDeposit())).then((_tmp) {
                    refreshStats();
                });
                setState(() {
                    buttonStateIndex = 0;
                });
                break;
        }
    }

    void onActionPressed() {
        setState(() {
            buttonStateIndex++;
            buttonStateIndex = buttonStateIndex % 2;
        });
    }

    void onNavClick(int index) {
        setState(() {
            refreshStats();
            selectedNavMenu = index;
            buttonStateIndex = 0;
        });
    }

    void onTransactionItemClick(int id) {
        if (selectedID == id) {
            setState(() {
                selectedID = -1;
            });
        } else {
            setState(() {
                selectedID = id;
            });
        }
    }

    void onSubsItemClick(int id) {
        if (selectedSubID == id) {
            setState(() {
                selectedSubID = -1;
            });
        } else {
            setState(() {
                selectedSubID = id;
            });
        }
    }

    void renewTransactions(List<dynamic> _pt) {
        setState(() {
            refreshStats();
            settings["transactions"] = _pt;
            selectedID = -1;
        });

        saveSettings();
    }

    void renewFixedPayments(List<dynamic> _pt) {
        setState(() {
            refreshStats();
            settings["fixedPayments"] = _pt;
            selectedID = -1;
        });

        saveSettings();
    }

    void onRentActionPressed() {
        if (settings["rentAmount"] == 0.0) {
            Navigator.push(context,MaterialPageRoute(builder: (context) => EditRent())).then((_tmp) {
                refreshStats();
            });
        } else {
            setState(() {
                settings["rentDay"] = 1;
                settings["rentAmount"] = 0.0;
                settings["utilitiesDay"] = 1;
                settings["rentStartDate"] = DateTime.now().toString();
                settings["rentPage"] = 0;
                settings["rents"] = new List<Payment>();

                saveSettings(); 
            });
        }     
    }

    void onSubsActionPressed() {
        Navigator.push(context,MaterialPageRoute(builder: (context) => EditSubs())).then((_tmp) {
            refreshStats();
        });
    }

    void setPage(int _page) {
        setState(() {
            controller.jumpToPage(_page);
        });
    }

    void onSetupActionPressed(double _amount, int _date) {
        setState(() {
            settings["monthlyAllowence"] = _amount;
            settings["firstTime"] = false;
            settings["budgetRenewalDay"] = _date;
            settings["theme"] = theme;

            saveSettings();
        });
    }

    void themeButtonPressed(int _theme) {
        setState(() {
            theme = _theme;
            settings["theme"] = _theme;
        });

        saveSettings();
    }

    void resetSettingsAction() {
        setState(() {
            resetSettings(false);
            refreshStats();
            theme = 0;
            selectedNavMenu = 0;
        });
    }

    @override
    void initState() {
        
        super.initState();
    }

	@override
	Widget build(BuildContext context) {
        SizeConfig().init(context);
        
        refreshStats();

        // * ADD BODIES TO THE WATER

        if (bodiesInWater.length == 0) {
            bodiesInWater.add(BudgetScreen(renewFixedPayments: renewFixedPayments, onTransactionItemClick: onTransactionItemClick, renewTransactions: renewTransactions, openEditPage: openEditPage));
            bodiesInWater.add(RentScreen(controller: controller));
            bodiesInWater.add(SubsScreen(onTransactionItemClick: onSubsItemClick, renewTransactions: renewTransactions));
            bodiesInWater.add(SettingsScreen(themeButtonFunction: themeButtonPressed));
        } else {
            bodiesInWater[0] = (BudgetScreen(renewFixedPayments: renewFixedPayments, onTransactionItemClick: onTransactionItemClick, renewTransactions: renewTransactions, openEditPage: openEditPage));
            bodiesInWater[1] = (RentScreen(controller: controller));
            bodiesInWater[2] = (SubsScreen(onTransactionItemClick: onSubsItemClick, renewTransactions: renewFixedPayments));
            bodiesInWater[3] = (SettingsScreen(themeButtonFunction: themeButtonPressed, resetSettingsAction: resetSettingsAction));
        }
        
        // * ADD HEADS TO THE WATER

        if (headsInWater.length == 0) {
            headsInWater.add(budgetHead(context));
            headsInWater.add(rentHead(context));
            headsInWater.add(subsHead());
            headsInWater.add(settingsHead());
        } else {
            headsInWater[0] = (budgetHead(context));
            headsInWater[1] = (rentHead(context));
            headsInWater[2] = (subsHead());
            headsInWater[3] = (settingsHead());
        }

        // * ADD BUTTONS TO THE WATER

        if (buttonsInWater.length == 0) {
            buttonsInWater.add(BudgetButton(onActionPressed: onActionPressed));
            buttonsInWater.add(RentButton(onActionPressed: onRentActionPressed));
            buttonsInWater.add(SubsButton(onActionPressed: onSubsActionPressed));
            buttonsInWater.add(Container());
        } else {
            buttonsInWater[0] = (BudgetButton(onActionPressed: onActionPressed));
            buttonsInWater[1] = (RentButton(onActionPressed: onRentActionPressed));
            buttonsInWater[2] = (SubsButton(onActionPressed: onSubsActionPressed));
            buttonsInWater[3] = (Container());
        }

        controller = PageController(keepPage: true, initialPage: settings["rentPage"]);

        bool _first = settings["firstTime"];
        // bool _first = false;
        
        return Scaffold(
            backgroundColor: themeColors[theme],
            appBar: _first ? setupHead() : headsInWater[selectedNavMenu],
            body: _first ? Container(margin: globalInset, child: SetupScreen(themeButtonFunction: themeButtonPressed)) : Container(margin: globalInset, child: bodiesInWater[selectedNavMenu]),
            bottomNavigationBar: _first ? Container(height: SizeConfig.blockSizeVertical * 5,) : BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.account_balance_wallet),
                        title: Text("", style: TextStyle(fontSize: 0))
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        title: Text("", style: TextStyle(fontSize: 0))
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.calendar_today),
                        title: Text("", style: TextStyle(fontSize: 0))
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        title: Text("", style: TextStyle(fontSize: 0))
                    ),
                ],
                currentIndex: selectedNavMenu,
                selectedItemColor: Colors.purpleAccent[700],
                unselectedItemColor: Colors.grey[700],
                selectedFontSize: 0,
                onTap: onNavClick,
                type: BottomNavigationBarType.fixed,
                backgroundColor: navBarColors[theme],
            ),
            floatingActionButton: _first ? SetupButton(onActionPressed: onSetupActionPressed) : buttonsInWater[selectedNavMenu],
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
	}
}