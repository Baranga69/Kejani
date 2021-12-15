class Details{

  final String email;
  final String username;
  final String phoneNumber;
  final String residence;
  final String imgUrl;
  final String userType;
  final DateTime lastMessageTime;

  Details({
    required this.userType,
    required this.lastMessageTime,
    required this.email,
    required this.username, 
    required this.phoneNumber,
    required this.residence,
    required this.imgUrl
    });

}

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}