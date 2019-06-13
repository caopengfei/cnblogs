class UserEntity {
  String Avatar;
  String DisplayName;
  String Token;

  UserEntity();
//  UserEntity(this.Token);
//  UserEntity(this.Name, this.Avatar, this.Token);

  UserEntity.fromJson(Map<String, dynamic> json)
      : DisplayName = json['DisplayName'],
        Avatar = json['Avatar'],
        Token = json['Token'];
  Map<String, dynamic> toJson() => {
        'DisplayName': DisplayName,
        'Avatar': Avatar,
        'Token': Token,
      };
}
