import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/viewmodels/browse_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final AuthenticationService _authenticationService = locator<AuthenticationService>();
RefreshController _refreshController = RefreshController(initialRefresh: false);

class BrowseView extends StatelessWidget {
  const BrowseView({Key key}) : super(key: key);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BrowseViewModel>.withConsumer(
      viewModel: BrowseViewModel(),
      builder: (context, model, child) => Scaffold(
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(),
          footer: CustomFooter(
            builder: (BuildContext context,LoadStatus mode){
              Widget body ;
              if(mode==LoadStatus.idle){
                body =  Text("pull up load");
              }
              else if(mode==LoadStatus.loading){
                body =  CupertinoActivityIndicator();
              }
              else if(mode == LoadStatus.failed){
                body = Text("load failed");
              }
              else if(mode == LoadStatus.canLoading){
                  body = Text("release to load more");
              }
              else{
                body = Text("no more data");
              }
              return Container(
                height: 55.0,
                child: Center(child:body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView(
            padding: EdgeInsets.all(8),
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('posts').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.documents.map((doc) => 
                        doc.data['userId'] == _authenticationService.currentUser.uid.toString() ? SizedBox.shrink() : model.buildItem(doc)
                      ).toList()
                    );
                  } else {
                    return SizedBox();
                  }
                },
              )
            ],
          ),
        ),
      )
    );
  }
}