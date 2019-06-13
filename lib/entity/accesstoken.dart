
class AccessToken{
  String token_type;
  int expires_in;
  String access_token;
  String error;

  AccessToken(this.token_type, this.expires_in,this.access_token,this.error);

  AccessToken.fromJson(Map<String, dynamic> json)
      : token_type = json['token_type'],
        access_token = json['access_token'],
        error = json['error'],
        expires_in =int.parse(json['expires_in'].toString());

  Map<String, dynamic> toJson() =>
      {
        'token_type': token_type,
        'access_token': access_token,
        'error': error,
        'expires_in': expires_in,
      };
}