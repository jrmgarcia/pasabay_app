import 'package:flutter/cupertino.dart';
import 'package:pasabay_app/ui/shared/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/ui/widgets/task_item.dart';
import 'package:pasabay_app/viewmodels/browse_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BrowseViewModel>.withConsumer(
      viewModel: BrowseViewModel(),
      onModelReady: (model) => model.listenToPosts(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Browse", style: TextStyle(color: Colors.white)),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        drawer: MyDrawer(),
        body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text("Pull up load");
            } else if(mode==LoadStatus.loading){
              body =  CupertinoActivityIndicator();
            } else if(mode == LoadStatus.failed){
              body = Text("Load Failed! Click retry.");
            } else if(mode == LoadStatus.canLoading){
                body = Text("Release to load more");
            } else{
              body = Text("No more data.");
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
        child: ListView.builder(
          itemCount: model.posts.length,
          itemBuilder: (context, index) {
          return TaskItem(
              post: model.posts[index],
            );
          }
        ),
      ),
      )
    );
  }
}