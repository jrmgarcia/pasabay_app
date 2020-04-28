import 'dart:io';
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/rating.dart';
import 'package:pasabay_app/models/task.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/services/dialog_service.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/ui/shared/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';
import 'package:pasabay_app/ui/shared/ui_helpers.dart';
import 'package:pasabay_app/ui/views/full_photo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

final AuthenticationService _authenticationService = locator<AuthenticationService>();
final NavigationService _navigationService = locator<NavigationService>();
final FirestoreService _firestoreService = locator<FirestoreService>();
final DialogService _dialogService = locator<DialogService>();

class MessageView extends StatelessWidget {
  final Task viewingTask;
  MessageView({Key key, this.viewingTask}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var peer = _authenticationService.currentUser.uid == viewingTask.userId
      ? User(photoUrl: viewingTask.doerAvatar, displayName: viewingTask.doerName, email: viewingTask.doerEmail, rating: viewingTask.doerRating, uid: viewingTask.doerId)
      : User(photoUrl: viewingTask.userAvatar, displayName: viewingTask.userName, email: viewingTask.userEmail, rating: viewingTask.userRating, uid: viewingTask.userId);
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text(
            peerUser(viewingTask),
            style: Theme.of(context).textTheme.title,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            viewingTask.title + " • " + 
            viewingTask.category + " • " + 
            viewingTask.reward + " PHP",
            style: Theme.of(context).textTheme.body1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        leading: myBackButton(context),
        actions: <Widget>[
          _authenticationService.currentUser.uid == viewingTask.userId && viewingTask.fulfilledBy == null
          ? IconButton(tooltip: 'Mark as Done', icon: Icon(FontAwesomeIcons.check), onPressed: () => markAsDone(context, viewingTask.postId, viewingTask.doerId, peer))
          : Container(),
          viewingTask.fulfilledBy != null
          ? _authenticationService.currentUser.uid == viewingTask.userId && viewingTask.userRated == false
            ? IconButton(tooltip: 'Rate', icon: Icon(FontAwesomeIcons.solidStar), onPressed: () => rate(context, peer, viewingTask))
            : _authenticationService.currentUser.uid == viewingTask.doerId && viewingTask.doerRated == false
              ? IconButton(tooltip: 'Rate', icon: Icon(FontAwesomeIcons.solidStar), onPressed: () => rate(context, peer, viewingTask))
              : Container()
          : Container()
        ],
      ),
      drawer: MyDrawer(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ChatScreen(
          postId: viewingTask.postId,
          userId: viewingTask.userId,
          doerId: viewingTask.doerId,
          peer: peer
        ),
      )
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String postId;
  final String userId;
  final String doerId;
  final User peer;

  ChatScreen({Key key, @required this.postId, @required this.userId, @required this.doerId, @required this.peer}) : super(key: key);

  @override
  State createState() => ChatScreenState(postId: postId, userId: userId, doerId: doerId, peer: peer);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({Key key, @required this.postId, @required this.userId, @required this.doerId, @required this.peer});

  String postId;
  String userId;
  String doerId;
  User peer;

  var listMessage;
  String groupChatId;

  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);

    groupChatId = '';

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';

