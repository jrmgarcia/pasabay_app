import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/viewmodels/transaction_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class TransactionView extends StatelessWidget {
  const TransactionView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<TransactionViewModel>.withConsumer(
      viewModel: TransactionViewModel(),
      builder: (context, model, child) => Scaffold(
        body: ListView(
        padding: EdgeInsets.all(8),
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('transactions').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.documents.length > 0) {
                  return Column(
                    children: snapshot.data.documents.map((doc) => 
                      InkWell(
                        onTap: () => model.viewMessage(doc),
                        child: model.buildItem(doc)
                      )
                    ).toList()
                  );
                } else {
                  return Column(children: <Widget>[
                    SizedBox(height: 256), 
                    Text('No Transaction found.')
                  ]);
                }
              },
            )
          ],
        )
      )
    );
  }
}