class TokenData {
  String? sessionToken;
  String? accessToken;

  TokenData({this.sessionToken, this.accessToken});

  TokenData.fromJson(Map<String, dynamic> json) {
    sessionToken = json['sessionToken'];
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['sessionToken'] = this.sessionToken;
    data['accessToken'] = this.accessToken;
    return data;
  }
}
