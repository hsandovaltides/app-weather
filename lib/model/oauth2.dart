class Oauth2Model {
  Oauth2Model(
      {required this.tokenType, required this.expiresIn, required this.extExpiresIn, required this.accessToken, required this.expireEpochTime});

  factory Oauth2Model.fromJson(Map<String, dynamic> json) {
    return Oauth2Model(
        tokenType: json["token_type"] as String,
        expiresIn: json["expires_in"] as int,
        extExpiresIn: json["ext_expires_in"] as int,
        accessToken: json["access_token"] as String,
        expireEpochTime: json["expireEpochTime"] ?? 0);
  }

  Map<String, dynamic> toJson() => {
        'token_type': tokenType,
        'expires_in': expiresIn,
        'ext_expires_in': extExpiresIn,
        'access_token': accessToken,
        'expireEpochTime': expireEpochTime
      };

  final String tokenType;
  final int expiresIn;
  final int extExpiresIn;
  final String accessToken;
  int expireEpochTime;
}
