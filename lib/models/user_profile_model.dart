class UserProfile {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String photoUrl;

  UserProfile({
    required this.uid,
    required this.fullName,
    required this.email,
    this.phone = '',
    this.photoUrl = '',
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'photoUrl': photoUrl,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    uid: json['uid'] ?? '',
    fullName: json['fullName'] ?? '',
    email: json['email'] ?? '',
    phone: json['phone'] ?? '',
    photoUrl: json['photoUrl'] ?? '',
  );

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? photoUrl,
  }) {
    return UserProfile(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}