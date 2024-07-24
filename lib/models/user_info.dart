class UserInfo {
  int userId;
  String? avatarUrl;
  String nickName;
  String gender;
  String? area;
  String? signature;

  UserInfo({
    required this.userId,
    this.avatarUrl,
    required this.nickName,
    required this.gender,
    this.area,
    this.signature,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json['user_id'],
      avatarUrl: json['avatar_url'],
      nickName: json['nick_name'],
      gender: json['gender'],
      area: json['area'],
      signature: json['signature'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['avatar_url'] = avatarUrl;
    data['nick_name'] = nickName;
    data['gender'] = gender;
    data['area'] = area;
    data['signature'] = signature;
    return data;
  }
}
