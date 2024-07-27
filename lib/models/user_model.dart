class UserModel {
  final String name;
  final String profilePic;
  final String email;
  final String uid;
  final String country;

  UserModel({
    required this.name,
    required this.uid,
    required this.country,
    required this.email,
    required this.profilePic,
  });

  UserModel copyWith({
    String? name,
    String? profilePic,
    String? email,
    String? country,
    String? uid,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      country: country ?? this.country,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'uid': uid,
      'name': name,
      'email': email,
      'profilePic': profilePic,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      country: map['country'] ?? '',
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profilePic: map['profilePic'] ?? '',
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, profilePic: $profilePic, email: $email, uidL $uid, country: $country)';
  }
}
