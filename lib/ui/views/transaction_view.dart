import 'package:flutter/material.dart';
import 'package:pasabay_app/ui/views/current_view.dart';
import 'package:pasabay_app/ui/views/history_view.dart';

class TransactionView extends StatelessWidget {

  final CurrentView _currentView = CurrentView();
  final HistoryView _historyView = HistoryView();

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(24.0),
            child: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: "Current"),
                      Tab(text: "History")
                    ],
                  ),
                ],
              ),
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