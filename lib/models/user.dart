class User {
  final String uid;
  final String displayName;
  final String email;
  final String photoUrl;

  User({this.uid, this.displayName, this.email, this.photoUrl});

  User.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        displayName = data['displayName'],
        email = data['email'],
        photoUrl = data['photoUrl'];

  Map<String, dynamic> toJson() {
    return{
      'uid' : uid,
      'displayName' : displayName,
      'email' : email,
      'photoUrl' : photoUrl
    };
  }

}