    generateGroupChatId();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  generateGroupChatId() async {
    if (doerId.hashCode <= userId.hashCode) {
      groupChatId = '$postId-$doerId-$userId';
    } else {
      groupChatId = '$postId-$userId-$doerId';
    }
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker, 3 = system
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': doerId == _authenticationService.currentUser.uid ? doerId : _authenticationService.currentUser.uid,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == _authenticationService.currentUser.uid) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document['type'] == 0
              // Text
              ? Container(
                  child: Text(document['content']),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(color: Theme.of(context).highlightColor, borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                )
              : document['type'] == 1
                  // Image
                  ? Container(
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).highlightColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'assets/images/img_not_available.jpeg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: document['content'],
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                    )
                  : document['type'] == 2
                  // Sticker
                  ? Container(
                      child: new Image.asset(
                        'assets/images/${document['content']}.PNG',
                        width: 150.0,
                        height: 150.0,
                        fit: BoxFit.cover,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                    )
                  // System
                  : Container(
                    child: Text(document['content'], style: Theme.of(context).textTheme.subtitle),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    width: 200.0,
                    decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                  )
                  ,
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                ? Tooltip(
                  message: 'View Profile',
                  child: InkWell(
                    onTap: () {_navigationService.navigateTo(ProfileViewRoute, arguments: User(
                      displayName: peer.displayName, email: peer.email, photoUrl: peer.photoUrl, rating: peer.rating));},
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                          ),
                          width: 35.0,
                          height: 35.0,
                          padding: EdgeInsets.all(10.0),
                        ),
                        imageUrl: peer.photoUrl,
                        width: 35.0,
                        height: 35.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(18.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                    ),
                ),
              )
              : Container(width: 35.0),
              document['type'] == 0
              ? Container(
                  child: Text(document['content']),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(color: Theme.of(context).highlightColor, borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                )
              : document['type'] == 1
                ? Container(
                    child: FlatButton(
                      child: Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                            ),
                            width: 200.0,
                            height: 200.0,
                            padding: EdgeInsets.all(70.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).highlightColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Material(
                            child: Image.asset(
                              'assets/images/img_not_available.jpeg',
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                          ),
                          imageUrl: document['content'],
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
                      },
                      padding: EdgeInsets.all(0),
                    ),
                    margin: EdgeInsets.only(left: 10.0),
                  )
                : document['type'] == 2
                  ? Container(
                      child: new Image.asset(
                        'assets/images/${document['content']}.PNG',
                        width: 150.0,
                        height: 150.0,
                        fit: BoxFit.cover,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                    )
                  : Container(
                      child: Text(document['content'], style: Theme.of(context).textTheme.subtitle),
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      width: 200.0,
                      decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(8.0)),
                      margin: EdgeInsets.only(left: 10.0),
                    ),
              ],
            ),

            // Timestamp
            isLastMessageLeft(index)
            ? Container(
                child: Text(
                  DateFormat('dd MMM h:mm a')
                      .format(DateTime.fromMillisecondsSinceEpoch(int.parse(document['timestamp']))),
                  style: Theme.of(context).textTheme.overline,
                ),
                margin: EdgeInsets.only(left: 60.0, top: 5.0, bottom: 5.0),
              )
            : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1]['idFrom'] == _authenticationService.currentUser.uid) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1]['idFrom'] != doerId) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),

              // Sticker
              (isShowSticker ? buildSticker() : Container()),

              // Input content
              buildInput(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('pega1', 2),
                child: new Image.asset(
                  'assets/images/pega1.PNG',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('pega2', 2),
                child: new Image.asset(
                  'assets/images/pega2.PNG',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('pega3', 2),
                child: new Image.asset(
                  'assets/images/pega3.PNG',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('pega4', 2),
                child: new Image.asset(
                  'assets/images/pega4.PNG',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('pega5', 2),
                child: new Image.asset(
                  'assets/images/pega5.PNG',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('pega6', 2),
                child: new Image.asset(
                  'assets/images/pega6.PNG',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('pega7', 2),
                child: new Image.asset(
                  'assets/images/pega7.PNG',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('pega8', 2),
                child: new Image.asset(
                  'assets/images/pega8.PNG',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('pega9', 2),
                child: new Image.asset(
                  'assets/images/pega9.PNG',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).highlightColor, width: 1.0))),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              child: IconButton(
                icon: Icon(FontAwesomeIcons.images),
                onPressed: getImage,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          // Button send sticker
          Material(
            child: Container(
              child: IconButton(
                icon: Icon(FontAwesomeIcons.stickyNote),
                onPressed: getSticker,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          // Input message
          Flexible(
            child: Container(
              padding: EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
              child: TextField(
                controller: textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: 100,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                ),
                focusNode: focusNode,
              ),
            ),
          ),
          // Button send message
          Material(
            child: Container(
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
      height: 50.0,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).highlightColor, width: 1.0))),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
      ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor)))
      : StreamBuilder(
          stream: Firestore.instance
              .collection('messages')
              .document(groupChatId)
              .collection(groupChatId)
              .orderBy('timestamp', descending: true)
              .limit(20)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor)));
            } else {
              listMessage = snapshot.data.documents;
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
                itemCount: snapshot.data.documents.length,
                reverse: true,
                controller: listScrollController,
              );
            }
          },
        ),
    );
  }
}

