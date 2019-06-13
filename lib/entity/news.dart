
class NewsEntity{
  //编号
  int Id;
  //标题	string
  String Title;
  String Summary;
  int ViewCount;
  int CommentCount;
  int DiggCount;
  DateTime DateAdded;

  NewsEntity(this.Id,this.Title,this.ViewCount,this.DiggCount,this.CommentCount,this.DateAdded,this.Summary);

  NewsEntity.fromJson(Map<String, dynamic> json)
      : Id = int.parse(json['Id'].toString()),
        Title = json['Title'],
        Summary = json['Summary'],
        DateAdded = DateTime.parse(json['DateAdded'].toString()),
        ViewCount = int.parse(json['ViewCount'].toString()),
        DiggCount = int.parse(json['DiggCount'].toString()),
        CommentCount =int.parse(json['CommentCount'].toString());

  Map<String, dynamic> toJson() =>
      {
        'Id': Id,
        'Title': Title,
        'Summary': Summary,
        'DateAdded': DateAdded,
        'ViewCount': ViewCount,
        'DiggCount': DiggCount,
        'CommentCount': CommentCount,
      };
}