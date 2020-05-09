import 'package:flutter/material.dart';
import 'package:pasabay_app/ui/views/current_view.dart';
import 'package:pasabay_app/ui/views/history_view.dart';

class TransactionView extends StatelessWidget {

  final CurrentView _currentView = CurrentView();
  final HistoryView _historyView = HistoryView();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: Container(),
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  tabs: [
                    Tab(text: "Current"),
                    Tab(text: "History")
                  ],
                  labelColor: Colors.white,
                  indicatorColor: Colors.white
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              _currentView,
              _historyView
            ],
          ),
        ),
      ),
    );
  }
}