void markAsDone(BuildContext context, String postId, String doerId, User peer) async {

  var peerName = peer.displayName.substring(0, peer.displayName.indexOf(' '));

  var dialogResponse = await _dialogService.showConfirmationDialog(
    title: 'Mark as done',
    description: 'Is $peerName done?',
    confirmationTitle: 'Yes',
    cancelTitle: 'No',
  );

  if (dialogResponse.confirmed) {
    await Firestore.instance.collection('posts').document(postId).updateData({'fulfilledBy': doerId});

    generateSysMsg(postId, doerId, "✓ Marked as done.");

    rate(context, peer);

    _navigationService.navigateTo(HomeViewRoute);
  }
}

void generateSysMsg(String postId, String doerId, String message) {
  var groupChatId = '';
    var userId = _authenticationService.currentUser.uid;
    
    if (doerId.hashCode <= userId.hashCode) {
      groupChatId = '$postId-$doerId-$userId';
    } else {
      groupChatId = '$postId-$userId-$doerId';
    }

    var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        {
          'idFrom': doerId == _authenticationService.currentUser.uid ? doerId : userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': message,
          'type': 3
        },
      );
    });
}

Future<Null> rate(BuildContext context, User peer, [Task task]) async {
  var inputRating;
  switch (await showDialog(
    context: context,
    builder: (BuildContext context) {
      var peerName = peer.displayName.substring(0, peer.displayName.indexOf(' '));
      return SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        contentPadding: EdgeInsets.all(0),
        children: <Widget>[
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)), color: Theme.of(context).primaryColor),
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.only(bottom: 25.0, top: 25.0),
            height: 150.0,
            child: Column(
              children: <Widget>[
                Text(
                  'Rate $peerName',
                  style: Theme.of(context).textTheme.title
                ),
                verticalSpaceSmall,
                RatingBar(
                  minRating: 1,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    FontAwesomeIcons.solidStar,
                    color: Theme.of(context).accentColor,
                  ),
                  onRatingUpdate: (rating) {
                    inputRating = rating;
                    print(inputRating);
                  },
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 0);
            },
            child: Row(
              children: <Widget>[
                Container(
                  child: Icon(
                    FontAwesomeIcons.timesCircle,
                    color: Theme.of(context).primaryColor,
                  ),
                  margin: EdgeInsets.only(right: 10.0),
                ),
                Text('NOT NOW', style: Theme.of(context).textTheme.subtitle)
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 1);
            },
            child: Row(
              children: <Widget>[
                Container(
                  child: Icon(
                    FontAwesomeIcons.checkCircle,
                    color: Theme.of(context).primaryColor,
                  ),
                  margin: EdgeInsets.only(right: 10.0),
                ),
                Text('SUBMIT', style: Theme.of(context).textTheme.subtitle)
              ],
            ),
          ),
        ],
      );
    })) {
    case 0:
      break;
    case 1:

      addRating(task, inputRating);
      generateSysMsg(task.postId, peer.uid, "★ Rated $inputRating star/s.");

      if (_authenticationService.currentUser.uid == task.userId) {
        await Firestore.instance.collection('posts').document(task.postId).updateData({'userRated': true});
      } else await Firestore.instance.collection('posts').document(task.postId).updateData({'doerRated': true});

      _navigationService.navigateTo(HomeViewRoute);

      break;
  }
} 

Future addRating(Task task, double rate) async {
  try {
    
    var rating = Rating(
      transactionId: task.transactionId,
      ratingTo: _authenticationService.currentUser.uid == task.userId ? task.doerId : task.userId,
      rate: rate
    );

    await _firestoreService.addRating(rating);
    
  } catch (e) {}
}