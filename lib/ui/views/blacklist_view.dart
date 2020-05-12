import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/ui/shared/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';
import 'package:pasabay_app/viewmodels/blacklist_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class BlacklistView extends StatelessWidget {
  BlacklistView({Key key}) : super(key: key);

  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BlacklistViewModel>.withConsumer(
      viewModel: BlacklistViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("Blacklist", style: TextStyle(color: Colors.white)),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          leading: myBackButton(context)
        ),
        drawer: MyDrawer(),
        body: StreamBuilder<List<User>>(
          stream: _firestoreService.getBlacklistData(_authenticationService.currentUser.uid),
          builder: (BuildContext context, AsyncSnapshot<List<User>> blacklistsSnapshot) {
            if (blacklistsSnapshot.hasError)
              return Text('Error: ${blacklistsSnapshot.error}');
            switch (blacklistsSnapshot.connectionState) {
              case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
              default:
                return ListView(
                  padding: EdgeInsets.all(8),
                  children: blacklistsSnapshot.data.map((User user) {
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        leading: userPhotoUrl(user.photoUrl ?? ' '),
                        title: Text(
                          user.displayName ?? ' ',
                          style: Theme.of(context).textTheme.headline6,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          user.email,
                          style: Theme.of(context).textTheme.bodyText2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          tooltip: 'Unblock',
                          icon: Icon(FontAwesomeIcons.times, color: Theme.of(context).accentColor),
                          onPressed: () {
                            model.unblock(_authenticationService.currentUser.uid, user.uid);
                          },
                        ),
                      )
                    );
                  }
                ).toList()
              );
            }
          }
        ),
      )
    );
  }
}
