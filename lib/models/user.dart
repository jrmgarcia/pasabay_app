class User {
  final String uid;
  final String displayName;
  final String email;
  final String photoUrl;
  final double rating;
  final List<String> blacklist;

  User({this.uid, this.displayName, this.email, this.photoUrl, this.rating, this.blacklist});

  User.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        displayName = data['displayName'],
        email = data['email'],
        photoUrl = data['photoUrl'],
        rating = data['rating'],
        blacklist = data['blacklist'];

  Map<String, dynamic> toJson() {
    return{
      'uid' : uid,
      'displayName' : displayName,
      'email' : email,
      'photoUrl' : photoUrl,
      'rating' : rating
    };
  }

}